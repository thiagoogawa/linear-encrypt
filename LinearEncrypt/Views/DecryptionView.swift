//
//  DecryptionView.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import SwiftUI

struct DecryptionView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject private var viewModel = CryptoViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header
                HStack {
                    Button(action: {
                        appViewModel.navigateToHome()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "lock.open.fill")
                            .font(.title)
                            .foregroundColor(.indigo)
                        
                        Text("Descriptografar Texto")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    Button("Limpar") {
                        viewModel.clearFields()
                    }
                    .foregroundColor(.red)
                }
                .padding(.horizontal)
                .padding(.top)
                
                Divider()
                
                MatrixSizePickerView(viewModel: viewModel)
                MatrixInputView(viewModel: viewModel)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Texto Criptografado:")
                        .font(.headline)
                    
                    TextEditor(text: $viewModel.inputText)
                        .frame(minHeight: 100)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .font(.monospaced(.body)())
                }
                .padding(.horizontal)
                
                Button(action: {
                    viewModel.performDecryption()
                }) {
                    HStack {
                        Image(systemName: "lock.open.fill")
                        Text("Descriptografar")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.indigo, Color.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .disabled(viewModel.inputText.isEmpty || viewModel.matrixInput.isEmpty)
                
                if !viewModel.resultText.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Texto Descriptografado:")
                            .font(.headline)
                        
                        Text(viewModel.resultText)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                            .font(.monospaced(.body)())
                    }
                    .padding(.horizontal)
                }
                
                InfoView()
            }
        }
        .alert("Erro", isPresented: $viewModel.showAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

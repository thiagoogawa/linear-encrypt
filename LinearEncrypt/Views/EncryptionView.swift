//
//  EncryptionView.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import SwiftUI

struct EncryptionView: View {
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
                        Image(systemName: "lock.circle.fill")
                            .font(.title)
                            .foregroundColor(.cyan)
                        
                        Text("Criptografar Texto")
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
                    Text("Texto Original:")
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
                    viewModel.performEncryption()
                }) {
                    HStack {
                        Image(systemName: "lock.fill")
                        Text("Criptografar")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.cyan, Color.blue],
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
                        Text("Texto Criptografado:")
                            .font(.headline)
                        
                        Text(viewModel.resultText)
                            .padding()
                            .background(Color.green.opacity(0.1))
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

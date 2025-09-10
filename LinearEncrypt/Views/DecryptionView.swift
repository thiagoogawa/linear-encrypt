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
    @State private var isNavigating = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header
                HStack {
                    Button(action: {
                        // Animação suave antes de navegar
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isNavigating = true
                        }
                        
                        // Delay para permitir que a animação complete antes de navegar
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            appViewModel.navigateToHome()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                        }
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.blue.opacity(0.1))
                                .scaleEffect(isNavigating ? 1.1 : 1.0)
                        )
                        .scaleEffect(isNavigating ? 0.95 : 1.0)
                        .opacity(isNavigating ? 0.7 : 1.0)
                    }
                    .animation(.easeInOut(duration: 0.2), value: isNavigating)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                .overlay(
                    // Conteúdo centralizado
                    VStack {
                        Image(systemName: "lock.open.fill")
                            .font(.title)
                            .foregroundColor(.cyan)
                            .scaleEffect(isNavigating ? 0.9 : 1.0)
                            .opacity(isNavigating ? 0.5 : 1.0)
                        
                        Text("Descriptografar Texto")
                            .font(.title2)
                            .fontWeight(.bold)
                            .scaleEffect(isNavigating ? 0.9 : 1.0)
                            .opacity(isNavigating ? 0.5 : 1.0)
                    }
                        .animation(.easeInOut(duration: 0.3), value: isNavigating)
                )
                
                Divider()
                    .opacity(isNavigating ? 0.3 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isNavigating)
                
                // Conteúdo principal com animação de fade out
                VStack(spacing: 25) {
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
                    
                    Button(action: {
                        viewModel.clearFields()
                    }) {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Limpar")
                                .fontWeight(.semibold)
                        }
                        .frame(width: 100)
                        .padding(8)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
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
                .scaleEffect(isNavigating ? 0.95 : 1.0)
                .opacity(isNavigating ? 0.3 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isNavigating)
            }
        }
        .alert("Erro", isPresented: $viewModel.showAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

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
    @State private var showCopyToast = false
    @State private var isDecryptingPressed = false
    @State private var isClearingPressed = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isNavigating = true
                            }
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
                        VStack {
                            Image(systemName: "lock.open.fill")
                                .font(.title)
                                .foregroundColor(.cyan)
                                .scaleEffect(isNavigating ? 0.9 : 1.0)
                                .opacity(isNavigating ? 0.5 : 1.0)
                            
                            Text("Decrypt Text")
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
                    
                    VStack(spacing: 25) {
                        MatrixSizePickerView(viewModel: viewModel)
                        MatrixInputView(viewModel: viewModel)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Encrypted Text:")
                                .font(.headline)
                            
                            TextEditor(text: $viewModel.inputText)
                                .frame(minHeight: 100)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .font(.monospaced(.body)())
                        }
                        .padding(.horizontal)
                        
                        // HStack with side-by-side buttons
                        HStack(spacing: 15) {
                            Button(action: {
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                                    isDecryptingPressed = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    withAnimation(.spring()) {
                                        isDecryptingPressed = false
                                    }
                                    viewModel.performDecryption()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "lock.open.fill")
                                    Text("Decrypt")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    LinearGradient(
                                        colors: [Color.indigo, Color.purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .scaleEffect(isDecryptingPressed ? 0.95 : 1.0)
                            }
                            .disabled(viewModel.inputText.isEmpty || viewModel.matrixInput.isEmpty)
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                                    isClearingPressed = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    withAnimation(.spring()) {
                                        isClearingPressed = false
                                    }
                                    viewModel.clearFields()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                    Text("Clear")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .scaleEffect(isClearingPressed ? 0.95 : 1.0)
                            }
                        }
                        .padding(.horizontal)
                        
                        if !viewModel.resultText.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Decrypted Text:")
                                    .font(.headline)
                                
                                Text(viewModel.resultText)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                                    .font(.monospaced(.body)())
                                    .onTapGesture {
                                        UIPasteboard.general.string = viewModel.resultText
                                        withAnimation(.spring()) {
                                            showCopyToast = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            withAnimation(.easeOut) {
                                                showCopyToast = false
                                            }
                                        }
                                    }
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
            
            // "Copied!" Toast
            if showCopyToast {
                VStack {
                    Spacer()
                    Text("📋 Copied to clipboard")
                        .font(.subheadline)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 40)
                }
                .animation(.easeInOut, value: showCopyToast)
            }
        }
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}


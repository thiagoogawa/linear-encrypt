//
//  MatrixInputView.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//
import SwiftUI

struct MatrixInputView: View {
    @ObservedObject var viewModel: CryptoViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Encryption Matrix:")
                .font(.headline)
            
            Text("Enter the values separated by commas, one row at a time")
                .font(.caption)
                .foregroundColor(.secondary)
            
            TextEditor(text: $viewModel.matrixInput)
                .frame(height: 80)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .font(.monospaced(.body)())
        }
        .padding(.horizontal)
    }
}


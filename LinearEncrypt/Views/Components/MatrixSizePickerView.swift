//
//  MatrixSizePickerView.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//
import SwiftUI

struct MatrixSizePickerView: View {
    @ObservedObject var viewModel: CryptoViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tamanho da Matriz:")
                .font(.headline)
            
            Picker("Tamanho", selection: $viewModel.matrixSize) {
                Text("2x2").tag(2)
                Text("3x3").tag(3)
            }
            .pickerStyle(.segmented)
            .onChange(of: viewModel.matrixSize) { _, newValue in
                viewModel.updateMatrixInput(for: newValue)
            }
        }
        .padding(.horizontal)
    }
}

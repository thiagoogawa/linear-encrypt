//
//  CryptoViewModel.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import Foundation
import SwiftUI

@MainActor
class CryptoViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var matrixInput = "2,3\n1,2"
    @Published var resultText = ""
    @Published var matrixSize = 2
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let cryptoService = MatrixCryptoService()
    
    func updateMatrixInput(for size: Int) {
        switch size {
        case 2:
            matrixInput = "2,3\n1,2"
        case 3:
            matrixInput = "2,3,1\n1,2,1\n1,1,2"
        default:
            break
        }
    }
    
    func performEncryption() {
        do {
            let matrix = try parseMatrix()
            try cryptoService.initialize(with: matrix)
            resultText = try cryptoService.encrypt(inputText)
        } catch {
            showError(error.localizedDescription)
        }
    }
    
    func performDecryption() {
        guard !inputText.isEmpty else {
            showError("Enter the encrypted text")
            return
        }
        
        do {
            let matrix = try parseMatrix()
            try cryptoService.initialize(with: matrix)
            resultText = try cryptoService.decrypt(inputText)
        } catch {
            showError(error.localizedDescription)
        }
    }
    
    func clearFields() {
        inputText = ""
        resultText = ""
    }
    
    private func parseMatrix() throws -> [[Int]] {
        let lines = matrixInput.components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        guard lines.count == matrixSize else {
            throw CryptoError.invalidMatrix("number of rows must be \(matrixSize)")
        }
        
        var matrix: [[Int]] = []
        
        for line in lines {
            let values = line.components(separatedBy: ",")
                .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            
            guard values.count == matrixSize else {
                throw CryptoError.invalidMatrix("each row must have \(matrixSize) values")
            }
            
            matrix.append(values)
        }
        
        return matrix
    }
    
    private func showError(_ message: String) {
        alertMessage = message
        showAlert = true
    }
}


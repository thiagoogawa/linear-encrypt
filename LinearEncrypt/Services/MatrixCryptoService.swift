//
//  MatrixCryptoService.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import Foundation

class MatrixCryptoService: ObservableObject {
    @Published var errorMessage: String = ""
    
    private var cryptoMatrix: CryptoMatrix?
    
    func initialize(with matrix: [[Int]]) throws {
        let cryptoMatrix = try CryptoMatrix(matrix)
        
        guard cryptoMatrix.isValidForCrypto(mod: CharsetManager.mod) else {
            throw CryptoError.invalidMatrix("does not have an inverse under modulo \(CharsetManager.mod)")
        }
        
        self.cryptoMatrix = cryptoMatrix
    }
    
    func encrypt(_ message: String) throws -> String {
        guard let matrix = cryptoMatrix else {
            throw CryptoError.matrixNotInitialized
        }
        
        guard CharsetManager.validateMessage(message) else {
            throw CryptoError.invalidCharacters("message contains unsupported characters")
        }
        
        let paddedMessage = MessageProcessor.padMessage(message, to: matrix.size)
        
        guard let numbers = CharsetManager.toNumbers(paddedMessage) else {
            throw CryptoError.encryptionFailed("failed to convert characters")
        }
        
        let messageMatrix = MessageProcessor.organizeToMatrix(numbers, matrixSize: matrix.size)
        let encryptedMatrix = MatrixMath.multiplyMatrices(matrix.values, messageMatrix, mod: CharsetManager.mod)
        let encryptedNumbers = MessageProcessor.flattenMatrix(encryptedMatrix)
        
        return CharsetManager.toString(encryptedNumbers)
    }
    
    func decrypt(_ encryptedMessage: String) throws -> String {
        guard let matrix = cryptoMatrix else {
            throw CryptoError.matrixNotInitialized
        }
        
        guard let numbers = CharsetManager.toNumbers(encryptedMessage) else {
            throw CryptoError.decryptionFailed("message contains invalid characters")
        }
        
        guard let invMatrix = MatrixMath.calculateInverseMatrix(
            matrix.values,
            determinant: matrix.determinant,
            mod: CharsetManager.mod
        ) else {
            throw CryptoError.decryptionFailed("could not calculate inverse matrix")
        }
        
        let encMessageMatrix = MessageProcessor.organizeToMatrix(numbers, matrixSize: matrix.size)
        let decryptedMatrix = MatrixMath.multiplyMatrices(invMatrix, encMessageMatrix, mod: CharsetManager.mod)
        let decryptedNumbers = MessageProcessor.flattenMatrix(decryptedMatrix)
        let decryptedMessage = CharsetManager.toString(decryptedNumbers)
        
        return MessageProcessor.unpadMessage(decryptedMessage)
    }
}



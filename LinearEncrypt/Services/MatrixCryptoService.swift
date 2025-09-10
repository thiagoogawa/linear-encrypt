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
            throw CryptoError.invalidMatrix("não possui inversa no módulo \(CharsetManager.mod)")
        }
        
        self.cryptoMatrix = cryptoMatrix
    }
    
    func encrypt(_ message: String) throws -> String {
        guard let matrix = cryptoMatrix else {
            throw CryptoError.matrixNotInitialized
        }
        
        guard CharsetManager.validateMessage(message) else {
            throw CryptoError.invalidCharacters("mensagem contém caracteres não suportados")
        }
        
        let paddedMessage = MessageProcessor.padMessage(message, to: matrix.size)
        
        guard let numbers = CharsetManager.toNumbers(paddedMessage) else {
            throw CryptoError.encryptionFailed("falha ao converter caracteres")
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
            throw CryptoError.decryptionFailed("mensagem contém caracteres inválidos")
        }
        
        guard let invMatrix = MatrixMath.calculateInverseMatrix(
            matrix.values,
            determinant: matrix.determinant,
            mod: CharsetManager.mod
        ) else {
            throw CryptoError.decryptionFailed("não foi possível calcular a matriz inversa")
        }
        
        let encMessageMatrix = MessageProcessor.organizeToMatrix(numbers, matrixSize: matrix.size)
        let decryptedMatrix = MatrixMath.multiplyMatrices(invMatrix, encMessageMatrix, mod: CharsetManager.mod)
        let decryptedNumbers = MessageProcessor.flattenMatrix(decryptedMatrix)
        let decryptedMessage = CharsetManager.toString(decryptedNumbers)
        
        return MessageProcessor.unpadMessage(decryptedMessage)
    }
}


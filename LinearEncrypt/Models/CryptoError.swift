//
//  CryptoError.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import Foundation

enum CryptoError: Error, LocalizedError {
    case invalidMatrix(String)
    case invalidCharacters(String)
    case matrixNotInitialized
    case encryptionFailed(String)
    case decryptionFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidMatrix(let message):
            return "Matriz inválida: \(message)"
        case .invalidCharacters(let message):
            return "Caracteres inválidos: \(message)"
        case .matrixNotInitialized:
            return "Matriz de criptografia não foi configurada"
        case .encryptionFailed(let message):
            return "Falha na criptografia: \(message)"
        case .decryptionFailed(let message):
            return "Falha na descriptografia: \(message)"
        }
    }
}

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
            return "Invalid matrix: \(message)"
        case .invalidCharacters(let message):
            return "Invalid characters: \(message)"
        case .matrixNotInitialized:
            return "Encryption matrix has not been set"
        case .encryptionFailed(let message):
            return "Encryption failed: \(message)"
        case .decryptionFailed(let message):
            return "Decryption failed: \(message)"
        }
    }
}

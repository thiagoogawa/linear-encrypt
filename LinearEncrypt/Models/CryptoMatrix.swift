//
//  CryptoMatrix.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import Foundation

struct CryptoMatrix {
    let values: [[Int]]
    let size: Int
    
    init(_ values: [[Int]]) throws {
        guard !values.isEmpty else {
            throw CryptoError.invalidMatrix("Matriz não pode estar vazia")
        }
        
        let size = values.count
        guard values.allSatisfy({ $0.count == size }) else {
            throw CryptoError.invalidMatrix("Matriz deve ser quadrada")
        }
        
        self.values = values
        self.size = size
    }
    
    var determinant: Int {
        MatrixMath.calculateDeterminant(values)
    }
    
    func isValidForCrypto(mod: Int) -> Bool {
        let det = determinant
        return MatrixMath.gcd(det % mod, mod) == 1
    }
}


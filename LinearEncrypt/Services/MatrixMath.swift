//
//  MatrixMath.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import Foundation

struct MatrixMath {
    
    // MARK: - Determinant Calculation
    static func calculateDeterminant(_ matrix: [[Int]]) -> Int {
        let n = matrix.count
        if n == 1 { return matrix[0][0] }
        if n == 2 {
            return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
        }
        
        var det = 0
        for i in 0..<n {
            let subMatrix = getSubMatrix(matrix, row: 0, col: i)
            let sign = (i % 2 == 0) ? 1 : -1
            det += sign * matrix[0][i] * calculateDeterminant(subMatrix)
        }
        return det
    }
    
    // MARK: - Matrix Operations
    static func getSubMatrix(_ matrix: [[Int]], row: Int, col: Int) -> [[Int]] {
        var result: [[Int]] = []
        for i in 0..<matrix.count where i != row {
            var newRow: [Int] = []
            for j in 0..<matrix[i].count where j != col {
                newRow.append(matrix[i][j])
            }
            result.append(newRow)
        }
        return result
    }
    
    static func multiplyMatrices(_ a: [[Int]], _ b: [[Int]], mod: Int) -> [[Int]] {
        let rowsA = a.count
        let colsA = a[0].count
        let colsB = b[0].count
        
        var result: [[Int]] = Array(repeating: Array(repeating: 0, count: colsB), count: rowsA)
        
        for i in 0..<rowsA {
            for j in 0..<colsB {
                for k in 0..<colsA {
                    result[i][j] = (result[i][j] + a[i][k] * b[k][j]) % mod
                }
            }
        }
        
        return result
    }
    
    static func calculateInverseMatrix(_ matrix: [[Int]], determinant: Int, mod: Int) -> [[Int]]? {
        guard let detInv = modularInverse(determinant, mod) else { return nil }
        
        let adjMatrix = calculateAdjugateMatrix(matrix, mod: mod)
        let size = matrix.count
        var invMatrix: [[Int]] = Array(repeating: Array(repeating: 0, count: size), count: size)
        
        for i in 0..<size {
            for j in 0..<size {
                invMatrix[i][j] = (detInv * adjMatrix[i][j]) % mod
                if invMatrix[i][j] < 0 {
                    invMatrix[i][j] += mod
                }
            }
        }
        
        return invMatrix
    }
    
    static func calculateAdjugateMatrix(_ matrix: [[Int]], mod: Int) -> [[Int]] {
        let size = matrix.count
        var adj: [[Int]] = Array(repeating: Array(repeating: 0, count: size), count: size)
        
        for i in 0..<size {
            for j in 0..<size {
                let subMatrix = getSubMatrix(matrix, row: i, col: j)
                let cofactor = calculateDeterminant(subMatrix)
                let sign = ((i + j) % 2 == 0) ? 1 : -1
                adj[j][i] = (sign * cofactor) % mod
                if adj[j][i] < 0 {
                    adj[j][i] += mod
                }
            }
        }
        
        return adj
    }
    
    // MARK: - Number Theory
    static func gcd(_ a: Int, _ b: Int) -> Int {
        if b == 0 { return abs(a) }
        return gcd(b, a % b)
    }
    
    static func modularInverse(_ a: Int, _ m: Int) -> Int? {
        let (gcd, x, _) = extendedGCD(a, m)
        if gcd != 1 { return nil }
        return ((x % m) + m) % m
    }
    
    static func extendedGCD(_ a: Int, _ b: Int) -> (gcd: Int, x: Int, y: Int) {
        if b == 0 { return (a, 1, 0) }
        let result = extendedGCD(b, a % b)
        return (result.gcd, result.y, result.x - (a / b) * result.y)
    }
}

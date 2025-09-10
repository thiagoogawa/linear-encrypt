//
//  MessageProcessor.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import Foundation

struct MessageProcessor {
    
    static func padMessage(_ message: String, to matrixSize: Int) -> String {
        let remainder = message.count % matrixSize
        let padQty = remainder == 0 ? 0 : matrixSize - remainder
        return message + String(repeating: " ", count: padQty)
    }
    
    static func unpadMessage(_ message: String) -> String {
        return message.trimmingCharacters(in: .whitespaces)
    }
    
    static func organizeToMatrix(_ numbers: [Int], matrixSize: Int) -> [[Int]] {
        let cols = numbers.count / matrixSize
        var matrix: [[Int]] = Array(repeating: Array(repeating: 0, count: cols), count: matrixSize)
        
        for i in 0..<numbers.count {
            let row = i % matrixSize
            let col = i / matrixSize
            matrix[row][col] = numbers[i]
        }
        
        return matrix
    }
    
    static func flattenMatrix(_ matrix: [[Int]]) -> [Int] {
        var numbers: [Int] = []
        for col in 0..<matrix[0].count {
            for row in 0..<matrix.count {
                numbers.append(matrix[row][col])
            }
        }
        return numbers
    }
}

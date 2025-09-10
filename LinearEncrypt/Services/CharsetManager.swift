//
//  CharsetManager.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import Foundation

struct CharsetManager {
    static let charset = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:'\",.<>?/`~ ")
    static let mod = charset.count
    
    static func toNumbers(_ message: String) -> [Int]? {
        var numbers: [Int] = []
        for char in message {
            if let index = charset.firstIndex(of: char) {
                numbers.append(charset.distance(from: charset.startIndex, to: index))
            } else {
                return nil
            }
        }
        return numbers
    }
    
    static func toString(_ numbers: [Int]) -> String {
        return String(numbers.map { charset[$0] })
    }
    
    static func validateMessage(_ message: String) -> Bool {
        return message.allSatisfy { charset.contains($0) }
    }
}

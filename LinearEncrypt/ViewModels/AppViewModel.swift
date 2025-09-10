//
//  AppViewModel.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import Foundation
import SwiftUI

@MainActor
class AppViewModel: ObservableObject {
    @Published var currentScreen: Screen = .home
    
    enum Screen {
        case home
        case encrypt
        case decrypt
    }
    
    func navigateToEncryption() {
        currentScreen = .encrypt
    }
    
    func navigateToDecryption() {
        currentScreen = .decrypt
    }
    
    func navigateToHome() {
        currentScreen = .home
    }
}

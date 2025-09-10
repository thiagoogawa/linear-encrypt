//
//  ContentView.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        NavigationView {
            switch appViewModel.currentScreen {
            case .home:
                HomeView(viewModel: appViewModel)
            case .encrypt:
                EncryptionView(appViewModel: appViewModel)
            case .decrypt:
                DecryptionView(appViewModel: appViewModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

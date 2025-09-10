//
//  HomeView.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.05, green: 0.05, blue: 0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo and title
                VStack(spacing: 20) {
                    // Lock icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.cyan, Color.blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "lock.fill")
                            .font(.system(size: 50, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .shadow(color: .cyan.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    Text("Criptografia")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 20) {
                    HomeButton(
                        title: "Criptografar texto",
                        icon: "lock.circle.fill",
                        colors: [Color.cyan, Color.blue],
                        action: {
                            viewModel.navigateToEncryption()
                        }
                    )
                    
                    HomeButton(
                        title: "Descriptografar texto",
                        icon: "lock.open.fill",
                        colors: [Color.indigo, Color.purple],
                        action: {
                            viewModel.navigateToDecryption()
                        }
                    )
                }
                
                Spacer()
                
                // Info text
                Text("Criptografia usando matrizes (Hill Cipher)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 30)
            }
            .padding(.horizontal, 30)
        }
    }
}

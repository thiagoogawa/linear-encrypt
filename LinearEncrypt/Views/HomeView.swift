//
//  HomeView.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var encryptButtonPressed = false
    @State private var decryptButtonPressed = false
    @State private var isTransitioning = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var pulseOpacity: Double = 0.6
    
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
                
                // Logo and title with pulse effect
                VStack(spacing: 20) {
                    // Lock icon with pulse
                    ZStack {
                        // Pulse rings
                        ForEach(0..<3) { index in
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.cyan.opacity(0.3), Color.blue.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                                .frame(width: 120, height: 120)
                                .scaleEffect(pulseScale + (CGFloat(index) * 0.3))
                                .opacity(pulseOpacity - (Double(index) * 0.2))
                                .animation(
                                    .easeInOut(duration: 2.0)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.3),
                                    value: pulseScale
                                )
                        }
                        
                        // Main circle
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.cyan, Color.blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .scaleEffect(isTransitioning ? 0.8 : 1.0)
                            .opacity(isTransitioning ? 0.6 : 1.0)
                        
                        // Subtle pulse overlay on main circle
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.3), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .scaleEffect(pulseScale * 0.9)
                            .opacity(pulseOpacity * 0.5)
                            .animation(
                                .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                                value: pulseScale
                            )
                        
                        Image(systemName: "lock.fill")
                            .font(.system(size: 50, weight: .semibold))
                            .foregroundColor(.white)
                            .scaleEffect(isTransitioning ? 0.8 : 1.0)
                            .opacity(isTransitioning ? 0.6 : 1.0)
                    }
                    .shadow(color: .cyan.opacity(0.3), radius: 20, x: 0, y: 10)
                    .onAppear {
                        // Start pulse animation
                        withAnimation {
                            pulseScale = 1.2
                            pulseOpacity = 0.2
                        }
                    }
                    
                    Text("Linear")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .scaleEffect(isTransitioning ? 0.9 : 1.0)
                        .opacity(isTransitioning ? 0.7 : 1.0)
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 20) {
                    // Encrypt button with animation
                    AnimatedHomeButton(
                        title: "Encrypt Text",
                        icon: "lock.circle.fill",
                        colors: [Color.cyan, Color.blue],
                        isPressed: $encryptButtonPressed,
                        isTransitioning: isTransitioning,
                        action: {
                            performTransition {
                                viewModel.navigateToEncryption()
                            }
                        }
                    )
                    
                    // Decrypt button with animation
                    AnimatedHomeButton(
                        title: "Decrypt Text",
                        icon: "lock.open.fill",
                        colors: [Color.indigo, Color.purple],
                        isPressed: $decryptButtonPressed,
                        isTransitioning: isTransitioning,
                        action: {
                            performTransition {
                                viewModel.navigateToDecryption()
                            }
                        }
                    )
                }
                .offset(y: isTransitioning ? 20 : 0)
                .opacity(isTransitioning ? 0 : 1.0)
                
                Spacer()
                
                // Info text
                Text("Matrix-based encryption (Hill Cipher)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 30)
                    .opacity(isTransitioning ? 0 : 1.0)
            }
            .padding(.horizontal, 30)
            
            // Transition overlay
            if isTransitioning {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.1),
                                Color.black.opacity(0.3),
                                Color.black.opacity(0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isTransitioning)
    }
    
    private func performTransition(completion: @escaping () -> Void) {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        withAnimation(.easeInOut(duration: 0.4)) {
            isTransitioning = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            completion()
            
            // Reset transition after navigation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isTransitioning = false
                }
            }
        }
    }
}

// Updated animated button component
struct AnimatedHomeButton: View {
    let title: String
    let icon: String
    let colors: [Color]
    @Binding var isPressed: Bool
    let isTransitioning: Bool
    let action: () -> Void
    
    @State private var buttonPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                buttonPressed = true
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                action()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        buttonPressed = false
                        isPressed = false
                    }
                }
            }
        }) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(buttonPressed ? 15 : 0))
                    .scaleEffect(buttonPressed ? 1.1 : 1.0)
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .scaleEffect(buttonPressed ? 1.02 : 1.0)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: buttonPressed ? colors.map { $0.opacity(0.9) } : colors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(buttonPressed ? 0.96 : 1.0)
                    .shadow(
                        color: colors.first?.opacity(buttonPressed ? 0.5 : 0.3) ?? .clear,
                        radius: buttonPressed ? 8 : 20,
                        x: 0,
                        y: buttonPressed ? 4 : 10
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: buttonPressed ? [Color.white.opacity(0.3), Color.clear] : [Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: buttonPressed ? 1 : 0
                    )
            )
        }
        .disabled(isTransitioning)
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.15), value: buttonPressed)
    }
}

// Optional particle effect extension
struct ParticleEffect: View {
    let colors: [Color]
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(colors.randomElement() ?? .cyan)
                    .frame(width: 4, height: 4)
                    .offset(
                        x: animate ? Double.random(in: -50...50) : 0,
                        y: animate ? Double.random(in: -50...50) : 0
                    )
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: Double.random(in: 0.5...1.0))
                        .delay(Double(index) * 0.1),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

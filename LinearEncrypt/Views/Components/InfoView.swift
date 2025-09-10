//
//  InfoView.swift
//  MatrixEncryption
//
//  Created by Thiago Ogawa on 09/09/25.
//
import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Caracteres Suportados:")
                .font(.headline)
            
            Text("Letras (A-Z, a-z), números (0-9), pontuação e espaço")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

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
            Text("Supported Characters:")
                .font(.headline)
            
            Text("Letters (A-Z, a-z), numbers (0-9), punctuation, and space")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

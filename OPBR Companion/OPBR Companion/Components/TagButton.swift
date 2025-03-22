//
//  TagButton.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 05/11/2024.
//

import SwiftUI

struct TagButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .padding(8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

//#Preview {
//    TagButton()
//}

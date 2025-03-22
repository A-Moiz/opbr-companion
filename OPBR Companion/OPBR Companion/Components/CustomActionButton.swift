//
//  CustomActionButton.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 21/03/2025.
//

import SwiftUI

struct CustomActionButton: View {
    let title: String
    let icon: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

//#Preview {
//    CustomActionButton()
//}

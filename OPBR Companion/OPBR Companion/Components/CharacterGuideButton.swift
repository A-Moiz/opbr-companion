//
//  CharacterGuideButton.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 21/03/2025.
//

import SwiftUI

struct CharacterGuideButton: View {
    let character: Character
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var alertTitle: String
    
    var body: some View {
        Button(action: {
            alertMessage = character.guide ?? "No guide available"
            alertTitle = "Character Guide Summary"
            showAlert = true
        }) {
            HStack {
                Image(systemName: "book.pages")
                Text("Character Guide")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

//#Preview {
//    CharacterGuideButton()
//}

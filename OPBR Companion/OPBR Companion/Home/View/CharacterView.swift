//
//  CharacterView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 01/11/2024.
//

import SwiftUI

struct CharacterView: View {
    var character: Character

    var body: some View {
        VStack(spacing: 20) {
            if let uiImage = UIImage(contentsOfFile: character.imageURL.path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            
            Text(character.title)
                .font(.title)
                .fontWeight(.bold)
            
//            Text("Name: \(character.name)")
//                .font(.headline)
//                .foregroundColor(.blue)
            
            Text("Tags: \(character.tags.joined(separator: ", "))")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Color: \(character.colour)")
                .font(.subheadline)
                .foregroundColor(.blue)
            
            Text("Class: \(character.characterClass)")
                .font(.subheadline)
                .foregroundColor(.blue)
            
            Spacer()
        }
        .padding()
        .navigationTitle(character.name)
    }
}

//#Preview {
//    CharacterView()
//}

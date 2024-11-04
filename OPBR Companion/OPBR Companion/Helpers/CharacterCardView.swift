//
//  CharacterCardView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

import SwiftUI

struct CharacterCardView: View {
    var character: Character
    @State private var uiImage: UIImage? = nil
    @Environment(\.colorScheme) private var colourScheme
    @ObservedObject var homeViewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 8) {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                    .cornerRadius(6)
                    .shadow(radius: 1)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 110, height: 110)
                    .cornerRadius(6)
                    .onAppear {
                        loadImage()
                    }
            }
            
            HStack(spacing: 4) {
                Text(character.name)
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.blue)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                if homeViewModel.isCharacterOwned(character) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption2)
                }
                
                if homeViewModel.isCharacterWanted(character) {
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.yellow)
                        .font(.caption2)
                }
            }
        }
        .frame(width: 110, height: 130)
        .padding(2)
        .background(colourScheme == .light ? .white : Color(.systemGray5))
        .cornerRadius(6)
        .shadow(radius: 1)
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        if let image = UIImage(contentsOfFile: character.imageURL.path) {
            self.uiImage = image
        } else {
            print("Image not found at path: \(character.imageURL.path)")
        }
    }
}

//#Preview {
//    CharacterCardView()
//}

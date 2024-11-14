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
    private let isSmallDevice = UIScreen.main.bounds.width < 375

    var body: some View {
        VStack(spacing: 8) {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth, height: imageHeight)
                    .cornerRadius(6)
                    .shadow(radius: 1)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: imageWidth, height: imageHeight)
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
        .frame(width: vStackWidth, height: vStackHeight)
        .padding(2)
        .background(colourScheme == .light ? .white : Color(.systemGray5))
        .cornerRadius(6)
        .shadow(radius: 1)
        .onAppear {
            loadImage()
        }
    }

    private var imageWidth: CGFloat {
        isSmallDevice ? 80 : 110
    }

    private var imageHeight: CGFloat {
        isSmallDevice ? 80 : 110
    }

    private var vStackWidth: CGFloat {
        isSmallDevice ? 90 : 100
    }

    private var vStackHeight: CGFloat {
        isSmallDevice ? 130 : 130
    }

    private func loadImage() {
        if let image = UIImage(contentsOfFile: character.imageURL.path) {
            self.uiImage = image
        } else {
            print("Image not found at path: \(character.imageURL.path)")
        }
    }
}

#Preview {
    CharacterCardView(
character: Character(
            imageURL: URL(string: "https://example.com/image.jpg")!,
            characterClass: "Warrior",
            colour: "Red",
            tags: ["Attack", "Speed"],
            name: "Luffy",
            title: "Captain",
            guide: nil,
            videoUrl: nil,
            medalURL: URL(string: "https://example.com/medal.jpg")!,
            medalTrait: "Power",
            medalTags: ["Boost"],
            recommendedSet: nil,
            setMessage: nil,
            recommededStats: nil,
            statMessage: nil
        ),
        homeViewModel: HomeViewModel())
}

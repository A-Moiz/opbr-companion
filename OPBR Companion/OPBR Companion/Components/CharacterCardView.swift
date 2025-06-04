//
//  CharacterCardView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

import SwiftUI
import Kingfisher

struct CharacterCardView: View {
    var character: Character
    @Environment(\.colorScheme) private var colourScheme
    private let isSmallDevice = UIScreen.main.bounds.width < 375

    var body: some View {
        VStack(spacing: 8) {
            KFImage(URL(string: character.artwork ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: imageWidth, height: imageHeight)
                .cornerRadius(6)
                .shadow(radius: 1)

            HStack(spacing: 4) {
                Text(character.name)
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.blue)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .frame(width: vStackWidth, height: vStackHeight)
        .padding(2)
        .background(colourScheme == .light ? .white : Color(.systemGray5))
        .cornerRadius(6)
        .shadow(radius: 1)
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
}

#Preview {
    CharacterCardView(character: Character(id: 0, artwork: "", characterClass: "", color: "", name: "", title: "", guide: "", recommendedSet: [""], setMessage: "", recommendedStats: "", statMessage: "", medal: "", medalTags: [""], medalTrait: "", characterTags: [""], altSets: [["", "", ""]]))
}

//
//  AllCharactersView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

import SwiftUI

struct AllCharactersView: View {
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    // View model
    @ObservedObject var db: Supabase
    @ObservedObject var helper: Helper
    // Colour filter options
    private let colorTags = ["Red", "Green", "Blue", "Light", "Dark"]
    // Filter tags
    @State private var selectedTag: String? = nil
    @State private var showClassTags: Bool = false
    // Filtering characters
    private var filteredCharacters: [Character] {
        var characters = db.characters
        if let selectedTag = selectedTag {
            characters = characters.filter { character in
                character.characterClass.contains(selectedTag)
            }
        }
        return characters
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showClassTags.toggle()
                }) {
                    HStack {
                        Text(showClassTags ? "Hide class" : "Show class")
                        Image(systemName: showClassTags ? "chevron.up" : "chevron.down")
                    }
                }
                .padding()
            }
            
            if showClassTags {
                HStack(spacing: 15) {
                    ForEach(["Attacker", "Runner", "Defender"], id: \.self) { tag in
                        TagButton(label: tag, isSelected: selectedTag == tag) {
                            selectedTag = (selectedTag == tag) ? nil : tag
                        }
                    }
                }
                .padding()
            }
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3), spacing: 8) {
                    if filteredCharacters.isEmpty {
                        Text("No characters match your search.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(filteredCharacters, id: \.artwork) { character in
                            NavigationLink(destination: CharacterView(character: character)) {
                                CharacterCardView(character: character)
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            .scrollIndicators(.hidden)
            
            InfoButton(infoMessage: "You can filter for characters by their class.\n\nNote: More characters will be added in the future.", helper: helper)
        }
        .padding(.top)
        .ignoresSafeArea(.keyboard, edges: .all)
        .background(colourScheme == .dark ? Color.black.opacity(0.95) : Color.gray.opacity(0.05))
    }
}

//#Preview {
//    AllCharactersView(homeVM: HomeViewModel())
//}

//
//  AllCharactersView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

import SwiftUI

struct AllCharactersView: View {
    // Search text
    @State private var searchText: String = ""
    @State private var text: String = "Search characters..."
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    // View model
    @ObservedObject var homeVM: HomeViewModel
    // Colour filter options
    private let colorTags = ["Red", "Green", "Blue", "Light", "Dark"]
    // Filter tags
    @State private var selectedTag: String? = nil
    @State private var selectedColor: String? = nil
    @State private var showClassTags: Bool = false
    @State private var showColourTags: Bool = false
    // Filtering characters
    private var filteredCharacters: [Character] {
        var characters = homeVM.characters
        
        if let selectedTag = selectedTag {
            characters = characters.filter { character in
                character.characterClass.contains(selectedTag)
            }
        }
        
        if let selectedColor = selectedColor {
            characters = characters.filter { character in
                character.colour.contains(selectedColor)
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
            
            HStack {
                Button(action: {
                    showColourTags.toggle()
                }) {
                    HStack {
                        Text(showColourTags ? "Hide colour" : "Show colour")
                        Image(systemName: showColourTags ? "chevron.up" : "chevron.down")
                    }
                }
                .padding()
            }
            
            if showColourTags {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(colorTags, id: \.self) { color in
                            TagButton(label: color, isSelected: selectedColor == color) {
                                selectedColor = (selectedColor == color) ? nil : color
                            }
                        }
                    }
                    .padding()
                }
            }
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3), spacing: 8) {
                    if filteredCharacters.isEmpty {
                        Text("No characters match your search.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(filteredCharacters, id: \.imageURL) { character in
                            NavigationLink(destination: CharacterView(homeVM: homeVM, character: character)) {
                                CharacterCardView(character: character, homeViewModel: homeVM)
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            .scrollIndicators(.hidden)
            
            InfoButton(infoMessage: "You can filter for characters by class and colour.\n\nNote: More characters will be added in the future.", homeVM: homeVM)
        }
        .padding(.top)
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

#Preview {
    AllCharactersView(homeVM: HomeViewModel())
}

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
    // Filtering characters
    private var filteredCharacters: [Character] {
        var characters = homeVM.characters
        
        if !searchText.isEmpty {
            characters = characters.filter { character in
                character.characterClass.localizedCaseInsensitiveContains(searchText) ||
                character.colour.localizedCaseInsensitiveContains(searchText) ||
                character.name.localizedCaseInsensitiveContains(searchText) ||
                character.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return characters
    }
    
    var body: some View {
        VStack {
            // Search bar
            VStack {
                Text("You can search for characters by class, colour, name or title")
                    .foregroundStyle(.gray)
                    .padding()
                SearchBar(searchText: $searchText, text: $text)
            }
            
            Divider()
            
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
                .padding(.bottom, 8)
            }
            .scrollIndicators(.hidden)
            
            Text("NOTE: More characters will be added in the future.")
                .font(.subheadline)
                .padding()
        }
        .padding(.top)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    AllCharactersView(homeVM: HomeViewModel())
}

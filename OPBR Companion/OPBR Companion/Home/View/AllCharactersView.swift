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
    
    private var filteredCharacters: [Character] {
        if searchText.isEmpty {
            return homeVM.characters
        } else {
            return homeVM.characters.filter { character in
                character.characterClass.localizedCaseInsensitiveContains(searchText) ||
                character.colour.localizedCaseInsensitiveContains(searchText) ||
                character.name.localizedCaseInsensitiveContains(searchText) ||
                character.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("You can search for characters based on their class, colour, name, or title, such as 'Runner', 'Red', 'Luffy' or 'Egghead'.")
                    .foregroundStyle(.gray)
                    .padding()
                SearchBar(searchText: $searchText, text: $text)
            }
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3), spacing: 8) {
                    if filteredCharacters.isEmpty {
                        Text("No characters match your search.")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .gridCellColumns(3)
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
        }
    }
}

#Preview {
    AllCharactersView(homeVM: HomeViewModel())
}

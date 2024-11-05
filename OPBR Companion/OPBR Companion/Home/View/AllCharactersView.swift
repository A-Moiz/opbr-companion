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
    // Filter tag
    @State private var selectedIndex: Int? = nil
    @State private var selectedTag: String? = nil
    @State private var showTags: Bool = false
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    // View model
    @ObservedObject var homeVM: HomeViewModel
    
    // Filtering characters
    private var filteredCharacters: [Character] {
        var characters = homeVM.characters
        
        if let tag = selectedTag {
            characters = characters.filter { character in
                character.tags.contains(tag)
            }
        }
        
        if !searchText.isEmpty {
            characters = characters.filter { character in
                character.characterClass.localizedCaseInsensitiveContains(searchText) ||
                character.colour.localizedCaseInsensitiveContains(searchText) ||
                character.name.localizedCaseInsensitiveContains(searchText) ||
                character.title.localizedCaseInsensitiveContains(searchText) ||
                character.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            }
        }
        
        return characters
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showTags.toggle()
                    if !showTags {
                        selectedTag = nil
                    }
                }) {
                    HStack {
                        Text(showTags ? "Hide character tags" : "Show character tags")
                        Image(systemName: showTags ? "chevron.up" : "chevron.down")
                    }
                }
                .padding()
            }
            
            if showTags {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(homeVM.supportTagsArray.indices, id: \.self) { index in
                            let tag = homeVM.supportTagsArray[index].0
                            TagButton(label: tag, isSelected: selectedTag == tag) {
                                selectedTag = (selectedTag == tag) ? nil : tag
                                searchText = ""
                            }
                        }
                    }
                    .padding()
                }
            }
            
            VStack {
                Text("You can search for characters by class, colour, name, title, or shared medal tags—like “Runner,” “Red,” “Luffy,” or “Egghead.")
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
        .padding(.top)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    AllCharactersView(homeVM: HomeViewModel())
}

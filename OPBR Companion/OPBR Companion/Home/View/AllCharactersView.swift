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
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    // View model
    @ObservedObject var homeVM: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search characters...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                Image(systemName: "x.circle")
                    .onTapGesture {
                        searchText = ""
                    }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding()
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                    if homeVM.characterImages.isEmpty {
                        Text("No images available.")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .gridCellColumns(3)
                    } else {
                        ForEach(homeVM.characterImages, id: \.imageURL) { image in
                            NavigationLink(destination: CharacterView(homeVM: homeVM, character: image)) {
                                CharacterCardView(character: image)
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

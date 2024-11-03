//
//  OwnedCharactersView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

import SwiftUI

struct OwnedCharactersView: View {
    // View model
    @ObservedObject var homeVM: HomeViewModel
    // Container
    let containerIdentifier = "iCloud.OPBR-Companion"
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Your Owned Characters")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                if homeVM.ownedCharacters.isEmpty {
                    Text("No owned characters.")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3), spacing: 8) {
                            ForEach(homeVM.ownedCharacters, id: \.imageURL) { character in
                                CharacterCardView(character: character)
                            }
                        }
                        .padding(.horizontal, 4)
                        .padding(.bottom, 8)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { Task {
                        homeVM.loadOwnedCharacters()
                        homeVM.fetchAllCharacters(from: containerIdentifier)
                    } }) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
            }
            .onAppear {
                homeVM.loadOwnedCharacters()
                homeVM.fetchAllCharacters(from: containerIdentifier)
            }
        }
    }
}

//#Preview {
//    OwnedCharactersView()
//}

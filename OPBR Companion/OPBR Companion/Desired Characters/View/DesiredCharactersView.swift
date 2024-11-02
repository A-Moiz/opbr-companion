//
//  DesiredCharactersView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

import SwiftUI

struct DesiredCharactersView: View {
    @ObservedObject var homeVM: HomeViewModel
    
    var body: some View {
        VStack {
            Text("Your Desired Characters")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            if homeVM.wantedCharacters.isEmpty {
                Text("No desired characters.")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                        ForEach(homeVM.wantedCharacters, id: \.imageURL) { character in
                            CharacterCardView(character: character)
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 8)
                }
            }
        }
        .onAppear {
            homeVM.loadWantedCharacters()
        }
    }
}

//#Preview {
//    DesiredCharactersView()
//}

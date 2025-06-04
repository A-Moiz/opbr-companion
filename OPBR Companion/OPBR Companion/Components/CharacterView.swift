//
//  CharacterView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 01/11/2024.
//

import SwiftUI
import Kingfisher

struct CharacterView: View {
    // Character
    var character: Character
    // Alerts
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    // Views
    @State private var showMedalTagsView: Bool = false
    @State private var showSupportTagsView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                characterArtwork
                
                characterDetails
                
                CustomActionButton(
                    title: "Character Guide",
                    icon: "book.pages",
                    backgroundColor: .blue,
                    action: {
                        alertMessage = character.guide ?? "No guide available"
                        alertTitle = "Character Guide Summary"
                        showAlert = true
                    }
                )
                
                Spacer()
            }
            .padding()
            .navigationTitle(character.name)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .background(Color(UIColor.systemGray6))
    }
    
    private var characterArtwork: some View {
        Group {
            if let artwork = character.artwork, let artworkURL = URL(string: artwork) {
                KFImage(artworkURL)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            } else {
                Text("No Character artwork available")
            }
        }
    }
    
    private var characterDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(character.title)
                .font(.title)
                .fontWeight(.bold)
            
            CharacterTagsView(tags: character.characterTags ?? [""])
            
            Divider()
            
            HStack {
                Image(systemName: "paintpalette")
                Text("Color: \(character.color)")
            }
            .font(.subheadline)
            
            HStack {
                Image(systemName: "person.crop.square")
                Text("Class: \(character.characterClass)")
            }
            .font(.subheadline)
            
            Divider()
            
            MedalSectionView(character: character)
            
            Divider()
            
            recommendedSetView
            
            Divider()
            
            RecommendedStatView(recommendedStats: character.recommendedStats ?? "", statMessage: character.statMessage ?? "")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground).opacity(0.8))
        .cornerRadius(10)
    }
    
    private var recommendedSetView: some View {
        Group {
            if let recommendedSet = character.recommendedSet,
               !recommendedSet.isEmpty,
               let setMessage = character.setMessage,
               !setMessage.isEmpty {

                let recommendedSetURLs = recommendedSet.compactMap { URL(string: $0) }

                let altSetURLs: [[URL]] = character.altSets?.map { innerArray in
                    innerArray.compactMap { URL(string: $0) }
                } ?? []

                RecommendedSetView(recommendedSet: recommendedSetURLs, altSets: altSetURLs, setMessage: setMessage)
            }
        }
    }
}

//#Preview {
//    CharacterView()
//}

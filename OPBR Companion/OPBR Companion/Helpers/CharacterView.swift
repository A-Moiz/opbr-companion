//
//  CharacterView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 01/11/2024.
//

import SwiftUI

struct CharacterView: View {
    @ObservedObject var homeVM: HomeViewModel
    var character: Character
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            if let uiImage = UIImage(contentsOfFile: character.imageURL.path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            
            Text(character.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text("Tags: \(character.tags.joined(separator: ", "))")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Color: \(character.colour)")
                .font(.subheadline)
                .foregroundColor(.blue)
            
            Text("Class: \(character.characterClass)")
                .font(.subheadline)
                .foregroundColor(.blue)
            
            Button {
                alertMessage = character.guide ?? "No guide available"
                showAlert = true
            } label: {
                Text("Character Guide")
            }
            
//            if let guide = character.guide {
//                Text("Character guide: \(guide)")
//                    .font(.caption)
//                    .foregroundColor(.blue)
//            }
            
            if character.videoUrl != nil {
                if let videoUrl = URL(string: character.videoUrl ?? "") {
                    Link("Click here for video guide", destination: videoUrl)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .underline()
                }
            }
            
            VStack {
                if !homeVM.isCharacterWanted(character) {
                    Text("Keep track of users you own")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        homeVM.toggleCharacterOwnership(for: character)
                    }) {
                        HStack {
                            Image(systemName: homeVM.isCharacterOwned(character) ? "checkmark.square.fill" : "square")
                            Text(homeVM.isCharacterOwned(character) ? "Owned" : "Mark as Owned")
                        }
                        .padding()
                        .background(homeVM.isCharacterOwned(character) ? Color.green : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            
            if !homeVM.isCharacterOwned(character) {
                Text("Mark characters you want/need. This can be to play them or because you need them for support.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button(action: {
                    homeVM.toggleCharacterWant(for: character)
                }) {
                    HStack {
                        Image(systemName: homeVM.isCharacterWanted(character) ? "star.fill" : "star")
                        Text(homeVM.isCharacterWanted(character) ? "Wanted" : "Mark as Wanted")
                    }
                    .padding()
                    .background(homeVM.isCharacterWanted(character) ? Color.yellow : Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(character.name)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Character Guide Summary"), message: Text(alertMessage))
        }
    }
}

//#Preview {
//    CharacterView()
//}

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
        ScrollView {
            VStack(spacing: 20) {
                
                // Character Image
                if let uiImage = UIImage(contentsOfFile: character.imageURL.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                
                // Character Info Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(character.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "tag")
                        Text("Tags: \(character.tags.joined(separator: ", "))")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "paintpalette")
                        Text("Color: \(character.colour)")
                            .foregroundColor(.blue)
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Image(systemName: "person.crop.square")
                        Text("Class: \(character.characterClass)")
                            .foregroundColor(.blue)
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemBackground).opacity(0.8))
                .cornerRadius(10)
                
                VStack(spacing: 16) {
                    HStack {
                        Button(action: {
                            alertMessage = character.guide ?? "No guide available"
                            showAlert = true
                        }) {
                            HStack {
                                Image(systemName: "book.pages")
                                Text("Character Guide")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    
                    if let videoUrl = URL(string: character.videoUrl ?? "") {
                        HStack {
                            Button(action: {
                                videoGuide(videoUrl: videoUrl)
                            }) {
                                HStack {
                                    Image(systemName: "video")
                                    Text("Watch Video Guide")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                    }
                    
                    HStack {
                        if !homeVM.isCharacterWanted(character) {
                            Button(action: {
                                homeVM.toggleCharacterOwnership(for: character)
                            }) {
                                HStack {
                                    Image(systemName: homeVM.isCharacterOwned(character) ? "checkmark.square.fill" : "square")
                                    Text(homeVM.isCharacterOwned(character) ? "Owned" : "Mark as Owned")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                    }
                    
                    HStack {
                        if !homeVM.isCharacterOwned(character) {
                            Button(action: {
                                homeVM.toggleCharacterWant(for: character)
                            }) {
                                HStack {
                                    Image(systemName: homeVM.isCharacterWanted(character) ? "star.fill" : "star")
                                    Text(homeVM.isCharacterWanted(character) ? "Wanted" : "Mark as Wanted")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle(character.name)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Character Guide Summary"), message: Text(alertMessage))
            }
        }
        .background(Color(UIColor.systemGray6))
    }
    
    func videoGuide(videoUrl: URL) {
        UIApplication.shared.open(videoUrl, options: [:], completionHandler: nil)
    }
}

//#Preview {
//    CharacterView()
//}

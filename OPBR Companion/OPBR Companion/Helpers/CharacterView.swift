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
    @State private var alertTitle: String = ""
    @State private var showMedalTagsView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let uiImage = UIImage(contentsOfFile: character.imageURL.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(character.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    VStack {
                        HStack {
                            Image(systemName: "tag")
                            Text("Character Tags:")
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(character.tags, id: \.self) { tag in
                                Text(tag)
                                    .foregroundColor(.blue)
                                    .font(.system(size: 20))
                                    .onTapGesture {
                                        if let message = homeVM.getSupportMessage(for: tag) {
                                            alertMessage = message
                                            alertTitle = "\(tag) Support Tag"
                                            showAlert = true
                                        }
                                    }
                            }
                        }
                        
                    }
                    .padding(.vertical)
                    
                    Divider()
                    
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
                    
                    Divider()
                    
                    VStack {
                        HStack {
                            if let medal = UIImage(contentsOfFile: character.medalURL.path) {
                                Image(uiImage: medal)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 75, height: 75)
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                            }
                            
                            HStack {
                                Image(systemName: "medal")
                                Text("Medal trait: \(character.medalTrait)")
                            }
                            .font(.subheadline)
                        }
                        
                        VStack {
                            HStack {
                                Image(systemName: "tag")
                                Text("Medal Tags:")
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(character.medalTags, id: \.self) { tag in
                                    Text(tag)
                                        .foregroundColor(.blue)
                                        .font(.system(size: 20))
                                        .onTapGesture {
                                            if let message = homeVM.getMedalMessage(for: tag) {
                                                alertMessage = message
                                                alertTitle = "\(tag) Medal Tag"
                                                showAlert = true
                                            }
                                        }
                                }
                            }
                            
                        }
                        .padding(.vertical)
                    }
                    .padding()
                    
                    if let recommendedSet = character.recommendedSet, !recommendedSet.isEmpty {
                        Divider()
                        VStack(alignment: .leading) {
                            Text("Recommended Set")
                                .font(.headline)
                                .padding(.bottom, 5)
                            
                            HStack(spacing: 15) {
                                ForEach(recommendedSet, id: \.self) { url in
                                    if let uiImage = UIImage(contentsOfFile: url.path) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 75, height: 75)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 75, height: 75)
                                            .cornerRadius(10)
                                            .overlay(Text("Image unavailable").font(.caption).foregroundColor(.gray))
                                    }
                                }
                            }
                            
                            Text("This set provides a well-rounded boost to skill 1 cooldown and capture speed, ideal for helping this runner continuously capture flags and stay on the move.")
                            
                            Text("Note that these recommendations may change as more medals are introduced to the game")
                                .padding(.top)
                        }
                        .padding()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemBackground).opacity(0.8))
                .cornerRadius(10)
                
                VStack(spacing: 16) {
                    HStack {
                        Button(action: {
                            alertMessage = character.guide ?? "No guide available"
                            alertTitle = "Character Guide Summary"
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
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // Refresh Feed
                Button(action: {
                    showMedalTagsView = true
                }) {
                    Label("View All Medal Tags", systemImage: "tablecells")
                }
            }
        }
        .sheet(isPresented: $showMedalTagsView) {
            MedalTagsView(homeVM: homeVM)
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

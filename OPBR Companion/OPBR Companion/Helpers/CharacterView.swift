//
//  CharacterView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 01/11/2024.
//

import SwiftUI

struct CharacterView: View {
    // View model
    @ObservedObject var homeVM: HomeViewModel
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
                    
                    CharacterTagsView(tags: character.tags, homeVM: homeVM, showAlert: $showAlert, alertMessage: $alertMessage, alertTitle: $alertTitle)
                    
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
                    
                    MedalSectionView(character: character, homeVM: homeVM, showAlert: $showAlert, alertMessage: $alertMessage, alertTitle: $alertTitle)
                    
                    if let recommendedSet = character.recommendedSet, !recommendedSet.isEmpty {
                        if let setMessage = character.setMessage, !setMessage.isEmpty {
                            Divider()
                            RecommendedSetView(recommendedSet: recommendedSet, setMessage: setMessage)
                        }
                    }
                    
                    if let recommendedStats = character.recommededStats, !recommendedStats.isEmpty {
                        if let statMessage = character.statMessage, !statMessage.isEmpty {
                            Divider()
                            RecommendedStatView(recommendedStats: recommendedStats, statMessage: statMessage)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemBackground).opacity(0.8))
                .cornerRadius(10)
                
                VStack(spacing: 16) {
                    // Character Guide Button
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
                    
                    // Video Guide Button
                    if let videoUrl = URL(string: character.videoUrl ?? "") {
                        CustomActionButton(
                            title: "Watch Video Guide",
                            icon: "video",
                            backgroundColor: .red,
                            action: {
                                homeVM.videoGuide(videoUrl: videoUrl)
                            }
                        )
                    }
                    
                    // Mark as Owned Button
                    if !homeVM.isCharacterWanted(character) {
                        CustomActionButton(
                            title: homeVM.isCharacterOwned(character) ? "Owned" : "Mark as Owned",
                            icon: homeVM.isCharacterOwned(character) ? "checkmark.square.fill" : "square",
                            backgroundColor: .green,
                            action: {
                                homeVM.toggleCharacterOwnership(for: character)
                            }
                        )
                    }
                    
                    // Mark as Wanted Button
                    if !homeVM.isCharacterOwned(character) {
                        CustomActionButton(
                            title: homeVM.isCharacterWanted(character) ? "Wanted" : "Mark as Wanted",
                            icon: homeVM.isCharacterWanted(character) ? "star.fill" : "star",
                            backgroundColor: .orange,
                            action: {
                                homeVM.toggleCharacterWant(for: character)
                            }
                        )
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
                Menu {
                    Button(action: {
                        showMedalTagsView = true
                    }) {
                        Label("View Medal Tags", systemImage: "tablecells")
                    }
                    
                    Button(action: {
                        showSupportTagsView = true
                    }) {
                        Label("View Support Tags", systemImage: "tablecells")
                    }
                } label: {
                    Label("Options", systemImage: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showMedalTagsView) {
            MedalTagsView(homeVM: homeVM)
        }
        .sheet(isPresented: $showSupportTagsView) {
            SupportTagsView(homeVM: homeVM)
        }
        .background(Color(UIColor.systemGray6))
    }
}

struct CharacterTagsView: View {
    let tags: [String]
    let homeVM: HomeViewModel
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var alertTitle: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "tag")
                Text("Character Tags:")
            }
            .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(tags, id: \.self) { tag in
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
    }
}

struct RecommendedSetView: View {
    let recommendedSet: [URL]
    let setMessage: String
    
    var body: some View {
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
            
            Text(setMessage)
            
            Text("Note that these recommendations may change as more medals are introduced to the game")
                .padding(.top)
        }
        .padding()
    }
}

struct RecommendedStatView: View {
    let recommendedStats: [String]
    let statMessage: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recommended Stats")
                .font(.headline)
                .padding(.bottom, 5)
            
            HStack(spacing: 4) {
                ForEach(recommendedStats, id: \.self) { stat in
                    Text(stat)
                        .font(.system(size: 20))
                }
            }
            
            Text(statMessage)
            
            Text("Note that these recommendations may change if this character gets buffed or nerfed in the future.")
                .padding(.top)
        }
        .padding()
    }
}

struct MedalSectionView: View {
    let character: Character
    let homeVM: HomeViewModel
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var alertTitle: String
    
    var body: some View {
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
            .padding(.vertical)
        }
        .padding()
    }
}

struct CharacterGuideButton: View {
    let character: Character
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var alertTitle: String
    
    var body: some View {
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
}

struct CustomActionButton: View {
    let title: String
    let icon: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

//#Preview {
//    CharacterView()
//}

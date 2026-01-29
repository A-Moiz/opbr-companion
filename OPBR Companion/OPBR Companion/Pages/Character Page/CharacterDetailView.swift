//
//  CharacterDetailView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 18/01/2026.
//

import SwiftUI
import Kingfisher

struct CharacterDetailView: View {
    @Environment(Database.self) var db
    let character: Character
    
    var body: some View {
        ScrollView {
            if db.appSettings?.showArtworks ?? false {
                CharacterHeroHeader(artwork: character.artwork, title: character.title, tags: character.characterTags ?? [])
            } else {
                AltCharacterHeroHeader(title: character.title, tags: character.characterTags ?? [])
            }
            
            CharacterInfo(characterClass: character.characterClass, color: character.color)
            
            CharacterMedal(character: character)
            
            RecommendedSet(character: character)
            
            RecommendedStats(character: character)
            
            if let guide = character.guide, !guide.isEmpty {
                CharacterGuide(character: character)
            }
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar)
    }
}

// MARK: - Character Header section
struct CharacterHeroHeader: View {
    let artwork: String?
    let title: String
    let tags: [String]
    
    var body: some View {
        VStack {
            if let artworkURL = URL(string: artwork ?? "") {
                KFImage(artworkURL)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 380)
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            } else {
                RoundedRectangle(cornerRadius: 32)
                    .fill(.ultraThinMaterial)
                    .frame(height: 380)
            }
            
            VStack {
                Text(title)
                    .font(.title2.bold())
                
                TagsView(tags: tags)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
    }
}

// MARK: - Alt Character Header section
struct AltCharacterHeroHeader: View {
    let title: String
    let tags: [String]
    
    var body: some View {
        VStack {
            
            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color.accentColor.opacity(0.15))
                
                Image(systemName: "person.fill")
                    .font(.system(size: 96, weight: .regular))
                    .foregroundStyle(Color.accentColor)
            }
            .frame(height: 380)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2.bold())
                
                TagsView(tags: tags)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
    }
}

// MARK: - Tags View
struct TagsView: View {
    let tags: [String]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(tags, id: \.self) { tag in
                    if #available(iOS 26.0, *) {
                        Text(tag)
                            .font(.caption2.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .glassEffect(.regular)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(.white.opacity(0.1), lineWidth: 0.5))
                    } else {
                        Text(tag)
                            .font(.caption2.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(.white.opacity(0.08), lineWidth: 0.5)
                            )
                    }
                }
            }
        }
    }
}

// MARK: Character Information
struct CharacterInfo: View {
    let characterClass: String
    let color: String
    
    var body: some View {
        HStack(spacing: 12) {
            DetailCapsule(label: "Class", value: characterClass, icon: "person.fill")
            DetailCapsule(label: "Color", value: color, icon: "paintpalette.fill")
        }
    }
}

// MARK: - Detail Capsule
struct DetailCapsule: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(label, systemImage: icon)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
}

// MARK: Character's medal
struct CharacterMedal: View {
    let character: Character
    
    var body: some View {
        VStack {
            HStack {
                if let medalURLString = character.medal,
                   let medalURL = URL(string: medalURLString) {
                    KFImage(medalURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                
                Text("\(character.medalTrait)")
                    .font(.subheadline)
            }
            
            if !character.medalTags.isEmpty {
                TagsView(tags: character.medalTags)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Recommended Set section
struct RecommendedSet: View {
    let character: Character
    @State var showAltSets: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Recommended Set", systemImage: "circle.grid.3x3.fill")
            
            HStack(spacing: 16) {
                if let recommendedSet = character.recommendedSet {
                    ForEach(recommendedSet, id: \.self) { medalUrl in
                        MedalItem(url: medalUrl)
                    }
                } else {
                    ContentUnavailableView("No Medals Recommended", systemImage: "questionmark.circle")
                        .frame(width: 200, height: 100)
                }
            }
            
            if let message = character.setMessage, !message.isEmpty {
                Text(message)
            }
            
            if let altSets = character.altSets, !altSets.isEmpty {
                Button {
                    showAltSets = true
                } label: {
                    HStack {
                        Text("Alternative/F2P Sets")
                        Image(systemName: "chevron.right")
                    }
                }
            }
            
            Text("NOTE: These may change with future game updates.")
                .font(.caption2)
                .foregroundStyle(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showAltSets) {
            AltSetsView(altSets: character.altSets ?? [])
                .presentationDetents([.medium, .large])
                .presentationCornerRadius(25)
        }
    }
}

// MARK: - Medal image
struct MedalItem: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .cornerRadius(15)
                .shadow(radius: 5)
        } placeholder: {
            Circle().fill(.gray.opacity(0.3))
        }
    }
}

// MARK: - Recommended Stats
struct RecommendedStats: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Recommended Build", systemImage: "chart.bar.fill")
            
            if let stats = character.recommendedStats, !stats.isEmpty {
                Text(stats)
                    .bold()
            }
            
            if let statMessage = character.statMessage, !statMessage.isEmpty {
                Text(statMessage)
            }
            
            Text("NOTE: These may change with future game updates.")
                .font(.caption2)
                .foregroundStyle(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Character Guide
struct CharacterGuide: View {
    let character: Character
    @State var showGuide: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Guide", systemImage: "book")
                
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showGuide.toggle()
                    }
                } label: {
                    HStack {
                        Text(showGuide ? "Hide Guide" : "Show Guide")
                        Image(systemName: showGuide ? "chevron.up" : "chevron.down")
                    }
                }
            }
        
            if showGuide {
                if let guide = character.guide, !guide.isEmpty {
                    Text(guide)
                        .font(.caption)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    CharacterDetailView(character: Character(id: 1, artwork: "", characterClass: "", color: "", name: "", title: "", guide: "", recommendedSet: [""], setMessage: "", recommendedStats: "", statMessage: "", medal: "", medalTags: [""], medalTrait: "", characterTags: [""], altSets: [[""]]))
}


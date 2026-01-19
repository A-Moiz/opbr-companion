//
//  CharactersListView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 17/01/2026.
//

import SwiftUI

struct CharactersListView: View {
    @Environment(Database.self) var db
    @State private var showFilter: Bool = false
    @State private var selectedClass: String? = nil
    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 16)]
    private var filteredCharacters: [Character] {
        guard let selectedClass else { return db.characters }
        return db.characters.filter { $0.characterClass == selectedClass }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if filteredCharacters.isEmpty && db.characters.isEmpty {
                    ContentUnavailableView("No Characters Found",
                                           systemImage: "person.slash",
                                           description: Text("Try checking your connection or refresh the app."))
                } else {
                    CharacterGridView(showFilter: $showFilter, selectedClass: $selectedClass)
                }
            }
            .navigationTitle("Characters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Character Grid View
struct CharacterGridView: View {
    @Environment(Database.self) var db
    @Binding var showFilter: Bool
    @Binding var selectedClass: String?
    @State var selectedItem: [String]? = []
    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 16)]
    private var filteredCharacters: [Character] {
        guard let selectedClass else { return db.characters }
        return db.characters.filter { $0.characterClass == selectedClass }
    }
    let characterClasses = ["Attacker", "Defender", "Runner"]
    
    var body: some View {
        ScrollView {
            VStack {
                FilterToggleView(showFilter: $showFilter, hideText: "Hide Filter", showText: "Show Filter")
                
                if showFilter {
                    FilterView(array: characterClasses, selectedItem: $selectedClass, isMultiple: false, selectedItems: $selectedItem)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredCharacters) { character in
                        NavigationLink(destination: CharacterDetailView(character: character)) {
                            CharacterCard(character: character)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
        }
        .scrollClipDisabled()
    }
}

// MARK: - Character Card
struct CharacterCard: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: character.artwork ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView().controlSize(.small)
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundStyle(.primary)
                
                Text(character.title)
                    .font(.caption)
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding(10)
            .frame(height: 70, alignment: .topLeading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    CharactersListView()
        .environment(Database())
}

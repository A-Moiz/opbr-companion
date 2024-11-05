//
//  MedalSetsView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

import SwiftUI

struct MedalSetsView: View {
    // Search text
    @State private var searchText: String = ""
    @State private var text: String = "Search medal sets..."
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    // View model
    @ObservedObject var homeVM: HomeViewModel
    
    // Filtered medal sets based on search text
    private var filteredMedalSets: [MedalSet] {
        if searchText.isEmpty {
            return homeVM.medalSets
        } else {
            return homeVM.medalSets.filter { set in
                set.bestFor.contains { bestForItem in
                    bestForItem.localizedCaseInsensitiveContains(searchText)
                } ||
                set.medalTraits.contains { medalTrait in
                    medalTrait.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("You can search for medal sets optimized for specific character classes, such as Attacker, Defender, and Runner.")
                    .foregroundStyle(.gray)
                    .padding()
                SearchBar(searchText: $searchText, text: $text)
            }
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    if filteredMedalSets.isEmpty {
                        Text("No medal sets found.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(filteredMedalSets, id: \.imageURL) { set in
                            MedalSetCardView(medalSet: set)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .scrollIndicators(.hidden)
            
            Text("NOTE: More sets will be added in the future.")
                .font(.subheadline)
                .padding()
        }
        .padding(.top)
        .background(colourScheme == .dark ? Color.black.opacity(0.95) : Color.gray.opacity(0.05))
    }
}

struct MedalSetCardView: View {
    var medalSet: MedalSet
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                if let uiImage = UIImage(contentsOfFile: medalSet.imageURL.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 4)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 180)
                        .cornerRadius(15)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(medalSet.medalTraits.joined(separator: ", "))
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Divider()
                
                Text("Best For: \(medalSet.bestFor.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Divider()
                
                Text(medalSet.description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(10)
            .background(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
            .cornerRadius(10)
            .shadow(radius: 3)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
                .shadow(color: .black.opacity(0.15), radius: 5)
        )
    }
}

#Preview {
    MedalSetsView(homeVM: HomeViewModel())
}

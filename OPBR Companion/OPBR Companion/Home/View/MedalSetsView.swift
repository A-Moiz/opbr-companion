//
//  MedalSetsView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

//import SwiftUI
//
//struct MedalSetsView: View {
//    // Search text
//    @State private var searchText: String = ""
//    @State private var text: String = "Search medal sets..."
//    // Colour scheme
//    @Environment(\.colorScheme) private var colourScheme
//    // View model
//    @ObservedObject var homeVM: HomeViewModel
//    
//    // Filtered medal sets based on search text
//    private var filteredMedalSets: [MedalSet] {
//        if searchText.isEmpty {
//            return homeVM.medalSets
//        } else {
//            return homeVM.medalSets.filter { set in
//                set.bestFor.contains { bestForItem in
//                    bestForItem.localizedCaseInsensitiveContains(searchText)
//                } ||
//                set.medalTraits.contains { medalTrait in
//                    medalTrait.localizedCaseInsensitiveContains(searchText)
//                }
//            }
//        }
//    }
//    
//    var body: some View {
//        VStack {
//            VStack {
//                Text("You can search for medal sets optimized for specific character classes, such as Attacker, Defender, and Runner.")
//                    .foregroundStyle(.gray)
//                    .padding()
//                SearchBar(searchText: $searchText, text: $text)
//            }
//            
//            ScrollView {
//                LazyVStack(spacing: 20) {
//                    if filteredMedalSets.isEmpty {
//                        Text("No medal sets found.")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                            .padding()
//                    } else {
//                        ForEach(filteredMedalSets, id: \.imageURL) { set in
//                            MedalSetCardView(medalSet: set)
//                                .padding(.horizontal)
//                        }
//                    }
//                }
//                .padding(.top, 10)
//            }
//            .scrollIndicators(.hidden)
//            
//            Text("NOTE: More sets will be added in the future.")
//                .font(.subheadline)
//                .padding()
//        }
//        .padding(.top)
//        .background(colourScheme == .dark ? Color.black.opacity(0.95) : Color.gray.opacity(0.05))
//    }
//}

import SwiftUI

struct MedalSetsView: View {
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    // View model
    @ObservedObject var homeVM: HomeViewModel
    // Filter tags
    @State private var selectedTags: [String] = []
    @State private var showTags: Bool = false

    private var filteredMedalSets: [MedalSet] {
        var sets = homeVM.medalSets
        
        if !selectedTags.isEmpty {
            sets = sets.filter { set in
                selectedTags.allSatisfy { tag in
                    set.bestFor.contains(tag)
                }
            }
        }
        
        return sets
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showTags.toggle()
                }) {
                    HStack {
                        Text(showTags ? "Hide class" : "Show class")
                        Image(systemName: showTags ? "chevron.up" : "chevron.down")
                    }
                }
                .padding()
            }
            
            if showTags {
                HStack(spacing: 15) {
                    ForEach(["Attacker", "Runner", "Defender"], id: \.self) { tag in
                        TagButton(label: tag, isSelected: selectedTags.contains(tag)) {
                            if selectedTags.contains(tag) {
                                selectedTags.removeAll { $0 == tag }
                            } else {
                                selectedTags.append(tag)
                            }
                        }
                    }
                }
                .padding()
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

#Preview {
    MedalSetsView(homeVM: HomeViewModel())
}

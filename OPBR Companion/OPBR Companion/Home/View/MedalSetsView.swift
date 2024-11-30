//
//  MedalSetsView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

import SwiftUI

struct MedalSetsView: View {
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    // View model
    @ObservedObject var homeVM: HomeViewModel
    // Filter tags
    @State private var selectedTags: [String] = []
    @State private var showTags: Bool = false
    // Filtered medal sets
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
                        ForEach(filteredMedalSets, id: \.imageURLs) { set in
                            MedalSetCardView(medalSet: set)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .scrollIndicators(.hidden)
            
            InfoButton(infoMessage: "You can search for medal sets that are suitable for each class. If you select multiple classes, the displayed sets will be practical for all chosen classes.\n\nNOTE: More sets will be added in the future.", homeVM: homeVM)
        }
        .padding(.top)
        .background(colourScheme == .dark ? Color.black.opacity(0.95) : Color.gray.opacity(0.05))
    }
}

#Preview {
    MedalSetsView(homeVM: HomeViewModel())
}

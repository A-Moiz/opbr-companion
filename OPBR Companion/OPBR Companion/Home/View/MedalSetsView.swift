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
    @ObservedObject var db: Supabase
    @ObservedObject var helper: Helper
    // Filter tags
    @State private var selectedTag: String?
    @State private var showTags: Bool = false
    
    // Filtered medal sets
    private var filteredMedalSets: [MedalSet] {
        filterMedalSets()
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
                        TagButton(label: tag, isSelected: selectedTag == tag) {
                            selectedTag = (selectedTag == tag) ? nil : tag
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
                        ForEach(filteredMedalSets, id: \.id) { set in
                            MedalSetCardView(medalSet: set)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .scrollIndicators(.hidden)
            
            InfoButton(infoMessage: "You can search for medal sets that are suitable for each class.\n\nNOTE: More sets will be added in the future.", helper: helper)
        }
        .padding(.top)
        .background(colourScheme == .dark ? Color.black.opacity(0.95) : Color.gray.opacity(0.05))
    }

    private func filterMedalSets() -> [MedalSet] {
        var sets = db.medalSets
        if let selectedTag = selectedTag {
            sets = sets.filter { set in
                set.bestFor.contains(selectedTag)
            }
        }
        
        return sets
    }
}
//#Preview {
//    MedalSetsView(homeVM: HomeViewModel())
//}

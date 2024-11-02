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
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText, text: $text)
            
            ScrollView {
                LazyVStack(spacing: 32) {
                    if homeVM.medalSets.isEmpty {
                        Spacer()
                        Text("No medal sets in the database.")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                    } else {
                        ForEach(filteredMedalSets, id: \.imageURL) { set in
                            VStack(spacing: 10) {
                                if let uiImage = UIImage(contentsOfFile: set.imageURL.path) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 200)
                                        .cornerRadius(10)
                                }
                                
                                Text("Best For: \(set.bestFor.joined(separator: ", "))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Text("Description: \(set.description)")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        }
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            .mask {
                Rectangle()
                    .padding(.bottom, -100)
            }
        }
    }
}

#Preview {
    MedalSetsView(homeVM: HomeViewModel())
}

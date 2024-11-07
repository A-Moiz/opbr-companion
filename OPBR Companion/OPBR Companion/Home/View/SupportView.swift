//
//  SupportView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 03/11/2024.
//

import SwiftUI

struct SupportView: View {
    // Search text
    @State private var searchText: String = ""
    @State private var text: String = "Search support colour or tag..."
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    // View model
    @ObservedObject var homeVM: HomeViewModel
    // Tags
    @State private var selectedTags: [String] = []
    @State private var showTags: Bool = false
    // Filtered support
    private var filteredSupport: [SupportImage] {
        var supports = homeVM.supportImages

        if !selectedTags.isEmpty {
            supports = supports.filter { supportImage in
                selectedTags.allSatisfy { tag in
                    supportImage.tags.contains(tag)
                }
            }
        }

        if !searchText.isEmpty {
            supports = supports.filter { supportImage in
                supportImage.colour.localizedCaseInsensitiveContains(searchText) ||
                supportImage.tags.contains { supportTag in
                    supportTag.localizedCaseInsensitiveContains(searchText)
                }
            }
        }

        return supports
    }

    var body: some View {
        VStack {
            Text("Support percentages vary between users. Use these examples to guide your character choices and configurations.")
                .foregroundStyle(.gray)
                .padding()
            HStack {
                Button(action: {
                    showTags.toggle()
                }) {
                    HStack {
                        Text(showTags ? "Hide support tags" : "Show support tags")
                        Image(systemName: showTags ? "chevron.up" : "chevron.down")
                    }
                }
                .padding()
            }

            if showTags {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)]) {
                        ForEach(homeVM.supportTagsArray.map(\.0), id: \.self) { tag in
                            TagButton(label: tag, isSelected: selectedTags.contains(tag)) {
                                if selectedTags.contains(tag) {
                                    selectedTags.removeAll { $0 == tag }
                                } else {
                                    selectedTags.append(tag)
                                }
                                searchText = ""
                            }
                        }
                    }
                    .padding()
                }
            }

            ScrollView {
                LazyVStack(spacing: 20) {
                    if filteredSupport.isEmpty {
                        Text("No support images found.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(filteredSupport, id: \.imageURL) { image in
                            SupportCardView(supportImage: image)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .scrollIndicators(.hidden)

            Text("NOTE: More supports will be added in the future.")
                .font(.subheadline)
                .padding()
        }
        .background(colourScheme == .dark ? Color.black.opacity(0.95) : Color.gray.opacity(0.05))
    }
}

//#Preview {
//    SupportView()
//}

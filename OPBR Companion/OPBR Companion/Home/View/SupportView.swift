//
//  SupportView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 03/11/2024.
//

import SwiftUI

struct SupportView: View {
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    // View model
    @ObservedObject var homeVM: HomeViewModel
    // Tags
    @State private var selectedTags: [String] = []
    @State private var selectedColors: [String] = []
    @State private var showTags: Bool = false
    @State private var showColorTags: Bool = false
    
    // Color filter options
    private let colorTags = ["Red", "Green", "Blue", "Light", "Dark"]
    
    // Filtered support images based on selected tags and colors
    private var filteredSupport: [SupportImage] {
        var supports = homeVM.supportImages
        
        // Filter by support tags
        if !selectedTags.isEmpty {
            supports = supports.filter { supportImage in
                selectedTags.allSatisfy { tag in
                    supportImage.tags.contains(tag)
                }
            }
        }
        
        // Filter by color tags
        if !selectedColors.isEmpty {
            supports = supports.filter { supportImage in
                selectedColors.contains(supportImage.colour)
            }
        }
        
        return supports
    }
    
    var body: some View {
        VStack {
            // Button to show/hide support tags
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
            
            // Support Tags
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
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // Button to show/hide color tags
            HStack {
                Button(action: {
                    showColorTags.toggle()
                }) {
                    HStack {
                        Text(showColorTags ? "Hide color tags" : "Show color tags")
                        Image(systemName: showColorTags ? "chevron.up" : "chevron.down")
                    }
                }
                .padding()
            }
            
            // Color Tags
            if showColorTags {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(colorTags, id: \.self) { color in
                            TagButton(label: color, isSelected: selectedColors.contains(color)) {
                                if selectedColors.contains(color) {
                                    selectedColors.removeAll { $0 == color }
                                } else {
                                    selectedColors.append(color)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // Filtered support images
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
            
            InfoButton(infoMessage: "Support percentages vary between users. Use these examples to guide your character choices and configurations.\n\nNote: More supports will be added in the future.", homeVM: homeVM)
        }
        .background(colourScheme == .dark ? Color.black.opacity(0.95) : Color.gray.opacity(0.05))
    }
}

//#Preview {
//    SupportView()
//}

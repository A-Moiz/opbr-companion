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
    @ObservedObject var db: Supabase
    @ObservedObject var helper: Helper
    // Tags
    @State private var selectedTags: [String] = []
    @State private var selectedColor: String? = nil
    @State private var showTags: Bool = false
    @State private var showColorTags: Bool = false
    
    // Color filter options
    private let colorTags = ["Red", "Green", "Blue", "Light", "Dark"]
    
    // Filtered support images based on selected tags and colors
    private var filteredSupport: [Support] {
        var supports = db.supports
        
        // Filter by support tags
        if !selectedTags.isEmpty {
            supports = supports.filter { support in
                if let tags = support.supportTags {
                    return selectedTags.allSatisfy { tag in
                        tags.contains(tag)
                    }
                }
                return false
            }
        }
        
        // Filter by colour tags
        if let color = selectedColor {
            supports = supports.filter { support in
                if let supportColor = support.supportColor {
                    return supportColor == color
                }
                return false
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
                        ForEach(helper.supportTagsArray.map(\.0), id: \.self) { tag in
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
            
            // Button to show/hide colour tags
            HStack {
                Button(action: {
                    showColorTags.toggle()
                }) {
                    HStack {
                        Text(showColorTags ? "Hide colour tags" : "Show colour tags")
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
                            TagButton(label: color, isSelected: selectedColor == color) {
                                selectedColor = (selectedColor == color) ? nil : color
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
                        ForEach(filteredSupport, id: \.support) { support in
                            SupportCardView(support: support)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .scrollIndicators(.hidden)
            
            InfoButton(infoMessage: "Support percentages vary between users. Use these examples to guide your character choices and configurations.\n\nNote: More supports will be added in the future.", helper: helper)
        }
        .background(colourScheme == .dark ? Color.black.opacity(0.95) : Color.gray.opacity(0.05))
    }
}

//#Preview {
//    SupportView()
//}

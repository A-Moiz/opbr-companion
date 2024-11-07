//
//  SupportView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 03/11/2024.
//

//import SwiftUI
//
//struct SupportView: View {
//    // Search text
//    @State private var searchText: String = ""
//    @State private var text: String = "Search support colour or tag..."
//    // Colour scheme
//    @Environment(\.colorScheme) private var colourScheme
//    // View model
//    @ObservedObject var homeVM: HomeViewModel
//    // Filter tag
//    @State private var selectedIndex: Int? = nil
//    @State private var selectedTag: String? = nil
//    @State private var showTags: Bool = false
//    
//    // Filtered character images based on search text
//    private var filteredSupport: [SupportImage] {
//        var supports = homeVM.supportImages
//        
//        if let tag = selectedTag {
//            supports = supports.filter { supportImage in
//                supportImage.tags.contains(tag)
//            }
//        }
//        
//        if !searchText.isEmpty {
//            supports = supports.filter { supportImage in
//                supportImage.colour.localizedCaseInsensitiveContains(searchText) ||
//                supportImage.tags.contains { supportTag in
//                    supportTag.localizedCaseInsensitiveContains(searchText)
//                }
//            }
//        }
//        
//        return supports
//        
////        if searchText.isEmpty {
////            return homeVM.supportImages
////        } else {
////            return homeVM.supportImages.filter { supportImage in
////                supportImage.colour.localizedCaseInsensitiveContains(searchText) ||
////                supportImage.tags.contains { supportTag in
////                    supportTag.localizedCaseInsensitiveContains(searchText)
////                }
////            }
////        }
//    }
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Button(action: {
//                    showTags.toggle()
//                    if !showTags {
//                        selectedTag = nil
//                    }
//                }) {
//                    HStack {
//                        Text(showTags ? "Hide character tags" : "Show character tags")
//                        Image(systemName: showTags ? "chevron.up" : "chevron.down")
//                    }
//                }
//                .padding()
//            }
//            
//            if showTags {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 10) {
//                        ForEach(homeVM.supportTagsArray.indices, id: \.self) { index in
//                            let tag = homeVM.supportTagsArray[index].0
//                            TagButton(label: tag, isSelected: selectedTag == tag) {
//                                selectedTag = (selectedTag == tag) ? nil : tag
//                                searchText = ""
//                            }
//                        }
//                    }
//                    .padding()
//                }
//            }
//            // Search Bar
////            VStack {
////                Text("You can search for supports by colour or tag. For example 'Red' or 'Warlord'")
////                    .foregroundStyle(.gray)
////                    .padding()
////                Text("Support percentages vary between users. Use these examples to guide your character choices and configurations.")
////                    .foregroundStyle(.gray)
////                    .padding()
////                SearchBar(searchText: $searchText, text: $text)
////            }
//            
//            Text("Support percentages vary between users. Use these examples to guide your character choices and configurations.")
//                .foregroundStyle(.gray)
//                .padding()
//            
//            ScrollView {
//                LazyVStack(spacing: 20) {
//                    if filteredSupport.isEmpty {
//                        Text("No support images found.")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                            .padding()
//                    } else {
//                        ForEach(filteredSupport, id: \.imageURL) { image in
//                            SupportCardView(supportImage: image)
//                                .padding(.horizontal)
//                        }
//                    }
//                }
//                .padding(.top, 10)
//            }
//            .scrollIndicators(.hidden)
//            
//            Text("NOTE: More supports will be added in the future.")
//                .font(.subheadline)
//                .padding()
//        }
//        .background(colourScheme == .dark ? Color.black.opacity(0.95) : Color.gray.opacity(0.05))
//    }
//}
//
//struct SupportCardView: View {
//    var supportImage: SupportImage
//    // Colour scheme
//    @Environment(\.colorScheme) private var colourScheme
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            if let uiImage = UIImage(contentsOfFile: supportImage.imageURL.path) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(height: 250)
//                    .cornerRadius(15)
//                    .shadow(radius: 4)
//            } else {
//                Rectangle()
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(height: 180)
//                    .cornerRadius(15)
//            }
//            
//            VStack(alignment: .leading, spacing: 6) {
//                HStack {
//                    Image(systemName: "tag.fill")
//                        .foregroundStyle(Color.orange)
//                    Text("Tags: \(supportImage.tags.joined(separator: ", "))")
//                        .font(.subheadline)
//                        .foregroundColor(.primary)
//                }
//                
//                HStack {
//                    Image(systemName: "circle.fill")
//                        .foregroundStyle(color(for: supportImage.colour))
//                    Text("Color: \(supportImage.colour)")
//                        .font(.subheadline)
//                        .foregroundColor(.primary)
//                }
//            }
//            .padding(10)
//            .background(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
//            .cornerRadius(10)
//            .shadow(radius: 3)
//        }
//        .padding(10)
//        .background(
//            RoundedRectangle(cornerRadius: 15)
//                .fill(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
//                .shadow(radius: 5)
//        )
//    }
//    
//    func color(for colourName: String) -> Color {
//        switch colourName {
//        case "Red":
//            return Color.red
//        case "Green":
//            return Color.green
//        case "Blue":
//            return Color.blue
//        case "Light":
//            return Color.white
//        case "Dark":
//            return Color.black
//        default:
//            return Color.gray
//        }
//    }
//}

import SwiftUI

struct SupportView: View {
    @State private var searchText: String = ""
    @State private var text: String = "Search support colour or tag..."
    @Environment(\.colorScheme) private var colourScheme
    @ObservedObject var homeVM: HomeViewModel
    @State private var selectedTags: [String] = []
    @State private var showTags: Bool = false

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

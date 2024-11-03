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
//    
//    // Filtered character images based on search text
//    private var filteredSupport: [SupportImage] {
//        if searchText.isEmpty {
//            return homeVM.supportImages
//        } else {
//            return homeVM.supportImages.filter { supportImage in
//                supportImage.colour.localizedCaseInsensitiveContains(searchText) ||
//                supportImage.tags.contains { supportTag in
//                    supportTag.localizedCaseInsensitiveContains(searchText)
//                }
//            }
//        }
//    }
//    
//    var body: some View {
//        VStack {
//            // Search Bar
//            SearchBar(searchText: $searchText, text: $text)
//            
//            ScrollView {
//                LazyVStack(spacing: 32) {
//                    if homeVM.supportImages.isEmpty {
//                        Spacer()
//                        Text("No images available.")
//                            .font(.title2)
//                            .fontWeight(.semibold)
//                            .padding()
//                    } else {
//                        ForEach(filteredSupport, id: \.imageURL) { image in
//                            VStack(spacing: 10) {
//                                if let uiImage = UIImage(contentsOfFile: image.imageURL.path) {
//                                    Image(uiImage: uiImage)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(height: 200)
//                                        .cornerRadius(10)
//                                        .shadow(radius: 5)
//                                } else {
//                                    Rectangle()
//                                        .fill(Color.gray.opacity(0.3))
//                                        .frame(height: 200)
//                                        .cornerRadius(10)
//                                }
//                                
//                                Text("Tags: \(image.tags.joined(separator: ", "))")
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                                
//                                Text("Color: \(image.colour)")
//                                    .font(.subheadline)
//                                    .foregroundColor(.blue)
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(12)
//                            .shadow(radius: 5)
//                        }
//                    }
//                }
//                .padding()
//            }
//            .scrollIndicators(.hidden)
//            .scrollClipDisabled()
//            .mask {
//                Rectangle()
//                    .padding(.bottom, -100)
//            }
//        }
//    }
//}

import SwiftUI

struct SupportView: View {
    // Search text
    @State private var searchText: String = ""
    @State private var text: String = "Search support colour or tag..."
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    // View model
    @ObservedObject var homeVM: HomeViewModel
    
    // Filtered character images based on search text
    private var filteredSupport: [SupportImage] {
        if searchText.isEmpty {
            return homeVM.supportImages
        } else {
            return homeVM.supportImages.filter { supportImage in
                supportImage.colour.localizedCaseInsensitiveContains(searchText) ||
                supportImage.tags.contains { supportTag in
                    supportTag.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            // Search Bar
            SearchBar(searchText: $searchText, text: $text)
            
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
        }
        .background(colourScheme == .dark ? Color.black.opacity(0.95) : Color.gray.opacity(0.05))
    }
}

struct SupportCardView: View {
    var supportImage: SupportImage
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let uiImage = UIImage(contentsOfFile: supportImage.imageURL.path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .cornerRadius(15)
                    .shadow(radius: 4)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 180)
                    .cornerRadius(15)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundStyle(Color.orange)
                    Text("Tags: \(supportImage.tags.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(color(for: supportImage.colour))
                    Text("Color: \(supportImage.colour)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            .padding(10)
            .background(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
            .cornerRadius(10)
            .shadow(radius: 3)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
                .shadow(radius: 5)
        )
    }
    
    func color(for colourName: String) -> Color {
        switch colourName {
        case "Red":
            return Color.red
        case "Green":
            return Color.green
        case "Blue":
            return Color.blue
        case "White":
            return Color.white
        case "Black":
            return Color.black
        default:
            return Color.gray
        }
    }
}

//#Preview {
//    SupportView()
//}

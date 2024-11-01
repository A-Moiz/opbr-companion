//
//  HomeView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 31/10/2024.
//

import SwiftUI
import UIKit

struct HomeView: View {
    // Search text
    @State private var searchText: String = ""
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    // View model
    @ObservedObject var homeVM = HomeViewModel()
    // Container
    let containerIdentifier = "iCloud.OPBR-Companion"
    
    var body: some View {
        NavigationStack {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search characters...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                Image(systemName: "x.circle")
            }
            .foregroundColor(colourScheme == .dark ? .white : .black)
            .padding()
            .background(colourScheme == .dark ? .gray.opacity(0.3) : .gray.opacity(0.5))
            .cornerRadius(12)
            .padding(.horizontal)
            .navigationTitle("Home")
            .onAppear {
                homeVM.fetchSupportImages(from: containerIdentifier)
            }
            
            SupportImagesView()
        }
    }
    
    // Displaying support images
    @ViewBuilder
    func SupportImagesView() -> some View {
        ScrollView {
            LazyVStack(spacing: 32) {
                if homeVM.supportImages.isEmpty {
                    Spacer()
                    Text("No images available.")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                } else {
                    ForEach(homeVM.supportImages, id: \.imageURL) { image in
                        VStack(spacing: 10) {
                            // Display image
                            if let uiImage = UIImage(contentsOfFile: image.imageURL.path) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(10) // Optional: Add corner radius for aesthetics
                                    .shadow(radius: 5) // Optional: Add shadow for depth
                            } else {
                                // Placeholder if image loading fails
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 200)
                                    .cornerRadius(10)
                            }
                            
                            // Display tags
                            Text("Tags: \(image.tags.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            // Display color
                            Text("Color: \(image.colour)")
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

#Preview {
    HomeView()
}

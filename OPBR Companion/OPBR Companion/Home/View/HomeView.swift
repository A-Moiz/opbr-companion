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
    @ObservedObject var contentVM: ContentViewModel
    // Container
    let containerIdentifier = "iCloud.OPBR-Companion"
    // Tab
    @State private var selectedTab: Tab?
    @State private var tabProgress: CGFloat = 0
    // View
    @State private var showOwnedCharacters: Bool = false
    @State private var showDesiredCharacters: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TabBar()
                    .padding(.top)
                
                GeometryReader {
                    let size = $0.size
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                            AllCharactersView(homeVM: homeVM)
                                .id(Tab.characters)
                                .containerRelativeFrame(.horizontal)
                            
                            SupportImagesView()
                                .id(Tab.support)
                                .containerRelativeFrame(.horizontal)
                            
                            MedalSetsView(homeVM: homeVM)
                                .id(Tab.medalSets)
                                .containerRelativeFrame(.horizontal)
                        }
                        .scrollTargetLayout()
                        .offsetX { value in
                            let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                            tabProgress = max(min(progress, 1), 0)
                        }
                    }
                    .scrollPosition(id: $selectedTab)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                }
            }
            .foregroundColor(colourScheme == .dark ? .white : .black)
            .padding()
            .background(colourScheme == .dark ? .gray.opacity(0.3) : .gray.opacity(0.5))
            .cornerRadius(12)
            .padding(.horizontal)
            .navigationTitle("Home")
            .onAppear {
                homeVM.fetchSupportImages(from: containerIdentifier)
                homeVM.fetchAllCharacters(from: containerIdentifier)
                homeVM.fetchMedalSets(from: containerIdentifier)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        // Owned characters
                        Button(action: { showOwnedCharacters = true }) {
                            Label("Owned characters", systemImage: "person")
                        }
                        
                        // Desired characters
                        Button(action: { showDesiredCharacters = true }) {
                            Label("Desired characters", systemImage: "person")
                        }
                        
                        // Refresh Feed
                        Button(action: { Task {
                            homeVM.fetchAllCharacters(from: containerIdentifier)
                            homeVM.fetchSupportImages(from: containerIdentifier)
                            homeVM.fetchMedalSets(from: containerIdentifier)
                        } }) {
                            Label("Refresh", systemImage: "arrow.clockwise")
                        }
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .sheet(isPresented: $showOwnedCharacters) {
                OwnedCharactersView(homeVM: homeVM)
            }
            .sheet(isPresented: $showDesiredCharacters) {
                DesiredCharactersView(homeVM: homeVM)
            }
        }
    }
    
    // Displaying support images
    @ViewBuilder
    func SupportImagesView() -> some View {
        ScrollView {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search characters...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                Image(systemName: "x.circle")
            }
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
                            if let uiImage = UIImage(contentsOfFile: image.imageURL.path) {
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
                            
                            Text("Tags: \(image.tags.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
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
    
    // Displaying medal sets
//    @ViewBuilder
//    func MedalSetsView() -> some View {
//        ScrollView {
//            // Search Bar
//            HStack {
//                Image(systemName: "magnifyingglass")
//                TextField("Search characters...", text: $searchText)
//                    .textFieldStyle(PlainTextFieldStyle())
//                Image(systemName: "x.circle")
//            }
//            LazyVStack(spacing: 32) {
//                if homeVM.medalSets.isEmpty {
//                    Spacer()
//                    Text("No medal sets in the database.")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .padding()
//                } else {
//                    ForEach(homeVM.medalSets, id: \.imageURL) { image in
//                        VStack(spacing: 10) {
//                            if let uiImage = UIImage(contentsOfFile: image.imageURL.path) {
//                                Image(uiImage: uiImage)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(height: 200)
//                                    .cornerRadius(10)
//                                    .shadow(radius: 5)
//                            } else {
//                                Rectangle()
//                                    .fill(Color.gray.opacity(0.3))
//                                    .frame(height: 200)
//                                    .cornerRadius(10)
//                            }
//                            
//                            Text("Best For: \(image.tags.joined(separator: ", "))")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                            
//                            Text("Description: \(image.description)")
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(12)
//                        .shadow(radius: 5)
//                    }
//                }
//            }
//            .padding()
//        }
//        .scrollIndicators(.hidden)
//        .scrollClipDisabled()
//        .mask {
//            Rectangle()
//                .padding(.bottom, -100)
//        }
//    }
    
    // Tab
    @ViewBuilder
    func TabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10) {
                    Image(systemName: tab.systemImage)
                    
                    Text(tab.rawValue)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selectedTab = tab
                    }
                }
            }
        }
        .tabMask(tabProgress)
        .background {
            GeometryReader {
                let size = $0.size
                let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                
                Capsule()
                    .fill(colourScheme == .dark ? .black : .white)
                    .frame(width: capsuleWidth)
                    .offset(x: tabProgress * (size.width - capsuleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
}

#Preview {
    HomeView(contentVM: ContentViewModel())
}

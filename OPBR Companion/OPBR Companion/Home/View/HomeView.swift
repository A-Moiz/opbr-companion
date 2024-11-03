//
//  HomeView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 31/10/2024.
//

//import SwiftUI
//import UIKit
//
//struct HomeView: View {
//    // Search text
//    @State private var searchText: String = ""
//    // Colour scheme
//    @Environment(\.colorScheme) private var colourScheme
//    // View model
//    @ObservedObject var homeVM = HomeViewModel()
//    @ObservedObject var contentVM: ContentViewModel
//    // Container
//    let containerIdentifier = "iCloud.OPBR-Companion"
//    // Tab
//    @State private var selectedTab: Tab?
//    @State private var tabProgress: CGFloat = 0
//    // View
//    @State private var showOwnedCharacters: Bool = false
//    @State private var showDesiredCharacters: Bool = false
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                TabBar()
//                    .padding(.top)
//
//                GeometryReader {
//                    let size = $0.size
//                    ScrollView(.horizontal) {
//                        LazyHStack(spacing: 0) {
//                            AllCharactersView(homeVM: homeVM)
//                                .id(Tab.characters)
//                                .containerRelativeFrame(.horizontal)
//
//                            SupportView(homeVM: homeVM)
//                                .id(Tab.support)
//                                .containerRelativeFrame(.horizontal)
//
//                            MedalSetsView(homeVM: homeVM)
//                                .id(Tab.medalSets)
//                                .containerRelativeFrame(.horizontal)
//                        }
//                        .scrollTargetLayout()
//                        .offsetX { value in
//                            let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
//                            tabProgress = max(min(progress, 1), 0)
//                        }
//                    }
//                    .scrollPosition(id: $selectedTab)
//                    .scrollIndicators(.hidden)
//                    .scrollTargetBehavior(.paging)
//                }
//            }
//            .foregroundColor(colourScheme == .dark ? .white : .black)
//            .padding()
//            .background(colourScheme == .dark ? .gray.opacity(0.3) : .gray.opacity(0.5))
//            .cornerRadius(12)
//            .padding(.horizontal)
//            .navigationTitle("Home")
//            .onAppear {
//                homeVM.fetchSupportImages(from: containerIdentifier)
//                homeVM.fetchAllCharacters(from: containerIdentifier)
//                homeVM.fetchMedalSets(from: containerIdentifier)
//            }
//            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                    Menu {
//                        // Owned characters
//                        Button(action: { showOwnedCharacters = true }) {
//                            Label("Owned characters", systemImage: "person")
//                        }
//
//                        // Desired characters
//                        Button(action: { showDesiredCharacters = true }) {
//                            Label("Desired characters", systemImage: "person")
//                        }
//
//                        // Refresh Feed
//                        Button(action: { Task {
//                            homeVM.fetchAllCharacters(from: containerIdentifier)
//                            homeVM.fetchSupportImages(from: containerIdentifier)
//                            homeVM.fetchMedalSets(from: containerIdentifier)
//                        } }) {
//                            Label("Refresh", systemImage: "arrow.clockwise")
//                        }
//                    } label: {
//                        Image(systemName: "plus")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                    }
//                }
//            }
//            .sheet(isPresented: $showOwnedCharacters) {
//                OwnedCharactersView(homeVM: homeVM)
//            }
//            .sheet(isPresented: $showDesiredCharacters) {
//                DesiredCharactersView(homeVM: homeVM)
//            }
//        }
//    }
//
//    // Tab
//    @ViewBuilder
//    func TabBar() -> some View {
//        HStack(spacing: 0) {
//            ForEach(Tab.allCases, id: \.rawValue) { tab in
//                HStack(spacing: 10) {
//                    Image(systemName: tab.systemImage)
//
//                    Text(tab.rawValue)
//                        .font(.callout)
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 10)
//                .contentShape(.capsule)
//                .onTapGesture {
//                    withAnimation(.snappy) {
//                        selectedTab = tab
//                    }
//                }
//            }
//        }
//        .tabMask(tabProgress)
//        .background {
//            GeometryReader {
//                let size = $0.size
//                let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
//
//                Capsule()
//                    .fill(colourScheme == .dark ? .black : .white)
//                    .frame(width: capsuleWidth)
//                    .offset(x: tabProgress * (size.width - capsuleWidth))
//            }
//        }
//        .background(.gray.opacity(0.1), in: .capsule)
//        .padding(.horizontal, 15)
//    }
//}

import SwiftUI

struct HomeView: View {
    // Device theme
    @Environment(\.colorScheme) private var colourScheme
    // View model
    @ObservedObject var homeVM = HomeViewModel()
    // Tab
    @State private var selectedTab: Tab = .characters
    // CloudKit container
    let containerIdentifier = "iCloud.OPBR-Companion"
    // Progress view
    @State private var isLoading: Bool = false
    
    // Dynamic title
    private var navigationTitle: String {
        switch selectedTab {
        case .characters:
            return "All Characters"
        case .support:
            return "Support"
        case .medalSets:
            return "Medal Sets"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                MainContentView(selectedTab: $selectedTab, homeVM: homeVM)
                
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            .padding(.horizontal)
            .navigationTitle(navigationTitle)
            .background(colourScheme == .dark ? Color.black.opacity(0.9) : Color.gray.opacity(0.1))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Refresh Feed
                    Button(action: { Task {
                        homeVM.fetchAllCharacters(from: containerIdentifier)
                        homeVM.fetchSupportImages(from: containerIdentifier)
                        homeVM.fetchMedalSets(from: containerIdentifier)
                    } }) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
            .onAppear {
                isLoading = true
                homeVM.fetchSupportImages(from: containerIdentifier)
                homeVM.fetchAllCharacters(from: containerIdentifier)
                homeVM.fetchMedalSets(from: containerIdentifier)
                isLoading = false
            }
        }
    }
}

struct MainContentView: View {
    @Binding var selectedTab: Tab
    var homeVM: HomeViewModel
    
    var body: some View {
        Group {
            switch selectedTab {
            case .characters:
                AllCharactersView(homeVM: homeVM)
            case .support:
                SupportView(homeVM: homeVM)
            case .medalSets:
                MedalSetsView(homeVM: homeVM)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.75)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 30) {
            ForEach(Tab.allCases, id: \.self) { tab in
                VStack {
                    Image(systemName: tab.systemImage)
                        .foregroundColor(selectedTab == tab ? .blue : .gray)
                    Text(tab.rawValue)
                        .font(.caption)
                }
                .onTapGesture {
                    withAnimation {
                        selectedTab = tab
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

//#Preview {
//    HomeView(contentVM: ContentViewModel())
//}

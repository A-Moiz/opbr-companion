//
//  HomeView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 31/10/2024.
//

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
    // View
    @State private var showMedalTagsView: Bool = false
    @State private var showSupportTagsView: Bool = false
    
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
            .navigationBarTitleDisplayMode(.inline)
            .background(colourScheme == .dark ? Color.black.opacity(0.9) : Color.gray.opacity(0.1))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            Task {
                                homeVM.fetchAllCharacters(from: containerIdentifier)
                            }
                        }) {
                            Label("Refresh Characters", systemImage: "person.3.fill")
                        }

                        Button(action: {
                            showMedalTagsView = true
                        }) {
                            Label("View Medal Tags", systemImage: "tablecells")
                        }
                        
                        Button(action: {
                            showSupportTagsView = true
                        }) {
                            Label("View Support Tags", systemImage: "tablecells")
                        }
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle")
                    }
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
            .sheet(isPresented: $showMedalTagsView) {
                MedalTagsView(homeVM: homeVM)
            }
            .sheet(isPresented: $showSupportTagsView) {
                SupportTagsView(homeVM: homeVM)
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

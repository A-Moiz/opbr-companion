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
    // View
    @State private var showMedalTagsView: Bool = false
    @State private var showSupportTagsView: Bool = false
    @State private var showStatusView: Bool = false
    @State private var showCharacterTitleView: Bool = false
    // Videos
    @State private var supportVidUrl: String = "https://youtu.be/V4LvGE_h7dc?feature=shared"
    @State private var medalVidUrl: String = "https://youtu.be/1pVs3GxZAfg?feature=shared"
    
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
                optionsMenu
            }
            .overlay {
                LoadingOverlay(isLoading: homeVM.isLoading)
            }
            .sheet(isPresented: $showStatusView) {
                StatusEffectsView(homeVM: homeVM)
            }
            .sheet(isPresented: $showMedalTagsView) {
                MedalTagsView(homeVM: homeVM)
            }
            .sheet(isPresented: $showSupportTagsView) {
                SupportTagsView(homeVM: homeVM)
            }
            .sheet(isPresented: $showCharacterTitleView) {
                TitleTrackerView(homeVM: homeVM)
            }
            .onAppear(perform: loadData)
            .alert(isPresented: $homeVM.showAlert) {
                Alert(title: Text(""), message: Text(homeVM.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private var optionsMenu: some View {
        Menu {
            Button(action: refreshData) {
                Label("Refresh Feed", systemImage: "person.3.fill")
            }
            
            Button(action: { showStatusView = true }) {
                Label("View All Status Effects", systemImage: "tablecells")
            }
            
            Button(action: { showMedalTagsView = true }) {
                Label("View Medal Tags", systemImage: "tablecells")
            }
            
            Button(action: { showSupportTagsView = true }) {
                Label("View Support Tags", systemImage: "tablecells")
            }
            
            Button(action: { showCharacterTitleView = true }) {
                Label("Track your Character titles", systemImage: "person")
            }
            
            Button(action: {
                if let url = URL(string: supportVidUrl) {
                    homeVM.videoGuide(videoUrl: url)
                }
            }) {
                Label("Watch support guide video", systemImage: "video")
            }
            
            Button(action: {
                if let url = URL(string: medalVidUrl) {
                    homeVM.videoGuide(videoUrl: url)
                }
            }) {
                Label("Watch medal guide video", systemImage: "video")
            }
        } label: {
            Label("Options", systemImage: "ellipsis.circle")
        }
    }
    
    private func loadData() {
        homeVM.isLoading = true
        
        homeVM.fetchAllCharacters(from: containerIdentifier) { success in
            DispatchQueue.main.async {
                guard success else {
                    homeVM.isLoading = false
                    return
                }
            }
            
            homeVM.fetchSupportImages(from: containerIdentifier) { success in
                DispatchQueue.main.async {
                    guard success else {
                        homeVM.isLoading = false
                        return
                    }

                    homeVM.fetchMedalSets(from: containerIdentifier) { success in
                        homeVM.isLoading = false
                    }
                }
            }
        }
    }
    
    private func refreshData() {
        homeVM.isLoading = true
        homeVM.fetchAllCharacters(from: containerIdentifier) { success in
            guard success else {
                homeVM.isLoading = false
                return
            }
        }
        
        homeVM.fetchSupportImages(from: containerIdentifier) { success in
            guard success else {
                homeVM.isLoading = false
                return
            }
            
            homeVM.fetchMedalSets(from: containerIdentifier) { success in
                homeVM.isLoading = false
            }
        }
    }
}

struct LoadingOverlay: View {
    var isLoading: Bool
    @Environment(\.colorScheme) private var colourScheme
    
    var body: some View {
        if isLoading {
            ZStack {
                Color.black
                    .opacity(colourScheme == .dark ? 0.6 : 0.3)
                    .ignoresSafeArea()

                ProgressView("Loading...")
                    .padding()
                    .background(colourScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(10)
                    .foregroundColor(colourScheme == .dark ? .white : .black)
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

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
    @ObservedObject var db: Supabase
    @ObservedObject var helper: Helper
    // Tab
    @State private var selectedTab: Tab = .characters
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
                MainContentView(selectedTab: $selectedTab, helper: helper, db: db)
                
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            .padding(.horizontal)
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .background(colourScheme == .dark ? Color.black.opacity(0.9) : Color.gray.opacity(0.1))
            .alert(isPresented: $helper.showAlert) {
                Alert(title: Text(""), message: Text(helper.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

//#Preview {
//    HomeView(contentVM: ContentViewModel())
//}

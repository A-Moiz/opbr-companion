//
//  MainTabView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 17/01/2026.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @Environment(Database.self) var db
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // MARK: - Characters Page
            Tab("Characters", systemImage: "person.3.fill", value: 0) {
                CharactersListView()
            }
            
            // MARK: - Support Page
            Tab("Support", systemImage: "shield.fill", value: 1) {
                SupportListView()
            }
            
            // MARK: - Medal Sets Page
            Tab("Medals", systemImage: "circle.grid.3x3.fill", value: 2) {
                MedalSetsList()
            }
        }
        .modifier(TabBarMinimizeIfAvailable())
        .tint(.orange)
        .alert(db.alertTitle, isPresented: Bindable(db).showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(db.alertMessage)
        }
    }
}

private struct TabBarMinimizeIfAvailable: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.tabBarMinimizeBehavior(.onScrollDown)
        } else {
            content
        }
    }
}

#Preview {
    MainTabView()
}

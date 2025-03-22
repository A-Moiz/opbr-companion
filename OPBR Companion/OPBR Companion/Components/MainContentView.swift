//
//  MainContentView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 22/03/2025.
//

import SwiftUI

struct MainContentView: View {
    @Binding var selectedTab: Tab
    var helper: Helper
    var db: Supabase
    
    var body: some View {
        Group {
            switch selectedTab {
            case .characters:
                AllCharactersView(db: db, helper: helper)
            case .support:
                SupportView(db: db, helper: helper)
            case .medalSets:
                MedalSetsView(db: db, helper: helper)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.75)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

//#Preview {
//    MainContentView()
//}

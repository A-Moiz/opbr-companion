//
//  OPBR_CompanionApp.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 17/01/2026.
//

import SwiftUI

@main
struct OPBR_CompanionApp: App {
    @State private var db = Database.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(db)
                .task {
                    await db.loadInitialData()
                }
        }
    }
}

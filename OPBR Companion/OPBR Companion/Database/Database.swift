//
//  Database.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 17/01/2026.
//

import Foundation
import Supabase

@Observable
@MainActor
class Database {
    static let shared = Database()
    private let supabaseClient: SupabaseClient
    
    // Data Collections
    var characters: [Character] = []
    var supports: [Support] = []
    var medalSets: [MedalSet] = []
    var appSettings: AppSettings?
    
    // UI State Management
    var isLoading: Bool = false
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    init() {
        supabaseClient = SupabaseClient(supabaseURL: URL(string: Config.SUPABASE_URL)!, supabaseKey: Config.SUPABASE_KEY)
    }
    
    // MARK: - Fetch app settings
    @discardableResult
    private func fetchAppSettings() async -> Bool {
        do {
            let settingsArray: [AppSettings] = try await supabaseClient
                .from("app_settings")
                .select()
                .limit(1)
                .execute()
                .value
            
            self.appSettings = settingsArray.first
            return true
        } catch {
            handleError(title: "Error fetching App Settings", error: error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Fetch Characters
    @discardableResult
    private func fetchCharacters() async -> Bool {
        do {
            self.characters = try await supabaseClient
                .from("character")
                .select()
                .execute()
                .value
            return true
        } catch {
            handleError(title: "Character Sync Failed", error: error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Fetch Support Images
    @discardableResult
    private func fetchSupportImages() async -> Bool {
        do {
            self.supports = try await supabaseClient
                .from("support")
                .select()
                .execute()
                .value
            return true
        } catch {
            handleError(title: "Support Sync Failed", error: error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Fetch Medal Sets
    @discardableResult
    private func fetchMedalSets() async -> Bool {
        do {
            self.medalSets = try await supabaseClient
                .from("medal_set")
                .select()
                .execute()
                .value
            return true
        } catch {
            handleError(title: "Medals Sync Failed", error: error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Main entry point to load all data for the OPBR Companion App
    func loadInitialData() async {
        isLoading = true
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchAppSettings() }
            group.addTask { await self.fetchCharacters() }
            group.addTask { await self.fetchSupportImages() }
            group.addTask { await self.fetchMedalSets() }
        }
        
        isLoading = false
    }
    
    // MARK: - Helper function for displaying alerts
    func handleError(title: String, error: String) {
        alertTitle = title
        alertMessage = error
        showAlert = true
    }
}

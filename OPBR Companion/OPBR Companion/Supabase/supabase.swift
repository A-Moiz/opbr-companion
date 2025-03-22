//
//  supabase.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 21/03/2025.
//

import Foundation
import Supabase

class Supabase: ObservableObject {
    static let shared = Supabase()
    private let supabaseClient: SupabaseClient
    
    @Published var characters: [Character] = []
    @Published var supports: [Support] = []
    @Published var medalSets: [MedalSet] = []
    
    private init() {
        supabaseClient = SupabaseClient(supabaseURL: URL(string: Config.SUPABASE_URL)!, supabaseKey: Config.SUPABASE_KEY)
    }
    
    func fetchCharacters() async {
        do {
            let response: [Character] = try await supabaseClient
                .from("character")
                .select()
                .execute()
                .value
    
            DispatchQueue.main.async {
                self.characters = response
            }
        } catch {
            print("Error fetching characters: \(error)")
        }
    }
    
    func fetchSupports() async {
        do {
            let response: [Support] = try await supabaseClient
                .from("support")
                .select()
                .execute()
                .value

            DispatchQueue.main.async {
                self.supports = response
            }
        } catch {
            print("Error fetching supports: \(error)")
        }
    }
    
    func fetchMedalSets() async {
        do {
            let response: [MedalSet] = try await supabaseClient
                .from("medal_set")
                .select()
                .execute()
                .value
            
            print("Raw response: \(response)")

            DispatchQueue.main.async {
                self.medalSets = response
                print("Medals: \(self.supports)")
            }
        } catch {
            print("Error fetching medals: \(error)")
        }
    }
}

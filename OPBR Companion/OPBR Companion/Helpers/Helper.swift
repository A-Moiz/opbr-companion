//
//  Helper.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 21/03/2025.
//

import Foundation

class Helper: ObservableObject {
    // Arrays
    @Published var supportTagsArray: [(String, [String])] = [
        ("Attacker", ["Increase ATK by 200", "Increase Crit Damage dealt by 5%"]),
        
        ("Defender", ["Increase DEF by 200", "Increase Treasure Gauge recovery amount by 10%"]),
        
        ("Runner", ["Increase HP by 800", "Increase the base Treasure Gauge amount when you capture Treasure by 30%"]),
        
        ("East Blue", ["Increase damage to enemies with the element by 15%"]),
        
        ("Navy", ["When in the area around your captured treasure: Reduce knockback distance by 60%"]),
        
        ("The Seven Warlords of the Sea", ["When your HP is 50% or more: Increase status effect infliction time by 30%"]),
        
        ("Straw Hat Pirates", ["Reduce critical damage received by 30%"]),
        
        ("Whitebeard Pirates", ["When your HP is 50% or less: Increase status effect infliction time by 30%"]),
        
        ("Don Quixote Family", ["When your HP is 50% or less: Increase normal attack damage dealt by 15%"]),
        
        ("Paramecia", ["When your HP is 50% or less: Increase critical damage dealt by 20%"]),
        
        ("Zoan", ["Reduce damage received from enemies with the element you are weak against by 15%"]),
        
        ("Logia", ["When your HP is 50% or more: 100% chance of preventing stagger from character type 'long-range normal attack' characters normal attacks", "When your HP is 70% or more: Reduce damage received from character type 'long-range normal attack' characters normal attack by 50%"]),
        
        ("Captain", ["When your HP is 50% or less: 100% chance of preventing stagger from character type 'long-range normal attack' characters normal attacks", "When your HP is 30% or less: Reduce damage received from character type 'long-range normal attack' characters normal attack by 20%"]),
        
        ("The Grand Line", ["Reduce damage received from enemies with the same element by 15%"]),
        
        ("New World", ["Increase damage to enemies with the element you are weak against by 15%"]),
        
        ("Worst Generation", ["When in a treasure area: Increase knockback distance by 30%"]),
        
        ("Charlotte Family", ["When your HP is 70% or more: Reduce normal attack damage received by 15%"]),
        
        ("Kozuki Clan / Kozuki Clan Servant", ["When your HP is 50% or less: Reduce normal attack damage received by 15%"]),
        
        ("Animal Kingdom Pirates", ["When your HP is 70% or more: Increase normal attack damage dealt by 15%"]),
        
        ("Revolutionary Army", ["When your HP is 70% or more: Reduce knockback distance by 60%"]),
        
        ("Roger Pirates / Ex-Roger Pirates", ["When your HP is 50% or less: Reduce status effect infliction time by 30%"]),
        
        ("Fish-Man", ["When in the area around your enemies treasure area: Reduce knockback distance by 20% (MAX LVL 2)"])
    ]
    
    // Alert
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    // Progress view
    @Published var isLoading: Bool = false
    
    // Showing alerts
    func showAlert(message: String) {
        DispatchQueue.main.async {
            self.alertMessage = message
            self.showAlert = true
        }
    }
}

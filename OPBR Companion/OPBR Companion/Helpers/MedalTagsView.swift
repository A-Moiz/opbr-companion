//
//  MedalTagsView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 05/11/2024.
//

import SwiftUI

struct MedalTagsView: View {
    @State private var selectedIndex: Int? = nil
    
    let rows: [(String, [String])] = [
        ("Skill 1 Cooldown", ["East Blue", "The Grand Line", "Alabasta", "Sky Island", "Water 7 / Enies Lobby", "Thriller Bark", "Sabaody Archipelago / Island of Women", "Impel Down", "The Paramount War at Marineford", "2 Years Later", "Fish-Man Island", "Punk Hazard", "Dressrosa", "Reverie", "Zou / Whole Cake Island", "Land of Wano", "FILM STRONG WORLD", "FILM GOLD", "FILM Z", "STAMPEDE", "FILM RED", "ODYSSEY", "Bikini", "Holy Night", "Egghead"]),
        
        ("Skill 2 Cooldown", ["Navy", "The Seven Warlords of the Sea", "Straw Hat Pirates", "The Alvida Pirates", "Buggy Pirates", "Black Cat Pirates", "Krieg's Pirate Armada", "Arlong Pirates", "Baroque Works", "God's Army", "Whitebeard Pirates", "Red-Haired Pirates", "Kid Pirates", "Firetank Pirates", "Cipher Pol", "Revolutionary Army", "Animal Kingdom Pirates", "Big Mom Pirates", "Bonney Pirates", "Buggy's Delivery", "Mokomo Dukedom Musketeer", "Beautiful Pirates", "Barto Club", "Flying Pirates", "Fake Straw Hat Pirates", "Giant Pirate Crew"]),
        
        ("Dodge Cooldown", ["Paramecia", "Zoan", "Logia"]),
        
        ("Increase capture speed", ["Captain", "Combatant", "Sharp Shooter", "Cook", "Navigator", "Doctor", "Archaeologist", "Ship Carpenter", "Musician", "Helmsman", "Bounty Hunter", "Admiral", "Royalty", "Master Chief Petty Officer", "Navy Captain", "Chief of Staff", "Kozuki Clan / Kozuki Clan Servant", "Lead Performer", "Intelligence Agent", "Vice Admiral", "Kingsbird", "Officer Agent", "Fleet Admiral", "Pica Army", "Diamante Army", "Tobi Roppo", "Trebol Army", "Captain of the Revolutionary Army", "Headliner"]),
        
        ("Spawn Speed Boost", ["Fish-Man"]),
        
        ("Damage Reduction (Less Treasure)", ["Mantra", "Zombie", "Fish-Man Karate", "Six Powers", "Chambres"]),
        
        ("Damage Increase (Less Treasure)", ["Seraphim", "Worst Generation", "The Four Emperors", "Sweet 3 General", "New Kama", "Homies", "Ninja", "Germa 66", "Whitebeard Pirates Commander", "Sword"]),
        
        ("Damage Increase (Allies Nearby)", ["Blood Brothers", "Charlotte Family", "Gorgon Sisters", "Minks", "Giant"]),
        
        ("Damage Reduction (Solo at Treasure)", ["Heart Pirates", "Kuja Pirates", "Sun Pirates", "Don Quixote Family", "Child", "Roger Pirates / Ex-Roger Pirates", "Thriller Bark Pirates", "Blackbeard Pirates", "Straw Hat Fleet", "Alabasta Kingdom", "Former Rocks Pirates"])
    ]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(rows.indices, id: \.self) { index in
                        TagButton(label: rows[index].0, isSelected: selectedIndex == index) {
                            selectedIndex = (selectedIndex == index) ? nil : index
                        }
                    }
                }
                .padding()
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                        if selectedIndex == nil || selectedIndex == index {
                            TagList(title: row.0, tags: row.1)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(UIColor.systemGray6))
    }
}

struct TagButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .padding(8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

struct TagList: View {
    let title: String
    let tags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)
            
            VStack(alignment: .leading, spacing: 5) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground).opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    MedalTagsView()
}

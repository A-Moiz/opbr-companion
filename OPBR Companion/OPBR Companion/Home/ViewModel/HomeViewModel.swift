//
//  HomeViewModel.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 01/11/2024.
//

import Foundation
import CloudKit
import UIKit

class HomeViewModel: ObservableObject {
    // Record Arrays
    @Published var supportImages: [SupportImage] = []
    @Published var medalSets: [MedalSet] = []
    @Published var characters: [Character] = []
    
    // Character arrays
    @Published var wantedCharacters: [Character] = []
    @Published var ownedCharacters: [Character] = []
    
    // Medal/Support arrays
    @Published var medalTagsArray: [(String, [String])] = [
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
    
    // Status effect arrays
    @Published var fixedDmgStatus: [(String, [String])] = [
        ("Venom", ["Effect: 2.5% damage every second", "Example character: Magellan"]),
        ("Poison", ["Effect: 1.15% damage every second", "Example character: Reiju"]),
        ("Stolen Heart", ["Effect: 6% damage every 6 seconds", "Example character: Dressrosa Law"]),
        ("Shock", ["Effect: 100 damage every second", "Example character: Raid Nami"]),
        ("Aflame", ["Effect: 90 damage every second", "Example character: Sabo"]),
        ("Frostbite", ["Effect: % damage based on Frostbite level (10%, 20%, 50%)", "Example character: Yamato"]),
        ("Incinerate", ["Effect: 4% damage every second", "Example character: Sakazuki"])
    ]
    
    @Published var immobilisingStatus: [(String, [String])] = [
        ("Tremor", ["Effect: Immobilises character", "Example character: Edward Newgate"]),
        ("Freeze", ["Effect: Immobilises character", "Example character: Kuzan"]),
        ("Entrance", ["Effect: Immobilises character", "Example character: Stampede Boa Bancock"]),
        ("Stun", ["Effect: Immobilises character", "Example character: Hakuba"]),
        ("Gold", ["Effect: Immobilises character", "Example character: Gild Tesoro"]),
        ("Stun", ["Effect: Immobilises character", "Example character: Hakuba"]),
        ("Sleep", ["Effect: Immobilises character", "Example character: Raid Usopp"]),
        ("Candyman", ["Effect: Immobilises character", "Example character: Charlotte Perospero"]),
        ("Gravity", ["Effect: Immobilises character", "Example character: Issho"]),
        ("Bind", ["Effect: Immobilises character", "Example character: Hina"]),
        ("Edit", ["Effect: Immobilises character", "Example character: Charlotte Pudding"]),
        ("Spiderweb", ["Effect: Immobilises character", "Example character: Black Maria"])
    ]
    
    @Published var selfStatus: [(String, [String])] = [
        ("Color of Arms", ["Effect: Increased ATK and CRIT rate", "Example character: Dressrosa Zoro"]),
        ("King of Hell", ["Effect: Recovers 50% HP when receiving damage that would otherwise result in a KO, can bypass enemies to capture the treasure, resists stagger and knockback, and nullifies immobilising status effects.", "Example character: Egghead Zoro"]),
        ("Red-Haired Haki", ["Effect: Nullifies status effects, resists stagger, and can only be targeted by normal attacks.", "Example character: FILM RED Shanks"]),
        ("Electrified", ["Effect: Deals a mid-range attack with a chance to shock, nullifies stagger and grants status effects nullification", "Example character: Charlotte Linlin"]),
        ("Flame-Flame", ["Effect: ATK is increased and character gains status effect nullification", "Example character: Sabo"]),
        ("Silence", ["Effect: Allies will not appear on the enemyies mini map", "Example character: Corazon"])
    ]
    
    @Published var otherStatus: [(String, [String])] = [
        ("Recovery Blocked", ["Effect: Character is unable to heal", "Example character: Raid Law"]),
        ("Clawed", ["Effect: Receive % damage and unable to use holding attacks (normal button and skills)", "Example character: Egghead Rob Lucci"]),
        ("Confuse", ["Effect: Inverts characters movements", "Example character: Don Quixote Doflamingo"]),
        ("Calm", ["Effect: Enemies unable to attack", "Example character: Ms. Goldenweek"]),
        ("Intimidate", ["Effect: Enemies unable to attack", "Example character: Ben Beckman"]),
        ("Toy", ["Effect: Enemies unable to attack", "Example character: Sugar"]),
        ("Dark", ["Effect: Enemies unable to dodge", "Example character: Marshall D. Teech"]),
        ("Capture Block", ["Effect: Enemies unable to capture flags", "Example character: FILM RED Yasopp"]),
        ("Hormone", ["Effect: Nullifies enemies ability to gain buffs", "Example character: Emporio Ivankov"]),
        ("Negative", ["Effect: Enemies unable to attack", "Example character: Perona"])
    ]
    
    // Alert
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    init() {
        loadOwnedCharacters()
        loadWantedCharacters()
    }
    
    // Function to toggle character ownership
    func toggleCharacterOwnership(for character: Character) {
        if isCharacterOwned(character) {
            ownedCharacters.removeAll { $0.name == character.name && $0.title == character.title }
        } else {
            ownedCharacters.append(character)
        }
        saveOwnedCharacters()
    }
    
    // Function to toggle character want status
    func toggleCharacterWant(for character: Character) {
        if isCharacterWanted(character) {
            wantedCharacters.removeAll { $0.name == character.name && $0.title == character.title }
        } else {
            wantedCharacters.append(character)
        }
        saveWantedCharacters()
    }
    
    // Check if a character is owned
    func isCharacterOwned(_ character: Character) -> Bool {
        ownedCharacters.contains(where: { $0.name == character.name && $0.title == character.title })
    }
    
    // Check if a character is wanted
    func isCharacterWanted(_ character: Character) -> Bool {
        wantedCharacters.contains(where: { $0.name == character.name && $0.title == character.title })
    }
    
    // Save to UserDefaults
    func saveOwnedCharacters() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(ownedCharacters) {
            UserDefaults.standard.set(encoded, forKey: "ownedCharacters")
        }
    }
    
    func saveWantedCharacters() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(wantedCharacters) {
            UserDefaults.standard.set(encoded, forKey: "wantedCharacters")
        }
    }
    
    // Load from UserDefaults
    func loadOwnedCharacters() {
        if let savedData = UserDefaults.standard.data(forKey: "ownedCharacters"),
           let decodedCharacters = try? JSONDecoder().decode([Character].self, from: savedData) {
            ownedCharacters = decodedCharacters
        }
    }
    
    func loadWantedCharacters() {
        if let savedData = UserDefaults.standard.data(forKey: "wantedCharacters"),
           let decodedCharacters = try? JSONDecoder().decode([Character].self, from: savedData) {
            wantedCharacters = decodedCharacters
        }
    }
    
    // Save and load image data locally
    private func localImagePath(for url: URL) -> URL {
        let fileName = url.lastPathComponent
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
    }
    
    // Saving artworks
    private func saveImageData(_ data: Data, for url: URL) {
        let path = localImagePath(for: url)
        do {
            try data.write(to: path)
        } catch {
            print("Error saving image data: \(error.localizedDescription)")
        }
    }
    
    // Loading artworks
    private func loadImageData(for url: URL) -> Data? {
        let path = localImagePath(for: url)
        return try? Data(contentsOf: path)
    }
    
    // Getting support tag
    func getSupportMessage(for tag: String) -> String? {
            if let tagData = supportTagsArray.first(where: { $0.0 == tag }) {
                return tagData.1.joined(separator: "\n\n")
            }
            return nil
        }
    
    // Getting medal tag
    func getMedalMessage(for tag: String) -> String? {
        if let tagData = medalTagsArray.first(where: { $0.1.contains(tag) }) {
            let key = tagData.0
            return key
        }
        return nil
    }
    
    // Fetching support images
    func fetchSupportImages(from containerName: String) {
        let customContainer = CKContainer(identifier: containerName)
        let publicDatabase = customContainer.publicCloudDatabase
        let query = CKQuery(recordType: "SupportImage", predicate: NSPredicate(value: true))
        
        publicDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            if let error = error {
                self?.showAlert(message: "Error fetching Support Images: \(error.localizedDescription)")
                print("Error fetching SupportImage records: \(error.localizedDescription)")
                return
            }
            
            guard let records = records else {
                return
            }
            
            DispatchQueue.main.async {
                self?.supportImages = records.compactMap { record in
                    guard let asset = record["image"] as? CKAsset,
                          let url = asset.fileURL,
                          let tags = record["supportTags"] as? [String],
                          let colour = record["supportColour"] as? String else {
                        print("Failed to extract fields from record: \(record)")
                        return nil
                    }
                    return SupportImage(imageURL: url, tags: tags, colour: colour)
                }
            }
        }
    }
    
    // Fetching medal sets
    func fetchMedalSets(from containerName: String) {
        let customContainer = CKContainer(identifier: containerName)
        let publicDatabase = customContainer.publicCloudDatabase
        let query = CKQuery(recordType: "MedalSet", predicate: NSPredicate(value: true))
        
        publicDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            if let error = error {
                self?.showAlert(message: "Error fetching Medal sets: \(error.localizedDescription)")
                print("Error fetching Medal sets: \(error.localizedDescription)")
                return
            }
            
            guard let records = records else {
                return
            }
            
            DispatchQueue.main.async {
                self?.medalSets = records.compactMap { record in
                    guard let asset = record["image"] as? CKAsset,
                          let url = asset.fileURL,
                          let bestFor = record["bestFor"] as? [String],
                          let medalTraits = record["medalTraits"] as? [String],
                          let description = record["description"] as? String else {
                        print("Failed to extract fields from record: \(record)")
                        return nil
                    }
                    return MedalSet(imageURL: url, description: description, bestFor: bestFor, medalTraits: medalTraits)
                }
            }
        }
    }
    
    // Fetching all characters
    func fetchAllCharacters(from containerName: String) {
        let customContainer = CKContainer(identifier: containerName)
        let publicDatabase = customContainer.publicCloudDatabase
        let query = CKQuery(recordType: "Character", predicate: NSPredicate(value: true))
        
        publicDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            if let error = error {
                self?.showAlert(message: "Error fetching Characters: \(error.localizedDescription)")
                print("Error fetching Characters: \(error.localizedDescription)")
                return
            }
            
            guard let records = records else {
                return
            }
            
            DispatchQueue.main.async {
                self?.characters = records.compactMap { record in
                    guard let asset = record["artwork"] as? CKAsset,
                          let medal = record["medal"] as? CKAsset,
                          let url = asset.fileURL,
                          let medalUrl = medal.fileURL,
                          let medalTrait = record["medalTrait"] as? String,
                          let characterClass = record["class"] as? String,
                          let name = record["name"] as? String,
                          let title = record["title"] as? String,
                          let colour = record["colour"] as? String else {
                        self?.showAlert(message: "Failed to extract essential fields from record: \(record)")
                        print("Failed to extract essential fields from record: \(record)")
                        return nil
                    }
                    
                    let tags = record["tags"] as? [String] ?? []
                    let medalTags = record["medalTags"] as? [String] ?? []
                    let guide = record["guide"] as? String
                    let videoUrl = record["videoUrl"] as? String
                    let recommendedStats = record["recommendedStats"] as? [String] ?? []
                    let statMessage = record["statMessage"] as? String
                    let recommendedSetAssets = record["recommendedSet"] as? [CKAsset]
                    let recommendedSet = recommendedSetAssets?.compactMap { $0.fileURL }
                    let setMessage = record["setMessage"] as? String
                    
                    // Save the image data if needed
                    if let imageData = try? Data(contentsOf: url) {
                        self?.saveImageData(imageData, for: url)
                    }
                    
                    return Character(imageURL: url, characterClass: characterClass, colour: colour, tags: tags, name: name, title: title, guide: guide, videoUrl: videoUrl, medalURL: medalUrl, medalTrait: medalTrait, medalTags: medalTags, recommendedSet: recommendedSet, setMessage: setMessage, recommededStats: recommendedStats, statMessage: statMessage)
                }
            }
        }
    }
    
    // Opening video function
    func videoGuide(videoUrl: URL) {
        UIApplication.shared.open(videoUrl, options: [:], completionHandler: nil)
    }
    
    // Showing alerts
    func showAlert(message: String) {
        DispatchQueue.main.async {
            self.alertMessage = message
            self.showAlert = true
        }
    }
}

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
    // Images array
    @Published var supportImages: [SupportImage] = []
    @Published var characterImages: [Character] = []
    
    // Character arrays
    @Published var wantedCharacters: [Character] = []
    @Published var ownedCharacters: [Character] = []
    
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
    
    func loadWantedCharacters() {
        if let savedData = UserDefaults.standard.data(forKey: "wantedCharacters"),
           let decodedCharacters = try? JSONDecoder().decode([Character].self, from: savedData) {
            wantedCharacters = decodedCharacters
        }
    }
    
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
                
                self?.characterImages = records.compactMap { record in
                    guard let asset = record["artwork"] as? CKAsset,
                          let url = asset.fileURL,
                          let tags = record["tags"] as? [String],
                          let characterClass = record["class"] as? String,
                          let name = record["name"] as? String,
                          let title = record["title"] as? String,
                          let colour = record["colour"] as? String else {
                        self?.showAlert(message: "Failed to extract fields from record: \(record)")
                        print("Failed to extract fields from record: \(record)")
                        return nil
                    }
                    
                    if let imageData = try? Data(contentsOf: url) {
                        self?.saveImageData(imageData, for: url)
                    }
                    
                    return Character(imageURL: url, characterClass: characterClass, colour: colour, tags: tags, name: name, title: title)
                }
            }
        }
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            self.alertMessage = message
            self.showAlert = true
        }
    }
}

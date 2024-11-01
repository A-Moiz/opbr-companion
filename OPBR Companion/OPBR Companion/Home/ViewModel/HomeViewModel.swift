//
//  HomeViewModel.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 01/11/2024.
//

import Foundation
import CloudKit

class HomeViewModel: ObservableObject {
    // images array
    @Published var supportImages: [SupportImage] = []
    @Published var characterImages: [Character] = []
    
    // Alert
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
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

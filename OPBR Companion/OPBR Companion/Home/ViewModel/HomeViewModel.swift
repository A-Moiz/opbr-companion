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
    
    // Alert
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    func fetchSupportImages(from containerName: String) {
        let customContainer = CKContainer(identifier: containerName)
        let publicDatabase = customContainer.publicCloudDatabase
        let query = CKQuery(recordType: "SupportImage", predicate: NSPredicate(value: true))

        publicDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            if let error = error {
                print("Error fetching SupportImage records: \(error.localizedDescription)")
                return
            }

            guard let records = records else {
                print("No records found.")
                return
            }

            // Debugging: Print the count of records retrieved
            print("Fetched \(records.count) SupportImage records.")

            DispatchQueue.main.async {
                self?.supportImages = records.compactMap { record in
                    // Debugging: Print the record fields to check their values
                    print("Record fields: \(record.allKeys())")
                    
                    // Ensure you're using the correct field types
                    guard let asset = record["image"] as? CKAsset,
                          let url = asset.fileURL,
                          let tags = record["supportTags"] as? [String],
                          let colour = record["supportColour"] as? String else {
                        print("Failed to extract fields from record: \(record)")
                        return nil // This allows the closure to return nil if any field is missing
                    }

                    // Return a new SupportImage only if all fields are successfully extracted
                    return SupportImage(imageURL: url, tags: tags, colour: colour)
                }

                // Debugging: Print the count after assignment
                print("SupportImages array count after fetching: \(self?.supportImages.count ?? 0)")
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

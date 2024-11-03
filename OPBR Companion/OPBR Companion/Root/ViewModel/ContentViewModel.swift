//
//  ContentViewModel.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

//import Foundation
//import KeychainAccess
//
//class ContentViewModel: ObservableObject {
//    private let keychain = Keychain(service: "com.abdul.OPBR-Companion")
//    private let userIDKey = "userID"
//    // Alert
//    @Published var alertMessage: String = ""
//    @Published var showAlert: Bool = false
//    
//    var userID: String {
//        get {
//            if let id = try? keychain.get(userIDKey) {
//                return id
//            } else {
//                let newID = UUID().uuidString
//                do {
//                    try keychain.set(newID, key: userIDKey)
//                } catch {
//                    showAlert(message: "Error saving new user ID to Keychain: \(error.localizedDescription)")
//                    print("Error saving new user ID to Keychain \(error.localizedDescription)")
//                }
//                return newID
//            }
//        }
//    }
//    
//    // Displaying alerts
//    func showAlert(message: String) {
//        self.alertMessage = message
//        self.showAlert = true
//    }
//}

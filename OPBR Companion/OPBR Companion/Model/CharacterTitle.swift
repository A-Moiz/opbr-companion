//
//  CharacterTitle.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 18/11/2024.
//

import Foundation

struct CharacterTitle: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    var wins: Int
    var winsLeft: Int {
        max(0, 100 - wins)
    }
}

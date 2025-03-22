//
//  MedalSet.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

import Foundation

struct MedalSet: Codable {
    let id: Int
    let name: String?
    let medals: [String]?
    let medalTraits: [String]?
    let bestFor: String
    let description: String?
    let tags: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case medals
        case medalTraits = "medal_traits"
        case bestFor = "best_for"
        case description
        case tags
    }
}

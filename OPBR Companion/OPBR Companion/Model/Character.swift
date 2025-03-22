//
//  Character.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 01/11/2024.
//

import Foundation

struct Character: Codable {
    let id: Int
    let artwork: String?
    let characterClass: String
    let color: String
    let name: String
    let title: String
    let guide: String?
    let recommendedSet: [String]?
    let setMessage: String?
    let recommendedStats: String?
    let statMessage: String?
    let medal: String?
    let medalTags: [String]
    let medalTrait: String
    let characterTags: [String]?
    
    enum CodingKeys: String, CodingKey {
            case id
            case artwork
            case characterClass = "class"
            case color
            case name
            case title
            case guide
            case recommendedSet = "recommended_set"
            case setMessage = "set_message"
            case recommendedStats = "recommended_stats"
            case statMessage = "stat_message"
            case medal
            case medalTags = "medal_tags"
            case medalTrait = "medal_trait"
            case characterTags = "character_tags"
        }
}

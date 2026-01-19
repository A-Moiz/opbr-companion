//
//  Support.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 17/01/2026.
//

import Foundation

struct Support: Codable, Identifiable {
    let id: Int
    let support: String?
    let supportColor: String?
    let supportTags: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case support = "support_img"
        case supportColor = "support_color"
        case supportTags = "support_tags"
    }
}

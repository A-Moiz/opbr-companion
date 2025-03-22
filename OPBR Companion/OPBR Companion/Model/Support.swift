//
//  Support.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 21/03/2025.
//

import Foundation

struct Support: Codable {
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

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

enum SupportSortOption: String, CaseIterable, Identifiable {
    case `default` = "Default"
    case mostTags = "Most Tags"
    
    var id: Self { self }
    var icon: String {
        switch self {
        case .default: return "line.3.horizontal.decrease.circle"
        case .mostTags: return "text.line.first.and.arrowtriangle.forward"
        }
    }
}

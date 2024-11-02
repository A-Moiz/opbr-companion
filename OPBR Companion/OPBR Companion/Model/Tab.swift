//
//  Tab.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 01/11/2024.
//

import Foundation

enum Tab: String, CaseIterable {
    case characters = "Characters"
    case support = "Support"
    case medalSets = "Medal Sets"
    
    var systemImage: String {
        switch self {
        case .characters:
            return "person"
        case .support:
            return "plus"
        case .medalSets:
            return "medal"
        }
    }
}

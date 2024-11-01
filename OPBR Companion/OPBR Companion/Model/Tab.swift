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
    
    var systemImage: String {
        switch self {
        case .characters:
            return "person"
        case .support:
            return "plus"
        }
    }
}

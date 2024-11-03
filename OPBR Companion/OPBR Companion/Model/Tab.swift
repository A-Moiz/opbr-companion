//
//  Tab.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 01/11/2024.
//

import Foundation

//enum Tab: String, CaseIterable {
//    case characters = "Characters"
//    case support = "Support"
//    case medalSets = "Medal Sets"
//    
//    var systemImage: String {
//        switch self {
//        case .characters:
//            return "person"
//        case .support:
//            return "plus"
//        case .medalSets:
//            return "medal"
//        }
//    }
//}

enum Tab: String, CaseIterable {
    case characters, support, medalSets
    
    var systemImage: String {
        switch self {
        case .characters: return "person.3.sequence.fill"
        case .support: return "person.2.fill"
        case .medalSets: return "star.circle.fill"
        }
    }
}

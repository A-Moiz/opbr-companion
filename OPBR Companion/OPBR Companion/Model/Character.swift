//
//  Character.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 01/11/2024.
//

import Foundation

struct Character: Codable, Equatable {
    let imageURL: URL
    let characterClass: String
    let colour: String
    let tags: [String]
    let name: String
    let title: String
    let guide: String?
    let videoUrl: String?
    let medalURL: URL
    let medalTrait: String
    let medalTags: [String]
    let recommendedSet: [URL]?
    let setMessage: String?
    let recommededStats: [String]?
    let statMessage: String?
}

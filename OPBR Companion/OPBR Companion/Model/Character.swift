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
}

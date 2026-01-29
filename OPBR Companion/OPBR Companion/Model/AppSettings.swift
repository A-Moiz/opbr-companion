//
//  AppSettings.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 29/01/2026.
//

import Foundation

struct AppSettings: Codable {
    let showArtworks: Bool
    let newExtremeUrl: String

    enum CodingKeys: String, CodingKey {
        case showArtworks = "show_artworks"
        case newExtremeUrl = "latest_extreme"
    }
}


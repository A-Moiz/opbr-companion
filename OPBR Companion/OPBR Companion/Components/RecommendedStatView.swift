//
//  RecommendedStatView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 21/03/2025.
//

import SwiftUI

struct RecommendedStatView: View {
    let recommendedStats: String
    let statMessage: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recommended Stats: \(recommendedStats)")
                .font(.headline)
                .padding(.bottom, 5)
            
            Text(statMessage)
            
            Text("Note that these recommendations may change if this character gets buffed or nerfed in the future.")
                .padding(.top)
        }
        .padding()
    }
}

//#Preview {
//    RecommendedStatView()
//}

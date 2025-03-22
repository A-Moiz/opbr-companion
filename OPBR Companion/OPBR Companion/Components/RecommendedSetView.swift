//
//  RecommendedSetView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 21/03/2025.
//

import SwiftUI
import Kingfisher

struct RecommendedSetView: View {
    let recommendedSet: [URL]
    let setMessage: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recommended Set")
                .font(.headline)
                .padding(.bottom, 5)
            
            HStack(spacing: 15) {
                ForEach(recommendedSet, id: \.self) { url in
                    KFImage(url)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            
            Text(setMessage)
            
            Text("Note that these recommendations may change as more medals are introduced to the game")
                .padding(.top)
        }
        .padding()
    }
}

//#Preview {
//    RecommendedSetView()
//}

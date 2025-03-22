//
//  MedalSectionView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 21/03/2025.
//

import SwiftUI
import Kingfisher

struct MedalSectionView: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let medalURLString = character.medal,
                   let medalURL = URL(string: medalURLString) {
                    KFImage(medalURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                
                Text("\(character.medalTrait)")
                    .font(.subheadline)
            }
            
            VStack {
                HStack {
                    Image(systemName: "tag")
                    Text("Medal Tags:")
                }
                .font(.system(size: 20))
                .bold()
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(character.medalTags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.vertical)
        }
        .padding()
    }
}

//#Preview {
//    MedalSectionView()
//}

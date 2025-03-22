//
//  CharacterTagsView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 21/03/2025.
//

import SwiftUI

struct CharacterTagsView: View {
    let tags: [String]
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "tag")
                Text("Character Tags:")
            }
            .font(.system(size: 20))
            .bold()
            .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.vertical)
    }
}

//#Preview {
//    CharacterTagsView()
//}

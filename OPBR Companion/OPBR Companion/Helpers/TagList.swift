//
//  TagList.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 05/11/2024.
//

import SwiftUI

struct TagList: View {
    let title: String
    let tags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)
            
            VStack(alignment: .leading, spacing: 5) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground).opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

//#Preview {
//    TagList()
//}

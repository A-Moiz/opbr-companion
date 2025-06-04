//
//  AltSetCardView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 04/06/2025.
//

import SwiftUI
import Kingfisher

struct AltSetCardView: View {
    let imageURLs: [URL]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    ForEach(imageURLs, id: \.self) { url in
                        KFImage(url)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 3)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray5))
                    .shadow(color: .black.opacity(0.15), radius: 4)
            )
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    AltSetCardView()
//}

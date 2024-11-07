//
//  MedalSetCardView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 07/11/2024.
//

import SwiftUI

struct MedalSetCardView: View {
    var medalSet: MedalSet
    @Environment(\.colorScheme) private var colourScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                if let uiImage = UIImage(contentsOfFile: medalSet.imageURL.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 4)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 180)
                        .cornerRadius(15)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(medalSet.medalTraits.joined(separator: ", "))
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Divider()
                
                Text("Best For: \(medalSet.bestFor.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Divider()
                
                Text(medalSet.description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(10)
            .background(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
            .cornerRadius(10)
            .shadow(radius: 3)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
                .shadow(color: .black.opacity(0.15), radius: 5)
        )
    }
}

//#Preview {
//    MedalSetCardView()
//}

//
//  MedalSetDetailView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 29/11/2024.
//

import SwiftUI

struct MedalSetDetailView: View {
    var medalSet: MedalSet
    @Environment(\.colorScheme) private var colourScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(Array(zip(medalSet.imageURLs, medalSet.medalTraits)), id: \.0) { imageURL, medalTrait in
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            if let uiImage = UIImage(contentsOfFile: imageURL.path) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(radius: 4)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(15)
                            }
                        }
                        
                        Text(medalTrait)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Best For: ")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.primary)
                    
                    Text(medalSet.bestFor.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Description: ")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.primary)
                    
                    Text(medalSet.description)
                        .font(.footnote)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tags:")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.primary)
                    
                    ForEach(medalSet.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Divider()
                    }
                }
            }
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
//    MedalSetDetailView()
//}

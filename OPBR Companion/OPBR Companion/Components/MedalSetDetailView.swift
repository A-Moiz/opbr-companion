//
//  MedalSetDetailView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 29/11/2024.
//

import SwiftUI
import Kingfisher

struct MedalSetDetailView: View {
    var medalSet: MedalSet
    @Environment(\.colorScheme) private var colourScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Display images and their corresponding traits
                ForEach(Array(zip(medalSet.medals ?? [], medalSet.medalTraits ?? [])), id: \.0) { medalURLString, medalTrait in
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            if let imageURL = URL(string: medalURLString) {
                                KFImage(imageURL)
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
                
                // Display best for
                VStack(alignment: .leading) {
                    Text("Best For: ")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.primary)
                    
                    Text(medalSet.bestFor)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
                
                Divider()
                
                // Display description
                VStack(alignment: .leading) {
                    Text("Description: ")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.primary)
                    
                    Text(medalSet.description ?? "No description available.")
                        .font(.footnote)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Divider()
                
                // Display tags
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tags:")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.primary)
                    
                    if let tags = medalSet.tags, !tags.isEmpty {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Divider()
                        }
                    } else {
                        Text("No tags available")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
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

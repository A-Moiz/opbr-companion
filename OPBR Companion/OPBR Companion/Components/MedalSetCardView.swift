//
//  MedalSetCardView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 07/11/2024.
//

import SwiftUI
import Kingfisher

struct MedalSetCardView: View {
    var medalSet: MedalSet
    @State private var showDetailView: Bool = false
    @Environment(\.colorScheme) private var colourScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            if let name = medalSet.name, !name.isEmpty {
                Text("\(name)")
                    .font(.headline)
                Divider()
            }
            
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
            
            Button {
                showDetailView = true
            } label: {
                HStack {
                    Text("Set Detail")
                    Image(systemName: "arrow.right")
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
                .shadow(color: .black.opacity(0.15), radius: 5)
        )
        .sheet(isPresented: $showDetailView) {
            MedalSetDetailView(medalSet: medalSet)
                .presentationDetents([.height(400)])
                .presentationCornerRadius(25)
        }
    }
}

//#Preview {
//    MedalSetCardView()
//}

//
//  AltSetsView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 18/01/2026.
//

import SwiftUI
import Kingfisher

struct AltSetsView: View {
    var altSets: [[String]]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("NOTE: EACH SET MAY REQUIRE SPECIFIC STAT ALLOCATIONS TO BE EFFECTIVE.")
                        .padding()
                        .foregroundStyle(Color.gray)
                    
                    Divider()
                    
                    ForEach(altSets.indices, id: \.self) { index in
                        AltSetCardView(imageURLs: altSets[index])
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Alternative/F2P Sets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                }
            }
        }
    }
}

// MARK: - Alt Sets card
struct AltSetCardView: View {
    let imageURLs: [String]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    ForEach(imageURLs.compactMap(URL.init(string:)), id: \.self) { url in
                        KFImage(url)
                            .resizable()
                            .frame(width: 60, height: 60)
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
//    AltSetsView()
//}

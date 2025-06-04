//
//  AltSetsView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 04/06/2025.
//

import SwiftUI

struct AltSetsView: View {
    var altSets: [[URL]]
    
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
            .navigationTitle("Alternative Sets")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

//#Preview {
//    AltSetsView()
//}

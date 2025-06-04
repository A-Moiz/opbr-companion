//
//  RecommendedSetView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 21/03/2025.
//

import SwiftUI
import Kingfisher

struct RecommendedSetView: View {
    let recommendedSet: [URL]
    let altSets: [[URL]]?
    let setMessage: String
    @State var showAltSetsView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recommended Set")
                .font(.headline)
                .padding(.bottom, 5)
            
            HStack(spacing: 15) {
                ForEach(recommendedSet, id: \.self) { url in
                    KFImage(url)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            
            Text(setMessage)
            
            Text("Note that these recommendations may change as more medals are introduced to the game")
                .padding(.top)
            
            if let altSets = altSets, !altSets.isEmpty {
                Button {
                    showAltSetsView = true
                } label: {
                    HStack {
                        Text("Alternative/F2P Sets")
                        Image(systemName: "arrow.right")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .sheet(isPresented: $showAltSetsView) {
            AltSetsView(altSets: altSets ?? [])
                .presentationCornerRadius(25)
        }
    }
}

//#Preview {
//    RecommendedSetView()
//}

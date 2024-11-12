//
//  StatusEffectsView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 11/11/2024.
//

import SwiftUI

struct StatusEffectsView: View {
    @ObservedObject var homeVM: HomeViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    // Fixed Damage
                    Text("Fixed damage Status Effects:")
                        .font(.largeTitle)
                        .bold()
                    VStack(spacing: 20) {
                        ForEach(Array(homeVM.fixedDmgStatus.enumerated()), id: \.offset) { index, row in
                            TagList(title: row.0, tags: row.1)
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    // Immobilising
                    Text("Immobilising Status Effects:")
                        .font(.largeTitle)
                        .bold()
                    VStack(spacing: 20) {
                        ForEach(Array(homeVM.immobilisingStatus.enumerated()), id: \.offset) { index, row in
                            TagList(title: row.0, tags: row.1)
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    // Self inflicting
                    Text("Self inflicting Status Effects:")
                        .font(.largeTitle)
                        .bold()
                    VStack(spacing: 20) {
                        ForEach(Array(homeVM.selfStatus.enumerated()), id: \.offset) { index, row in
                            TagList(title: row.0, tags: row.1)
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    // Other status
                    Text("Other Status Effects:")
                        .font(.largeTitle)
                        .bold()
                    VStack(spacing: 20) {
                        ForEach(Array(homeVM.otherStatus.enumerated()), id: \.offset) { index, row in
                            TagList(title: row.0, tags: row.1)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Status Effects")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGray6))
        }
    }
}

#Preview {
    StatusEffectsView(homeVM: HomeViewModel())
}

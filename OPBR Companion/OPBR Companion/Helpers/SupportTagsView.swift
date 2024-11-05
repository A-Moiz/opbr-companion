//
//  SupportTagsView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 05/11/2024.
//

import SwiftUI

struct SupportTagsView: View {
    @State private var selectedIndex: Int? = nil
    @ObservedObject var homeVM: HomeViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(homeVM.supportTagsArray.indices, id: \.self) { index in
                            TagButton(label: homeVM.supportTagsArray[index].0, isSelected: selectedIndex == index) {
                                selectedIndex = (selectedIndex == index) ? nil : index
                            }
                        }
                    }
                    .padding()
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(Array(homeVM.supportTagsArray.enumerated()), id: \.offset) { index, row in
                            if selectedIndex == nil || selectedIndex == index {
                                TagList(title: row.0, tags: row.1)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Support Tags")
            .toolbarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGray6))
        }
    }
}

#Preview {
    SupportTagsView(homeVM: HomeViewModel())
}

//
//  SearchBar.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 02/11/2024.
//

import SwiftUI

struct SearchBar: View {
    // Search text
    @Binding var searchText: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(text, text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
            Image(systemName: "x.circle")
                .onTapGesture {
                    searchText = ""
                }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
    }
}

//#Preview {
//    SearchBar()
//}

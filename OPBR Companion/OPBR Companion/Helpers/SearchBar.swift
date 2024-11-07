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
    // Colour scheme
    @Environment(\.colorScheme) private var colourScheme
    
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
        .background(colourScheme == .light ? Color(.systemGray5) : Color(.systemGray5))
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    SearchBar(searchText: .constant(""), text: .constant("Search..."))
}

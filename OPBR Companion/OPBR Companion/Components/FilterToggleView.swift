//
//  FilterToggleView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 18/01/2026.
//

import SwiftUI

struct FilterToggleView: View {
    @Binding var showFilter: Bool
    @State var hideText: String
    @State var showText: String
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showFilter.toggle()
            }
        } label: {
            Label(showFilter ? hideText : showText,
                  systemImage: showFilter ? "chevron.up" : "line.3.horizontal.decrease.circle")
            .fontWeight(.medium)
        }
        .buttonStyle(.bordered)
        .tint(.orange)
        .padding()
    }
}

#Preview {
    @Previewable @State var showFilter: Bool = false
    FilterToggleView(showFilter: $showFilter, hideText: "", showText: "")
}

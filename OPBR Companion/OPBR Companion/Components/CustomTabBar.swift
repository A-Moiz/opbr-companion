//
//  CustomTabBar.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 22/03/2025.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 30) {
            ForEach(Tab.allCases, id: \.self) { tab in
                VStack {
                    Image(systemName: tab.systemImage)
                        .foregroundColor(selectedTab == tab ? .blue : .gray)
                    Text(tab.rawValue)
                        .font(.caption)
                }
                .onTapGesture {
                    withAnimation {
                        selectedTab = tab
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

//#Preview {
//    CustomTabBar()
//}

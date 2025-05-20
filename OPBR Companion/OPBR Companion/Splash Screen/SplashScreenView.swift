//
//  SplashScreenView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 31/10/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @Environment(\.colorScheme) private var colourScheme
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colourScheme == .dark ? Color(.systemGray6) : Color(.systemGray))
            
            Image("Icon-5")
                .resizable()
                .frame(width: 400, height: 400)
                .cornerRadius(20)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashScreenView()
}

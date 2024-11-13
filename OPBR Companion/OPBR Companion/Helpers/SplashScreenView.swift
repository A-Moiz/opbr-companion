//
//  SplashScreenView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 31/10/2024.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.splashBG)
            
            Image("icon-3")
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashScreenView()
}

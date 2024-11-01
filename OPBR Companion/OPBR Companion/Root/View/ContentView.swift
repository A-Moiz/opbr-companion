//
//  ContentView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 31/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplashScreen: Bool = true
    
    var body: some View {
        ZStack {
            if showSplashScreen {
                SplashScreenView()
                    .transition(CustomSplashTransition(isRoot: true))
            } else {
                HomeView()
                    .transition(CustomSplashTransition(isRoot: false))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea()
        .task {
            guard showSplashScreen else { return }
            try? await Task.sleep(for: .seconds(0.5))
            withAnimation(.smooth(duration: 0.55)) {
                showSplashScreen = false
            }
        }
    }
}

#Preview {
    ContentView()
}

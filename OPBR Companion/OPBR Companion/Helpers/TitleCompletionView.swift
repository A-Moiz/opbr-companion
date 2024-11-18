//
//  TitleCompletionView.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 18/11/2024.
//

import SwiftUI
import Lottie

struct TitleCompletionView: View {
    @Binding var showAnimation: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            
            if let bundlePath = Bundle.main.path(forResource: "glitterAnimation", ofType: "json") {
                LottieView {
                    await LottieAnimation.loadedFrom(url: URL(filePath: bundlePath))
                }
                .playing(loopMode: .playOnce)
                .onDisappear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        showAnimation = false
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var showAnimation = true
    TitleCompletionView(showAnimation: $showAnimation)
}

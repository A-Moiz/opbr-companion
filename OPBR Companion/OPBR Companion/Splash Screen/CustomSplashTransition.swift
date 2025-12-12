//
//  CustomSplashTransition.swift
//  OPBR Companion
//
//  Created by Abdul Moiz on 31/10/2024.
//

import Foundation
import UIKit
import SwiftUI

struct CustomSplashTransition: Transition {
    var isRoot: Bool
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .offset(y: phase.isIdentity ? 0 : isRoot ? screenSize.height : -screenSize.height)
    }
    
    var screenSize: CGSize {
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return screenSize
        }
        
        return .zero
    }
}

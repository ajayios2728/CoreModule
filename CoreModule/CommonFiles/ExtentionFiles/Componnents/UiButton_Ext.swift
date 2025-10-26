//
//  UiButton_Ext.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import SwiftUICore


struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        // Define the shake motion, e.g., using sine wave for x-offset
        let xOffset = sin(animatableData * .pi * 2 * 3) * 5 // Shake 3 times, with 10pt amplitude
        return ProjectionTransform(CGAffineTransform(translationX: xOffset, y: 0))
    }
}

extension View {
    func shake(trigger: Bool) -> some View {
        self.modifier(ShakeEffect(animatableData: trigger ? 1 : 0))
    }
}

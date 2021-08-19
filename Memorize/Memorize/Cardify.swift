//
//  Cardify.swift
//  Memorize
//
//  Created by David Inga on 8/16/21.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double // in degrees
    let color: Color
    let gradient: LinearGradient?
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    init(isFaceUp: Bool, color: Color, gradient: LinearGradient?) {
        rotation = isFaceUp ? 0 : 180
        self.color = color
        self.gradient = gradient
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                if let gradient = gradient {
                    shape.strokeBorder(gradient)
                } else {
                    shape.strokeBorder().foregroundColor(color)
                }
            } else {
                if let gradient = gradient {
                    shape.fill(gradient)
                } else {
                    shape.foregroundColor(color)
                }
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(
            Angle(degrees: rotation),
            axis: (x: 0, y: 1, z: 0)
        )
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
    }
}

extension View {
    func cardify(isFaceUp: Bool, color: Color, gradient: LinearGradient?) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, color: color, gradient: gradient))
    }
}

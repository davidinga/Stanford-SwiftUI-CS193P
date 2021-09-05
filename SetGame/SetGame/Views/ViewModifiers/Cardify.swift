//
//  Cardify.swift
//  SetGame
//
//  Created by David Inga on 8/19/21.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    let card: ClassicSetGame.Card
    var isSelected: Bool = false
    var isMatch: Bool = false
    var isMismatch: Bool = false
    var rotation: Double
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    init(card: ClassicSetGame.Card, isSelected: Bool, isMatch: Bool, isMismatch: Bool) {
        rotation = card.isFaceUp ? 0 : 180
        self.card = card
        self.isSelected = isSelected
        self.isMatch = isMatch
        self.isMismatch = isMismatch
    }

    @State private var isMatched = false
    @State private var isMismatched = false
    @State private var shouldAnimate = false

    func body(content: Content) -> some View {

        ZStack {
            // Card Shape with various selection states.
            if rotation < 90 {
                frontOfCardShape
            } else {
                backOfCardShape
            }
            // Card content.
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(
            Angle(degrees: rotation),
            axis: (x: 0, y: 1, z: 0)
        )

    }

    @ViewBuilder
    var frontOfCardShape: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let cardShape = RoundedRectangle(cornerRadius: width * CardConstants.cornerRadiusRatio)

            cardShape
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [.white, Color(white: CardConstants.gradientColorRatio)]),
                        center: .center,
                        startRadius: width * CardConstants.gradientRadiusStartRatio,
                        endRadius: width
                    )
                )

            if isSelected {
                cardShape
                    .stroke(lineWidth: width * CardConstants.selectionLineWidthRatio)
                    .fill(Color.blue)
                    .transition(AnyTransition.identity)
            } else if isMatch {
                cardShape
                    .stroke(lineWidth: width * CardConstants.selectionLineWidthRatio)
                    .fill(Color.green)
                    .transition(AnyTransition.identity)
            } else if isMismatch {
                cardShape
                    .stroke(lineWidth: width * CardConstants.selectionLineWidthRatio)
                    .fill(Color.red)
                    .transition(AnyTransition.identity)
            }
        }
    }

    @ViewBuilder
    var backOfCardShape: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let cardShape = RoundedRectangle(cornerRadius: width * CardConstants.cornerRadiusRatio)

            ZStack {
                cardShape
                    .strokeBorder(Color.white, lineWidth: width * CardConstants.backOfCardStrokeRatio)
                    .background(
                        Image("backOfCard")
                            .resizable(resizingMode: .tile)
                            .cornerRadius(width * CardConstants.cornerRadiusRatio)
                    )
            }
        }
    }
}

struct CardConstants {
    static let cornerRadiusRatio: CGFloat = 0.1
    static let selectionLineWidthRatio: CGFloat = 0.02
    static let backOfCardStrokeRatio: CGFloat = 0.04
    static let gradientColorRatio: Double = 0.9
    static let gradientRadiusStartRatio: CGFloat = 0.75
}

extension View {
    func cardify(card: ClassicSetGame.Card, isSelected: Bool = false, isMatch: Bool = false, isMismatch: Bool = false) -> some View {
        self.modifier(Cardify(card: card, isSelected: isSelected, isMatch: isMatch, isMismatch: isMismatch))
    }
}

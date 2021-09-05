//
//  Squiggle.swift
//  SetGame
//
//  Created by David Inga on 8/11/21.
//

import SwiftUI

struct Squiggle: Shape, InsettableShape {
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        /// Two points on the left and right.
        let offset = CGFloat(rect.height * 1/10)
        let left = CGPoint(x: insetAmount, y: rect.midY + offset)
        let right = CGPoint(x: rect.width - insetAmount, y: rect.midY - offset)

        /// Constraints for the two curves.
        let highTop = CGPoint(x: rect.midX, y: (rect.midY - rect.width / 2) + insetAmount)
        let highBottom = CGPoint(x: rect.midX, y: (rect.midY + rect.width / 2.5) - insetAmount)
        let lowTop = CGPoint(x: rect.midX, y: (rect.midY - rect.width / 10))
        let lowBottom = CGPoint(x: rect.midX, y: (rect.midY + rect.width / 10))

        path.move(to: left)
        path.addCurve(to: right, control1: highTop, control2: lowBottom)
        path.addCurve(to: left, control1: highBottom, control2: lowTop)

        return path
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

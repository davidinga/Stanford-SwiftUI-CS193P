//
//  Diamond.swift
//  SetGame
//
//  Created by David Inga on 8/11/21.
//

import SwiftUI

struct Diamond: Shape, InsettableShape {
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let top = CGPoint(x: rect.midX, y: (rect.midY - rect.width / 5) + insetAmount)
        let right = CGPoint(x: rect.width - insetAmount, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: (rect.midY + rect.width / 5) - insetAmount)
        let left = CGPoint(x: insetAmount, y: rect.midY)
        path.move(to: top)
        path.addLine(to: right)
        path.addLine(to: bottom)
        path.addLine(to: left)
        path.addLine(to: top)
        path.addLine(to: right)
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

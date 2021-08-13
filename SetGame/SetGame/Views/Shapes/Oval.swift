//
//  Oval.swift
//  SetGame
//
//  Created by David Inga on 8/11/21.
//

import SwiftUI

struct Oval: Shape, InsettableShape {
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let padding = rect.midY - (rect.midY - rect.width / 5)
        
        /// Constraints for four points.
        let topLeft = CGPoint(x: padding, y: (rect.midY - rect.width / 5) + insetAmount)
        let topRight = CGPoint(x: (rect.width - padding), y: (rect.midY - rect.width / 5) + insetAmount)
        let bottomLeft = CGPoint(x: padding, y: (rect.midY + rect.width / 5) - insetAmount)
        let bottomRight = CGPoint(x: (rect.width - padding), y: (rect.midY + rect.width / 5) - insetAmount)
        
        /// Constraints for the first of two half circles.
        var startAngle = Angle(degrees: -90)
        var endAngle = Angle(degrees: 90)
        var center = CGPoint(x: bottomRight.x, y: rect.midY)
        let radius = rect.midY - topRight.y
        
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: bottomLeft)
        
        /// Rotate the half cirlce 180 degrees for the left side.
        startAngle = Angle(degrees: 90)
        endAngle = Angle(degrees: -90)
        center = CGPoint(x: bottomLeft.x, y: rect.midY)
        
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

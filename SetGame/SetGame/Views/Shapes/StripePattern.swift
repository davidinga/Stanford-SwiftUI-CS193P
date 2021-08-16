//
//  StripePattern.swift
//  SetGame
//
//  Created by David Inga on 8/16/21.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

extension CGImage {
    
    /// Returns a CGImage with a stripe pattern; returns nil otherwise.
    static func generateStripePattern(
        colors: (UIColor, UIColor) = (.clear, .black),
        width: CGFloat = 6,
        ratio: CGFloat = 1) -> CGImage?
    {
        
        let context = CIContext()
        let stripes = CIFilter.stripesGenerator()
        stripes.color0 = CIColor(color: colors.0)
        stripes.color1 = CIColor(color: colors.1)
        stripes.width = Float(width)
        stripes.center = CGPoint(x: 1-width*ratio, y: 0)
        let size = CGSize(width: width, height: 1)
        
        guard
            let stripesImage = stripes.outputImage,
            let image = context.createCGImage(stripesImage, from: CGRect(origin: .zero, size: size))
        else { return nil }
        return image
    }
}

extension Shape {
    
    /// Extends `Shape` to add a stripe pattern.
    func stripes(color: UIColor, angle: Double = 0) -> AnyView {
        guard let stripePattern = CGImage.generateStripePattern(colors: (.clear, color))
        else { return AnyView(self) }
        
        return AnyView(
            Rectangle().fill(
                ImagePaint(image: Image(decorative: stripePattern, scale: 2))
            )
            .rotationEffect(.degrees(angle))
            .clipShape(self)
        )
    }
}

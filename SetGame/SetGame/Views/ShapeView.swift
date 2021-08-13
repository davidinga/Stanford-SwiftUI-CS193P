//
//  ShapeView.swift
//  SetGame
//
//  Created by David Inga on 8/13/21.
//

import SwiftUI

struct ShapeView: View {
    let features: ClassicSetGameFeatures
    
    var body: some View {
        VStack {
            ForEach(0..<features.numberOfShapes, id: \.self) { _ in
                switch features.shading {
                case .solid:
                    solidShape
                case .stripped:
                    strippedShape
                case .open:
                    openShape
                }
            }
        }
    }
    
    @ViewBuilder
    var solidShape: some View {
        switch features.shape {
        case .diamond:
            Diamond().fill(features.color)
        case .squiggle:
            Squiggle().fill(features.color)
        case .oval:
            Oval().fill(features.color)
        }
    }
    
    @ViewBuilder
    var strippedShape: some View {
        switch features.shape {
        case .diamond:
            ZStack {
                Diamond().strokeBorder(features.color)
                Diamond().fill(features.color).opacity(0.5)
            }
        case .squiggle:
            ZStack {
                Squiggle().strokeBorder(features.color)
                Squiggle().fill(Color.red).opacity(0.5)
            }
        case .oval:
            ZStack {
                Oval().strokeBorder(features.color)
                Oval().fill(Color.red).opacity(0.5)
            }
        }
    }
    
    @ViewBuilder
    var openShape: some View {
        switch features.shape {
        case .diamond:
            Diamond().strokeBorder(features.color)
        case .squiggle:
            Squiggle().strokeBorder(features.color)
        case .oval:
            Oval().strokeBorder(features.color)
        }
    }
}


//
//  ClassicSetGameFeatures.swift
//  SetGame
//
//  Created by David Inga on 8/13/21.
//

import SwiftUI

struct ClassicSetGameFeatures: Hashable {
    var numberOfShapes: Int
    var shape: Shape
    var shading: Shading
    var color: Color

    enum Shape {
        case diamond, squiggle, oval
    }

    enum Shading {
        case solid, stripped, open
    }
}


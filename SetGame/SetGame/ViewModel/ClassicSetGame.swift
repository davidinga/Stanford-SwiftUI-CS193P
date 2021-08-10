//
//  ClassicSetGame.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import SwiftUI

class ClassicSetGame: ObservableObject {
    typealias Card = SetGame<String>.Card
    
    static func createClassicSetGame() -> SetGame<String> {
        SetGame<String> { featuresForAllCards in
            var content: [String] = []
            for features in featuresForAllCards {

                /// Build custom shape for each set of features
                /// buildShape(numberOfShapes:shape:shading:color:)
                /// Add custom shape to [Shape]
                /// Return [Shape]

                /// Must return list of shapes in the same order
                /// that we received list of features.

                /// Going to build cards with String
                /// for testing purposes.

                let uniqueString: String

                let numberOfShapes: String
                let shape: String
                let shading: String
                let color: String

                switch features.numberOfShapes {
                    case .low:
                        numberOfShapes = "One"
                    case .mid:
                        numberOfShapes = "Two"
                    case .high:
                        numberOfShapes = "Three"
                }

                switch features.shape {
                    case .low:
                        shape = "Triangle"
                    case .mid:
                        shape = "Squiggle"
                    case .high:
                        shape = "Oval"
                }

                switch features.shading {
                    case .low:
                        shading = "Solid"
                    case .mid:
                        shading = "Striped"
                    case .high:
                        shading = "Open"
                }

                switch features.color {
                    case .low:
                        color = "Red"
                    case .mid:
                        color = "Green"
                    case .high:
                        color = "Purple"
                }
                
                uniqueString = "\(numberOfShapes)\n\(shape)\n\(shading)\n\(color)"
                content.append(uniqueString)
            }
            return content
        }
    }

    @Published private var setGame = createClassicSetGame()
    
    var cards: [Card] {
        Array(Array(setGame.cards)[0...11])
    }
}

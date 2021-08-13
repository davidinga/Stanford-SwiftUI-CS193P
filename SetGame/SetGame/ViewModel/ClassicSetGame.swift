//
//  ClassicSetGame.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import SwiftUI

class ClassicSetGame: ObservableObject {
    typealias Card = SetGame<ClassicSetGameFeatures>.Card
    
    static func createClassicSetGame() -> SetGame<ClassicSetGameFeatures> {
        SetGame<ClassicSetGameFeatures> { featuresForAllCards in
            var content: [ClassicSetGameFeatures] = []
            for features in featuresForAllCards {
                
                var featuresForCard = ClassicSetGameFeatures(numberOfShapes: .one, shape: .diamond, shading: .open, color: .green)

                switch features.numberOfShapes {
                    case .low:
                        featuresForCard.numberOfShapes = .one
                    case .mid:
                        featuresForCard.numberOfShapes = .two
                    case .high:
                        featuresForCard.numberOfShapes = .three
                }

                switch features.shape {
                    case .low:
                        featuresForCard.shape = .diamond
                    case .mid:
                        featuresForCard.shape = .squiggle
                    case .high:
                        featuresForCard.shape = .oval
                }

                switch features.shading {
                    case .low:
                        featuresForCard.shading = .solid
                    case .mid:
                        featuresForCard.shading = .stripped
                    case .high:
                        featuresForCard.shading = .open
                }

                switch features.color {
                    case .low:
                        featuresForCard.color = .red
                    case .mid:
                        featuresForCard.color = .green
                    case .high:
                        featuresForCard.color = .purple
                }
                
                content.append(featuresForCard)
            }
            return content
        }
    }

    @Published private var setGame = createClassicSetGame()
    
    var cards: [Card] {
        Array(setGame.cardsInPlay)
    }
    
    var score: Int {
        setGame.players.first!.score
    }
    
    var threeCardsSelected: Bool {
        setGame.threeCardsSelected
    }
    
    func isSelected(_ card: Card) -> Bool {
        if setGame.selectedCardIDs.contains(card.id) { return true }
        return false
    }
    
    func choose(_ card: Card) {
        setGame.choose(card)
    }
    
    func dealCards() {
        setGame.dealCards()
    }
    
    func createNewGame() {
        setGame = ClassicSetGame.createClassicSetGame()
    }
}

struct ClassicSetGameFeatures: Hashable {
    var numberOfShapes: NumberOfShapes
    var shape: Shape
    var shading: Shading
    var color: Color
    
    enum NumberOfShapes: Int {
        case one = 1, two, three
    }

    enum Shape {
        case diamond, squiggle, oval
    }

    enum Shading {
        case solid, stripped, open
    }

    enum Color {
        case red, green, purple
    }
}

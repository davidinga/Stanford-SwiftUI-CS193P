//
//  ClassicSetGame.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import SwiftUI

class ClassicSetGame: ObservableObject {
    typealias Card = SetGame<ClassicSetGameFeatures>.Card
    
    private static func createClassicSetGame() -> SetGame<ClassicSetGameFeatures> {
        SetGame<ClassicSetGameFeatures> { featuresForAllCards in
            var content: [ClassicSetGameFeatures] = []
            for features in featuresForAllCards {
                
                var featuresForCard = ClassicSetGameFeatures(numberOfShapes: 1, shape: .diamond, shading: .open, color: .red)

                switch features.numberOfShapes {
                    case .low:
                        featuresForCard.numberOfShapes = 1
                    case .mid:
                        featuresForCard.numberOfShapes = 2
                    case .high:
                        featuresForCard.numberOfShapes = 3
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
        setGame.cardsInPlay
    }
    
    var score: Int {
        setGame.players.first!.score
    }
    
    var deckIsEmpty: Bool {
        setGame.deckOfCards.isEmpty
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
        setGame.dealCards(isUserRequest: true)
    }
    
    func requestHint() -> Bool {
        setGame.findPairOfMatchingCards()
    }
    
    func createNewGame() {
        setGame = ClassicSetGame.createClassicSetGame()
    }
}

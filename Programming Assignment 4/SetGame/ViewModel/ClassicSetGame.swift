//
//  ClassicSetGame.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import SwiftUI

class ClassicSetGame: ObservableObject {
    typealias Card = SetGame<ClassicSetGameFeatures>.Card
    
    /// A function used to initialize a new game of Set.
    private static func createClassicSetGame() -> SetGame<ClassicSetGameFeatures> {
        /// Configures cards with features defined by `ClassicSetGameFeatures`.
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
    
    /// Playable cards that are face up.
    var cardsInPlay: [Card] {
        setGame.cardsInPlay
    }
    /// Deck of cards to deal from.
    var deckOfCards: [Card] {
        setGame.deckOfCards
    }
    /// Discard pile for a single player.
    var discardPile: [Card] {
        setGame.activePlayer.cards
    }
    /// Returns the score for a single player.
    var score: Int {
        setGame.activePlayer.score
    }
    /// Returns true if the deck is empty.
    var deckIsEmpty: Bool {
        setGame.deckOfCards.isEmpty
    }
    /// Returns the ID's of the selected cards.
    var selectedCardIDs: [UUID] {
        setGame.selectedCardIDs
    }
    /// Returns true if three cards are selected.
    var threeCardsSelected: Bool {
        setGame.threeCardsSelected
    }
    /// Returns true if the card is selected.
    func isSelected(_ card: Card) -> Bool {
        setGame.selectedCardIDs.contains(card.id) && !card.isMatched && !threeCardsSelected
    }
    /// Returns true if the selected cards are a mismatch.
    func isMismatch(_ card: Card) -> Bool {
        setGame.selectedCardIDs.contains(card.id) && !card.isMatched && threeCardsSelected
    }
    /// Returns true if the selected cards match.
    func isMatch(_ card: Card) -> Bool {
        setGame.selectedCardIDs.contains(card.id) && card.isMatched && threeCardsSelected
    }
    /// Flips card face up.
    func flip(_ card: Card) {
        setGame.flip(card: card)
    }
    /// Deals twelve cards to start game.
    func dealTwelveCards() {
        setGame.dealCards(isNewGame: true)
    }
    /// User chooses a card.
    func choose(_ card: Card) {
        setGame.choose(card)
    }
    /// User requests to deal cards.
    func dealCards() {
        setGame.dealCards(isUserRequest: true)
    }
    /// User requests a hint.
    func requestHint() -> Bool {
        setGame.findSetOfMatchingCards()
    }
    /// User requests a new game.
    func createNewGame() {
        setGame = ClassicSetGame.createClassicSetGame()
        setGame.dealCards(isNewGame: true)
    }
}

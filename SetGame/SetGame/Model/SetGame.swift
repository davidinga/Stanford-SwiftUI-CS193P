//
//  SetGame.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import Foundation

struct SetGame<CardContent> where CardContent: Hashable {
    let numberOfCards = 81
    let numberOfFeatures = 4
    let numberOfCardsToSelect = 3
    var deckOfCards: [Card] = []
    var cardsInPlay: [Card] = []
    var selectedCardIDs: [Int] = []
    var players: [Player]
    
    var threeCardsSelected: Bool {
        selectedCardIDs.count == numberOfCardsToSelect
    }
    
    /// Returns true if the selected cards create a set.
    var isMatch: Bool {
        guard threeCardsSelected else {
            return false
        }
        
        /// For each one of the four categories of features —
        /// color, number, shape, and shading —
        /// the three cards must display that feature as a) either all the same, or b) all different.
        
        var numberOfShapes, shape, shading, color: [TriState]
        numberOfShapes = []; shape = []; shading = []; color = []
        for id in selectedCardIDs {
            let card = cardsInPlay.first(where: {$0.id == id})!
            numberOfShapes.append(card.features.numberOfShapes)
            shape.append(card.features.shape)
            shading.append(card.features.shading)
            color.append(card.features.color)
        }
        
        guard isAllTheSameOrAllDifferent(numberOfShapes) else {
            return false
        }
        
        guard isAllTheSameOrAllDifferent(shape) else {
            return false
        }
        
        guard isAllTheSameOrAllDifferent(shading) else {
            return false
        }
        
        guard isAllTheSameOrAllDifferent(color) else {
            return false
        }
        
        return true
    }
    
    func isAllTheSameOrAllDifferent(_ elements: [TriState]) -> Bool {
        let set = Set(elements)
        return set.count == 1 || set.count == 3
    }
    
    /// Selects a card from the `cardsInPlay`.
    mutating func choose(_ card: Card) {
        /// If three cards were selected and not matched, clear selected cards.
        if threeCardsSelected { selectedCardIDs = [] }
        /// Remove any cards that were matched from the `cardsInPlay`.
        cardsInPlay.removeAll(where: {$0.isMatched == true})
        /// Deselect card if one or two cards are currently selected.
        if let index = selectedCardIDs.firstIndex(of: card.id), !threeCardsSelected {
            selectedCardIDs.remove(at: index)
        /// Select card if there are less than three cards selected.
        } else if !card.isMatched && selectedCardIDs.count < numberOfCardsToSelect {
            selectedCardIDs.append(card.id)
        }
        /// If three cards are selcted and there is a match, mark the cards as matched, clear the selected cards, and add to the score.
        if threeCardsSelected, isMatch {
                for id in selectedCardIDs {
                    let index = cardsInPlay.firstIndex(where: {$0.id == id})!
                    cardsInPlay[index].isMatched = true
                }
                selectedCardIDs = []
                players[0].score += 1
        }
    }
    
    /// Takes a specified`numberOfCards` out of `deckOfCards` and adds them to the `cardsInPlay`.
    mutating func dealCards(numberOfCards: Int = 3) {
        guard !deckOfCards.isEmpty else { return }
        cardsInPlay.append(contentsOf: deckOfCards[0..<numberOfCards])
        deckOfCards.removeSubrange(0..<numberOfCards)
    }

    init(createCardContent: ([(numberOfShapes: TriState, shape: TriState, shading: TriState, color: TriState)]) -> [CardContent]) {
        /// A collection of features for deck of cards.
        var featuresForDeckOfCards: [(TriState, TriState, TriState, TriState)] = []
        /// Each card has four features with three variations represented by a `TriState`.
        var a, b, c, d: TriState
        /// A `TriState` can have one of three values: `.low`, `.mid`, or `.high`.
        a = .low; b = .low; c = .low; d = .low
        /// Create collection of 81 unique features.
        for _ in 0..<3 {
            for _ in 0..<3 {
                for _ in 0..<3 {
                    for _ in 0..<3 {
                        featuresForDeckOfCards.append((a,b,c,d))
                        d.next()
                    }
                    c.next()
                }
                b.next()
            }
            a.next()
        }
        /// Create card content for cards by passing collection of features to ititializer.
        let content = createCardContent(featuresForDeckOfCards)
        
        /// Add cards to `deckOfCards`
        for index in featuresForDeckOfCards.indices {
            let featuresForCard = Card.Features( numberOfShapes: featuresForDeckOfCards[index].0,
                                                 shape:          featuresForDeckOfCards[index].1,
                                                 shading:        featuresForDeckOfCards[index].2,
                                                 color:          featuresForDeckOfCards[index].3
            )
            let card = Card(id: index, features: featuresForCard, content: content[index])
            deckOfCards.append(card)
        }
        
        /// Shuffle deck of cards
        //deckOfCards.shuffle()
        
        /// Create player(s)
        players = [Player()]
        
        /// Start game with 12 cards on screen.
        dealCards(numberOfCards: 12)
    }
    
    struct Card: Identifiable, Hashable where CardContent: Hashable {
        var isMatched = false
        let id: Int
        let features: Features
        let content: CardContent
        
        struct Features: Hashable {
            let numberOfShapes: TriState
            let shape: TriState
            let shading: TriState
            let color: TriState
        }
    }
    
    struct Player {
        var score: Int = 0
    }
}

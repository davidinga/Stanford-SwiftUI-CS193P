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
    var cards: Set<Card> = []
    /// - TODO: isMatch

    mutating func choose() {}
    func dealCards() {}
    func reorgnaizeCards() {}

    init(content: ([(numberOfShapes: TriState, shape: TriState, shading: TriState, color: TriState)]) -> [CardContent]) {
        var featuresForAllCards: [(TriState, TriState, TriState, TriState)] = []
        var a, b, c, d: TriState
        a = .low; b = .low; c = .low; d = .low
        for _ in 0..<3 {
            for _ in 0..<3 {
                for _ in 0..<3 {
                    for _ in 0..<3 {
                        featuresForAllCards.append((a,b,c,d))
                        d.next()
                    }
                    c.next()
                }
                b.next()
            }
            a.next()
        }
        let content = content(featuresForAllCards)
        for index in featuresForAllCards.indices {
            let feature = featuresForAllCards[index]
            let features = Card.Features(numberOfShapes: feature.0, shape: feature.1, shading: feature.2, color: feature.3)
            cards.insert(Card(id: index, features: features, content: content[index]))
        }
        
    }
    
    struct Card: Identifiable, Hashable where CardContent: Hashable {
        var isMatched = false
        var isFaceUp = false
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
}

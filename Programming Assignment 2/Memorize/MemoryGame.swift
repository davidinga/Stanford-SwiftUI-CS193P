//
//  MemoryGame.swift
//  Memorize
//
//  Created by David Inga on 6/15/21.
//

import Foundation

/// This is my `Model`

struct MemoryGame<CardContent: Equatable> {
    
    private(set) var cards: [Card]
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    private var timeOfLastMatchedCard = Date()
    
    private var timeIntervalSinceLastMatchedCard: Int {
        let currentTime = Date()
        let timeInterval = currentTime.timeIntervalSince(timeOfLastMatchedCard)
        return Int(timeInterval)
    }
    
    private(set) var score = 0
    
    private func calculateScoreBonus(_ seconds: Int) -> Int {
        return seconds % 10
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += calculateScoreBonus(timeIntervalSinceLastMatchedCard) + 2
                } else if cards[chosenIndex].alreadySeen {
                    score -= 1
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp = true
            cards[chosenIndex].alreadySeen = true
        }
    }
    
    // Big jump for me. Using a Generic, initializing a variable as the Generic Type, and then building an API
    // that asks for a function that returns the Generic Type. It's super cool!
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var alreadySeen = false
        var content: CardContent
        var id: Int
    }
}

enum MemoryGameError: Error {
    case cardNotFound
}

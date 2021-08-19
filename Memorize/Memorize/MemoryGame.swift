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
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
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
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].alreadySeen = true
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    // Big jump for me. Using a Generic, initializing a variable as the Generic Type, and then building an API
    // that asks for a function that returns the Generic Type. It's super cool!
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        shuffle()
    }
    
    struct Card: Identifiable, Equatable {
        var isFaceUp = false {
            didSet {
                isFaceUp ? startUsingBonusTime() : stopUsingBonusTime()
            }
        }
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        var alreadySeen = false
        let content: CardContent
        let id: Int
        
        static func == (lhs: MemoryGame.Card, rhs: MemoryGame.Card) -> Bool {
            return lhs.isFaceUp == rhs.isFaceUp &&
                lhs.isMatched == rhs.isMatched &&
                lhs.alreadySeen == rhs.alreadySeen &&
                lhs.content == rhs.content &&
                lhs.id == rhs.id
        }
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

private enum MemoryGameError: Error {
    case cardNotFound
}

extension Array {
    var oneAndOnly: Element? {
        count == 1 ? first : nil
    }
}

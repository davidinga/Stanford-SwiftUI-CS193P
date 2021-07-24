//
//  MemoryGameTheme.swift
//  Memorize
//
//  Created by David Inga on 7/23/21.
//

import Foundation

struct MemoryGameTheme<CardContent: Equatable> {
    private(set) var name: String
    private(set) var content: [CardContent] {
        didSet {
            if numberOfPairsOfCards > content.count {
                numberOfPairsOfCards = content.count
            }
        }
    }
    private(set) var numberOfPairsOfCards: Int
    private(set) var color: String
    private(set) var gradient: [String]?
    
    /// If `numberOfPairsOfCards` is zero, it will be set to a random integer.
    init(name: String, content: [CardContent], numberOfPairsOfCards: Int, color: String, gradient: [String]? = nil) {
        self.name = name
        self.content = content.shuffled()
        self.numberOfPairsOfCards = numberOfPairsOfCards == 0 ? Int.random(in: 2...content.count) : numberOfPairsOfCards
        self.color = color
        self.gradient = gradient
    }
    
    init(name: String, content: [CardContent], color: String, gradient: [String]? = nil) {
        self.name = name
        self.content = content.shuffled()
        self.numberOfPairsOfCards = content.count
        self.color = color
    }
}

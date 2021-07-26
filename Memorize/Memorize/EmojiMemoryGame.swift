//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by David Inga on 6/15/21.
//

import SwiftUI

/// This is my `ViewModel`
/// ViewModel enables the entire Reactive Architecture. ObservableObject.
/// Swift can detect changes in Structs. @Published is assigned to a Struct.
class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static var themes = [
        ( name:                  "Cars",
          emojis:                ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑",
                                  "🛻", "🚚", "🚛", "🚜", "🛺", "🚔", "🚍", "🚘"],
          numberOfPairsOfCards:  8,
          color:                 "red",
          gradient:              nil ),
        
        ( name:                  "Animals",
          emojis:                ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼",
                                  "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵"],
          numberOfPairsOfCards:  8,
          color:                 "green",
          gradient:              nil ),
        
        ( name:                  "Sports",
          emojis:                ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉",
                                  "🥏", "🎱", "🪀", "🏓", "🏸", "🏒", "🥍", "⛳️"],
          numberOfPairsOfCards:  8,
          color:                 "blue",
          gradient:              ["blue", "purple", "black"] ),
        
        ( name:                  "Fruit",
          emojis:                ["🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓",
                                  "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝"],
          numberOfPairsOfCards:  8,
          color:                 "orange",
          gradient:              nil ),
        
        ( name:                  "Electronics",
          emojis:                ["⌚️", "📱", "💻", "⌨️", "🖥", "🖱", "🖨", "🖲",
                                  "🕹", "📞", "📟", "📻", "🎙", "🎚", "📹", "🎛"],
          numberOfPairsOfCards:  8,
          color:                 "gray",
          gradient:              ["gray", "black"] ),
    ]
    
    private static var randomTheme: (name: String, emojis: [String], numberOfPairsOfCards: Int, color: String, gradient: [String]?) { themes.randomElement()! }
    
    private static func translateToColor(from string: String) -> Color {
        switch string {
        case "red":
            return .red
        case "green":
            return .green
        case "blue":
            return .blue
        case "yellow":
            return .yellow
        case "orange":
            return .orange
        case "gray":
            return .gray
        case "purple":
            return .purple
        default:
            return .black
        }
    }

    func createMemoryGame() {
        let randomTheme = EmojiMemoryGame.randomTheme
        themeModel = MemoryGameTheme<String>(name: randomTheme.name,
                                             content: randomTheme.emojis,
                                             numberOfPairsOfCards: randomTheme.numberOfPairsOfCards,
                                             color: randomTheme.color,
                                             gradient: randomTheme.gradient)
        gameModel = MemoryGame<String>(numberOfPairsOfCards: themeModel.numberOfPairsOfCards) { pairIndex in
            themeModel.content[pairIndex]
        }
    }
    
    init() {
        createMemoryGame()
    }
    
    /// ViewModel is the GateKeeper of the Model to the View
    @Published private var gameModel: MemoryGame<String>!
    
    @Published private var themeModel: MemoryGameTheme<String>!
    
    /// ViewModel is the Interpretor of the Model to the View
    var cards: [Card] {
        gameModel.cards
    }
    
    var score: Int {
        gameModel.score
    }
    
    var theme: MemoryGameTheme<String> {
        themeModel
    }
    
    var color: Color {
        EmojiMemoryGame.translateToColor(from: theme.color)
    }
    
    var gradient: LinearGradient? {
        if let gradient = theme.gradient {
            let colors = gradient.map { EmojiMemoryGame.translateToColor(from: $0) }
            return LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        return nil
    }
    
    // MARK: - Intent(s)
    /// Expresses the User Intent to the Model
    
    func choose(_ card: Card) {
        gameModel.choose(card)
    }
}

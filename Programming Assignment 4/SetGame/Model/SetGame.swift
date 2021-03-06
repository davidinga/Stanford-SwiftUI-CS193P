//
//  SetGame.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import Foundation

struct SetGame<CardContent> where CardContent: Hashable {
    let numberOfCardsToSelect = 3
    let numberOfCardsToStartWith = 12
    var deckOfCards: [Card] = []
    var cardsInPlay: [Card] = []
    var selectedCardIDs: [UUID] = []
    var players: [Player]
    var activePlayer: Player

    var threeCardsSelected: Bool {
        selectedCardIDs.count == numberOfCardsToSelect
    }

    /// Returns true if the selected cards create a set.
    private var isMatch: Bool {
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

        guard isAllTheSameOrAllDifferent(numberOfShapes) else { return false }
        guard isAllTheSameOrAllDifferent(shape) else { return false }
        guard isAllTheSameOrAllDifferent(shading) else { return false }
        guard isAllTheSameOrAllDifferent(color) else { return false }

        return true
    }

    private func isAllTheSameOrAllDifferent(_ elements: [TriState]) -> Bool {
        let set = Set(elements)
        return set.count == 1 || set.count == 3
    }

    mutating func flip(card: Card) {
        if let index = cardsInPlay.firstIndex(where: {$0.id == card.id}) {
            cardsInPlay[index].isFaceUp.toggle()
        }
    }

    /// Selects a card from the `cardsInPlay`.
    mutating func choose(_ card: Card) {
        /// If three cards were selected and not matched, clear selected cards.
        if threeCardsSelected { selectedCardIDs = [] }
        /// Deal cards if a set was found on the previous turn.
        dealCards()
        /// Enable deselection if one or two cards are currently selected.
        if let index = selectedCardIDs.firstIndex(of: card.id), !threeCardsSelected {
            selectedCardIDs.remove(at: index)
        /// Select card if there are less than three cards selected.
        } else if !card.isMatched && selectedCardIDs.count < numberOfCardsToSelect {
            selectedCardIDs.append(card.id)
        }
        /// If three cards are selcted and there is a match, mark the cards as matched, and add to the score.
        if threeCardsSelected, isMatch {
                for id in selectedCardIDs {
                    let index = cardsInPlay.firstIndex(where: {$0.id == id})!
                    cardsInPlay[index].isMatched = true
                }
                activePlayer.score += 1
        }
    }

    /// Takes a specified`numberOfCards` out of `deckOfCards` and adds them to the `cardsInPlay`.
    mutating func dealCards(isNewGame: Bool = false, isUserRequest: Bool = false) {
        /// Remove matched cards instead of replacing them when the `deckOfCards` is empty.
        guard !deckOfCards.isEmpty else {
            cardsInPlay.removeAll(where: {$0.isMatched == true})
            return
        }

        var cardsAlreadyDelt = false
        /// Replace matched cards with new cards from the `deckOfCards`.
        cardsInPlay.indices.forEach { index in
            if cardsInPlay[index].isMatched {
                /// Move cards into active players deck.
                activePlayer.cards += [cardsInPlay[index]]
                /// Deal new card.
                cardsInPlay[index] = deckOfCards.first!
                deckOfCards.removeFirst()
                cardsAlreadyDelt = true
            }
        }
        /// Deal more cards if requested by the user and not already replaced by matching cards.
        if isUserRequest && !cardsAlreadyDelt {
            cardsInPlay.append(contentsOf: deckOfCards[0..<3])
            deckOfCards.removeSubrange(0..<3)
        }
        /// Deal a set amount of cards at the beginning of the game.
        if isNewGame {
            cardsInPlay.append(contentsOf: deckOfCards[0..<numberOfCardsToStartWith])
            deckOfCards.removeSubrange(0..<numberOfCardsToStartWith)
        }
    }

    /// Finds a matching set and selects two of the three cards; returns true if a set was found.
    mutating func findSetOfMatchingCards() -> Bool {
        /// Deal new cards if set was found on previous turn.
        dealCards()
        /// Shuffle deck to find new solutions each time.
        let shuffledCards = cardsInPlay.shuffled()
        /// Finds a set in O(n^3) time.
        for firstCardIndex in shuffledCards.indices {
            for secondCardIndex in shuffledCards.indices {
                for thirdCardIndex in shuffledCards.indices {
                    if Set([shuffledCards[firstCardIndex].id, shuffledCards[secondCardIndex].id, shuffledCards[thirdCardIndex].id]).count == 3 {

                        let first = shuffledCards[firstCardIndex].features
                        let second = shuffledCards[secondCardIndex].features
                        let third = shuffledCards[thirdCardIndex].features

                        if isAllTheSameOrAllDifferent([first.numberOfShapes, second.numberOfShapes, third.numberOfShapes]),
                           isAllTheSameOrAllDifferent([first.shape, second.shape, third.shape]),
                           isAllTheSameOrAllDifferent([first.shading, second.shading, third.shading]),
                           isAllTheSameOrAllDifferent([first.color, second.color, third.color]) {

                            let shuffledCardIndices = [firstCardIndex, secondCardIndex, thirdCardIndex].shuffled()
                            let firstCard = shuffledCards[shuffledCardIndices[0]]
                            let secondCard = shuffledCards[shuffledCardIndices[1]]

                            selectedCardIDs = [firstCard.id, secondCard.id]
                            return true
                        }
                    }
                }
            }
        }
        return false
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
            let featuresForCard = Card.Features(
                numberOfShapes: featuresForDeckOfCards[index].0,
                shape:          featuresForDeckOfCards[index].1,
                shading:        featuresForDeckOfCards[index].2,
                color:          featuresForDeckOfCards[index].3
            )
            let card = Card(id: UUID(), features: featuresForCard, content: content[index])
            deckOfCards.append(card)
        }

        /// Shuffle deck of cards
        deckOfCards.shuffle()

        /// Create player(s)
        players = [Player()]

        /// First player
        activePlayer = players.first!
    }

    struct Card: Identifiable, Hashable where CardContent: Hashable {
        var isMatched = false
        var isFaceUp = false
        let id: UUID
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
        var cards: [Card] = []
    }
}

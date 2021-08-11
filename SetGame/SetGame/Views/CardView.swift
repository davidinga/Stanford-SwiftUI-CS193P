//
//  CardView.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var game: ClassicSetGame
    let card: SetGame<String>.Card
    let uniqueShape: String
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 10.0)
        ZStack {
            if game.isSelected(card) && !card.isMatched && !game.threeCardsSelected {
                shape.foregroundColor(.yellow)
            } else if game.isSelected(card) && !card.isMatched && game.threeCardsSelected {
                shape.foregroundColor(.red)
            } else if card.isMatched {
                shape.foregroundColor(.green)
            } else {
                shape.foregroundColor(.blue)
            }
            Text(uniqueShape)
        }
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ClassicSetGame()
        let card = game.cards[0]
        CardView(game: game, card: card, uniqueShape: "Description")
    }
}

//
//  CardView.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var game: ClassicSetGame
    let card: SetGame<ClassicSetGameFeatures>.Card
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                /// Card Shape with various selection states.
                cardShape
                /// A unique set of diamonds, squiggles, or ovals.
                ShapeView(features: card.content)
                    .frame(width: geometry.size.width * 2/3, height: geometry.size.height * 2/3, alignment: .center)
            }
        }
    }
    
    @ViewBuilder
    var cardShape: some View {
        let cardShape = RoundedRectangle(cornerRadius: 10.0)
        
        cardShape.fill(Color.white)
        if game.isSelected(card) && !card.isMatched && !game.threeCardsSelected {
            cardShape.stroke(lineWidth: 3).fill(Color.blue)
        } else if game.isSelected(card) && !card.isMatched && game.threeCardsSelected {
            cardShape.stroke(lineWidth: 3).fill(Color.red)
        } else if card.isMatched {
            cardShape.stroke(lineWidth: 3).fill(Color.green)
        } else {
            cardShape.stroke(lineWidth: 1).fill(Color.black).opacity(0.5)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ClassicSetGame()
        let card = game.cards[0]
        CardView(game: game, card: card)
    }
}

//
//  ClassicSetGameView.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import SwiftUI

struct ClassicSetGameView: View {
    @ObservedObject var game: ClassicSetGame
    var body: some View {
        VStack {
            HStack {
                Button(action: game.createNewGame) {
                    Text("New Game")
                }
                Spacer()
                Text("Score: \(game.score)")
            }.padding(5)
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                CardView(game: game, card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
            Button(action: game.dealCards) {
                Text("Deal 3 More Cards")
            }
        }.padding(5)
    }
}

struct ClassicSetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ClassicSetGame()
        ClassicSetGameView(game: game)
    }
}

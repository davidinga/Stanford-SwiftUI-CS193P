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
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            CardView(uniqueShape: card.content)
                .padding(4)
        }
    }
}

struct ClassicSetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ClassicSetGame()
        ClassicSetGameView(game: game)
    }
}

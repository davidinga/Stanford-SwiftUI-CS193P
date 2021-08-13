//
//  ClassicSetGameView.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import SwiftUI

struct ClassicSetGameView: View {
    @ObservedObject var game: ClassicSetGame
    @State private var showingHintAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: game.createNewGame) {
                    Text("New Game")
                }
                Spacer()
                Text("Score: \(game.score)")
            }.padding(.horizontal)
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                CardView(game: game, card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
            HStack {
                Button(action: game.dealCards) {
                    Text("Deal 3 More Cards")
                }
                Spacer()
                Button("Hint") {
                    showingHintAlert = !game.requestHint()
                }.alert(isPresented: $showingHintAlert) {
                    Alert(
                        title: Text("Hint"),
                        message: Text("No matching sets left. 🧐"),
                        primaryButton: .default(
                                        Text("Deal 3 More Cards"),
                                        action: game.dealCards
                        ),
                        secondaryButton: .default(Text("OK"))
                    )
                }
            }.padding(.horizontal)
            
        }.padding()
    }
}

struct ClassicSetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ClassicSetGame()
        ClassicSetGameView(game: game)
    }
}

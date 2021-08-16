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
    @State private var showingDealerAlert = false
    
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
                deal3MoreCardsButton
                Spacer()
                requestHintButton
                
            }.padding(.horizontal)
            
        }.padding()
    }
    
    @ViewBuilder
    var requestHintButton: some View {
        Button("Hint") {
            showingHintAlert = !game.requestHint()
        }.alert(isPresented: $showingHintAlert) {
            if game.deckIsEmpty {
                 return Alert(
                    title: Text("Hint"),
                    message: Text("You found all sets. Woohoo! 🙌"),
                    primaryButton: .default(
                                    Text("New Game"),
                                    action: game.createNewGame
                    ),
                    secondaryButton: .default(Text("OK"))
                )
            } else {
                return Alert(
                    title: Text("Hint"),
                    message: Text("No matching sets. 🧐"),
                    primaryButton: .default(
                                    Text("Deal 3 More Cards"),
                                    action: game.dealCards
                    ),
                    secondaryButton: .default(Text("OK"))
                )
            }
        }
    }
    
    @ViewBuilder
    var deal3MoreCardsButton: some View {
        Button("Deal 3 More Cards") {
            game.dealCards()
            showingDealerAlert = game.deckIsEmpty
        }.alert(isPresented: $showingDealerAlert) {
            Alert(
                title: Text("Dealer"),
                message: Text("All cards have been dealt. 🤠")
            )
        }
    }
}

struct ClassicSetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ClassicSetGame()
        ClassicSetGameView(game: game)
    }
}

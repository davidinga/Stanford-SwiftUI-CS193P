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
    @Namespace var dealingNamespace

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Button(action: withAnimation { game.createNewGame }) {
                            Text("New Game")
                        }
                        Spacer()
                        Text("Score: \(game.score)")
                    }.padding(.horizontal)
                    cardsInPlay
                        .onAppear {
                            withAnimation(.easeIn.delay(0.2)) {
                                game.dealTwelveCards()
                            }
                        }
                    HStack {
                        deckOfCards
                        Spacer()
                        discardPile
                    }.frame(height: geometry.size.height*(1/7))
                    HStack {
                        requestHintButton

                    }.padding(.horizontal)

                }
                .padding()
            }
            .background(
                Image("wood")
                    .resizable(resizingMode: .tile)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }

    @State private var shouldAnimate = false

    var cardsInPlay: some View {
        AspectVGrid(items: game.cardsInPlay, aspectRatio: 2/3) { card in
            CardView(card: card, isSelected: game.isSelected(card), isMatch: game.isMatch(card), isMismatch: game.isMismatch(card))
                .padding(4)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .scaleEffect(shouldAnimate && game.isMatch(card) ? 1.1 : 1)
                .rotation3DEffect(Angle(degrees: shouldAnimate && game.isMismatch(card) ? 5 : 0), axis: (x: 0, y: 0, z: 1))
                .onTapGesture {
                    let animation = Animation.default.repeatCount(1, autoreverses: true)
                    withAnimation(animation) {
                        game.choose(card)
                        shouldAnimate.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(animation) {
                            shouldAnimate.toggle()
                        }
                    }
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 1.3).delay(0.5)) {
                        game.flip(card)
                    }
                }
        }
    }

    var deckOfCards: some View {
            ZStack {
                ForEach(game.deckOfCards) { card in
                    CardView(card: card, isFaceUp: card.isFaceUp)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .padding(4)
                        .onTapGesture {
                            withAnimation {
                                game.dealCards()
                            }
                        }
                }
            }
            .aspectRatio(2/3, contentMode: .fit)
    }

    var discardPile: some View {
        ZStack {
            ForEach(game.discardPile) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
    }

    @ViewBuilder
    var requestHintButton: some View {
        Button("Hint") {
            withAnimation {
                showingHintAlert = !game.requestHint()
            }
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
            withAnimation {
                game.dealCards()
            }
            showingDealerAlert = game.deckIsEmpty
        }.alert(isPresented: $showingDealerAlert) {
            Alert(
                title: Text("Dealer"),
                message: Text("All cards have been dealt. 🤠")
            )
        }
    }

    struct CardConstants {
        static let undealtCardHeight: CGFloat = 200
    }
}

struct CardView: View {
    var card: ClassicSetGame.Card
    var isFaceUp = true
    var isSelected: Bool = false
    var isMatch: Bool = false
    var isMismatch: Bool = false

    var body: some View {
        GeometryReader { _ in
            ShapeView(features: card.content)
                .aspectRatio(2/3, contentMode: .fit)
                .scaleEffect(CGSize(width: 0.75, height: 0.75))
                .cardify(card: card, isSelected: isSelected, isMatch: isMatch, isMismatch: isMismatch)
        }
    }
}

struct ClassicSetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ClassicSetGame()
        ClassicSetGameView(game: game)
    }
}

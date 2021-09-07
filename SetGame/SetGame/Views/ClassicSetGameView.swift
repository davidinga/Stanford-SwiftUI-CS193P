//
//  ClassicSetGameView.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import SwiftUI

struct ClassicSetGameView: View {
    @ObservedObject var game: ClassicSetGame
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
                    }.frame(height: geometry.size.height * ClassicSetGameConstants.undealtCardSectionRatio)
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
        AspectVGrid(items: game.cardsInPlay, aspectRatio: ClassicSetGameConstants.cardAspectRatio) { card in
            CardView(card: card, isSelected: game.isSelected(card), isMatch: game.isMatch(card), isMismatch: game.isMismatch(card))
                .padding(4)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .scaleEffect(shouldAnimate && game.isMatch(card) ? ClassicSetGameConstants.scaleOnMatch : 1)
                .rotation3DEffect(Angle(degrees: shouldAnimate && game.isMismatch(card) ? ClassicSetGameConstants.rotationOnMismatch : 0), axis: (x: 0, y: 0, z: 1))
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
                        .shadow(color: Color.black.opacity(0.1), radius: 0.5)
                        .onTapGesture {
                            withAnimation {
                                game.dealCards()
                            }
                        }
                }
            }
            .aspectRatio(ClassicSetGameConstants.cardAspectRatio, contentMode: .fit)
    }
    
    static var messyCardAngles: [UUID : Double] = [:]
    
    func fetchMessyCardAngle(card: ClassicSetGame.Card) -> Double {
        guard let angle = ClassicSetGameView.messyCardAngles[card.id] else {
            let randomAngle = Double.random(in: -5...5)
            ClassicSetGameView.messyCardAngles[card.id] = randomAngle
            return randomAngle
        }
        
        return angle
    }

    var discardPile: some View {
        ZStack {
            ForEach(game.discardPile) { card in
                let angle = fetchMessyCardAngle(card: card)
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .rotationEffect(Angle(degrees: angle))
                    .shadow(color: Color.black.opacity(0.1), radius: 4)
                    .padding(4)
            }
        }
        .aspectRatio(ClassicSetGameConstants.cardAspectRatio, contentMode: .fit)
    }

    @State private var showingHintAlert = false
    
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
                        action: withAnimation { game.createNewGame }
                    ),
                    secondaryButton: .default(Text("OK"))
                )
            } else {
                return Alert(
                    title: Text("Hint"),
                    message: Text("No matching sets. 🧐"),
                    primaryButton: .default(
                        Text("Deal 3 More Cards"),
                        action: withAnimation { game.dealCards }
                    ),
                    secondaryButton: .default(Text("OK"))
                )
            }
        }
    }

    @State private var showingDealerAlert = false
    
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
                .aspectRatio(ClassicSetGameConstants.cardAspectRatio, contentMode: .fit)
                .scaleEffect(CGSize(width: ClassicSetGameConstants.shapeScaleEffectRatio, height: ClassicSetGameConstants.shapeScaleEffectRatio))
                .cardify(card: card, isSelected: isSelected, isMatch: isMatch, isMismatch: isMismatch)
        }
    }
}

struct ClassicSetGameConstants {
    static let cardAspectRatio: CGFloat = 2/3
    static let shapeScaleEffectRatio = 0.75
    static let rotationOnMismatch = 5.0
    static let scaleOnMatch: CGFloat = 1.1
    static let undealtCardSectionRatio: CGFloat = 1/7
}

struct ClassicSetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ClassicSetGame()
        ClassicSetGameView(game: game)
    }
}

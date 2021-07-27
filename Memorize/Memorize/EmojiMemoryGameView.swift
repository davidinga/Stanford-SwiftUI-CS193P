//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by David Inga on 6/9/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    /// Because viewModel is marked as an @ObservedObject, it will get it's Body rebuilt whenever there is a change in the Model.
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
            VStack {
                HStack {
                    Button("New Game", action: { game.createMemoryGame() })
                    Spacer()
                    Text("Score: \(game.score)")
                }.padding([.leading, .bottom, .trailing])
                
                Text("Memorize \(game.theme.name)!")
                    .font(.largeTitle)
                
                AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                    CardView(card, game.color, game.gradient)
                        .padding(4)
                        /// Intent Functions express the User's Intent to the ViewModel
                        .onTapGesture {
                            game.choose(card)
                        }
                        .animation(.easeInOut)
                }
            }.padding(10)
    }
}

struct CardView: View {
    private let card: EmojiMemoryGame.Card
    private let color: Color
    private let gradient: LinearGradient?
    
    init(_ card: EmojiMemoryGame.Card, _ color: Color, _ gradient: LinearGradient?) {
        self.card = card
        self.color = color
        self.gradient = gradient
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90)).padding(5).opacity(0.2).animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                    if let gradient = gradient {
                        shape.strokeBorder(gradient)
                    } else {
                        shape.strokeBorder().foregroundColor(color)
                    }
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    if let gradient = gradient {
                        shape.fill(gradient)
                    } else {
                        shape.foregroundColor(color)
                    }
                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let fontScale: CGFloat = 0.7
    }
}


















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        
        @ViewBuilder
        var gameView: some View {
            EmojiMemoryGameView(game: game)
                 .preferredColorScheme(.dark)
            EmojiMemoryGameView(game: game)
                 .preferredColorScheme(.light)
        }
        
       return gameView
    }
}

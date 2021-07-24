//
//  ContentView.swift
//  Memorize
//
//  Created by David Inga on 6/9/21.
//

import SwiftUI

struct ContentView: View {
    
    /// Because viewModel is marked as an @ObservedObject, it will get it's Body rebuilt whenever there is a change in the Model.
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button("New Game", action: { viewModel.createMemoryGame() })
                    Spacer()
                    Text("Score: \(viewModel.score)")
                }.padding([.leading, .bottom, .trailing])
                
                Text("Memorize \(viewModel.theme.name)!")
                    .font(.largeTitle)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 78))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card, color: viewModel.color, gradient: viewModel.gradient)
                            .aspectRatio(2/3, contentMode: .fit)
                            /// Intent Functions express the User's Intent to the ViewModel
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
        }
        .padding(.all)
    }
    
    func widthThatFitsBest(for numberOfCards: Int) -> CGFloat {
        return CGFloat((16.0 / Double(numberOfCards)) * 50.0)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    let color: Color
    let gradient: LinearGradient?
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                if let gradient = gradient {
                    shape.strokeBorder(gradient)
                } else {
                    shape.strokeBorder().foregroundColor(color)
                }
                Text(card.content)
                    .font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
                if let gradient = gradient {
                    shape.fill(gradient)
                } else {
                    shape.foregroundColor(color)
                }
                
            }
        }
    }
}





















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        
        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
        ContentView(viewModel: game)
            .preferredColorScheme(.light)

    }
}

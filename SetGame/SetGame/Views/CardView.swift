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
        let cardShape = RoundedRectangle(cornerRadius: 10.0)
        GeometryReader { geometry in
            ZStack {
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
                
                VStack {
                    Section {
                        switch card.content.shading {
                        case .solid:
                            switch card.content.color {
                            case .red:
                                VStack {
                                    ForEach(0..<card.content.numberOfShapes.rawValue) { _ in
                                        switch card.content.shape {
                                        case .diamond:
                                            Diamond().fill(Color.red)
                                        case .squiggle:
                                            Squiggle().fill(Color.red)
                                        case .oval:
                                            Oval().fill(Color.red)
                                        }
                                    }
                                }
                            case .green:
                                VStack {
                                    ForEach(0..<card.content.numberOfShapes.rawValue) { _ in
                                        switch card.content.shape {
                                        case .diamond:
                                            Diamond().fill(Color.green)
                                        case .squiggle:
                                            Squiggle().fill(Color.green)
                                        case .oval:
                                            Oval().fill(Color.green)
                                        }
                                    }
                                }
                            case .purple:
                                VStack {
                                    ForEach(0..<card.content.numberOfShapes.rawValue) { _ in
                                        switch card.content.shape {
                                        case .diamond:
                                            Diamond().fill(Color.purple)
                                        case .squiggle:
                                            Squiggle().fill(Color.purple)
                                        case .oval:
                                            Oval().fill(Color.purple)
                                        }
                                    }
                                }
                            }
                        case .stripped:
                            switch card.content.color {
                            case .red:
                                VStack {
                                    ForEach(0..<card.content.numberOfShapes.rawValue) { _ in
                                        switch card.content.shape {
                                        case .diamond:
                                            ZStack {
                                                Diamond().strokeBorder(Color.red)
                                                Diamond().fill(Color.red).opacity(0.5)
                                            }
                                        case .squiggle:
                                            ZStack {
                                                Squiggle().strokeBorder(Color.red)
                                                Squiggle().fill(Color.red).opacity(0.5)
                                            }
                                        case .oval:
                                            ZStack {
                                                Oval().strokeBorder(Color.red)
                                                Oval().fill(Color.red).opacity(0.5)
                                            }
                                        }
                                    }
                                }
                            case .green:
                                VStack {
                                    ForEach(0..<card.content.numberOfShapes.rawValue) { _ in
                                        switch card.content.shape {
                                        case .diamond:
                                            ZStack {
                                                Diamond().strokeBorder(Color.green)
                                                Diamond().fill(Color.green).opacity(0.5)
                                            }
                                        case .squiggle:
                                            ZStack {
                                                Squiggle().strokeBorder(Color.green)
                                                Squiggle().fill(Color.green).opacity(0.5)
                                            }
                                        case .oval:
                                            ZStack {
                                                Oval().strokeBorder(Color.green)
                                                Oval().fill(Color.green).opacity(0.5)
                                            }
                                        }
                                    }
                                }
                            case .purple:
                                VStack {
                                    ForEach(0..<card.content.numberOfShapes.rawValue) { _ in
                                        switch card.content.shape {
                                        case .diamond:
                                            ZStack {
                                                Diamond().strokeBorder(Color.purple)
                                                Diamond().fill(Color.purple).opacity(0.5)
                                            }
                                        case .squiggle:
                                            ZStack {
                                                Squiggle().strokeBorder(Color.purple)
                                                Squiggle().fill(Color.purple).opacity(0.5)
                                            }
                                        case .oval:
                                            ZStack {
                                                Oval().strokeBorder(Color.purple)
                                                Oval().fill(Color.purple).opacity(0.5)
                                            }
                                        }
                                    }
                                }
                            }
                        case .open:
                            switch card.content.color {
                            case .red:
                                VStack {
                                    ForEach(0..<card.content.numberOfShapes.rawValue) { _ in
                                        switch card.content.shape {
                                        case .diamond:
                                            Diamond().strokeBorder(Color.red)
                                        case .squiggle:
                                            Squiggle().strokeBorder(Color.red)
                                        case .oval:
                                            Oval().strokeBorder(Color.red)
                                        }
                                    }
                                }
                            case .green:
                                VStack {
                                    ForEach(0..<card.content.numberOfShapes.rawValue) { _ in
                                        switch card.content.shape {
                                        case .diamond:
                                            Diamond().strokeBorder(Color.green)
                                        case .squiggle:
                                            Squiggle().strokeBorder(Color.green)
                                        case .oval:
                                            Oval().strokeBorder(Color.green)
                                        }
                                    }
                                }
                            case .purple:
                                VStack {
                                    ForEach(0..<card.content.numberOfShapes.rawValue) { _ in
                                        switch card.content.shape {
                                        case .diamond:
                                            Diamond().strokeBorder(Color.purple)
                                        case .squiggle:
                                            Squiggle().strokeBorder(Color.purple)
                                        case .oval:
                                            Oval().strokeBorder(Color.purple)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 2/3, height: geometry.size.height * 2/3, alignment: .center)
                }
            }
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

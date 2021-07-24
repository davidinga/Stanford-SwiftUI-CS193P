//
//  ContentView.swift
//  Memorize
//
//  Created by David Inga on 6/9/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentTheme = Theme.randomTheme!
    
    var body: some View {
        VStack {
            ScrollView {
                Text("Memorize!")
                    .font(.largeTitle)
                let numberOfCards = Int.random(in: 4..<16)
                let width = widthThatFitsBest(for: numberOfCards)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: width))]) {
                    let emojis = currentTheme.emojis[0...numberOfCards].shuffled()
        
                    ForEach(emojis, id: \.self) { emoji in
                        CardView(content: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            Spacer()
            HStack {
                buildThemeButton(for: Theme.carTheme)
                Spacer()
                buildThemeButton(for: Theme.smileyTheme)
                Spacer()
                buildThemeButton(for: Theme.animalTheme)
            }
            .font(.largeTitle)
            .padding(.horizontal)
            
        }
        .padding(.horizontal)
    }
    
    func buildThemeButton(for theme: Theme) -> some View {
        var themeButton: some View {
            return Button {
                currentTheme = theme
            } label: {
                VStack {
                    Image(systemName: theme.label)
                    Text(theme.name)
                        .font(.footnote)
                }
            }
        }
        return themeButton
    }
    
    func widthThatFitsBest(for numberOfCards: Int) -> CGFloat {
        return CGFloat((16.0 / Double(numberOfCards)) * 50.0)
    }
}

struct Theme {
    let name: String
    let label: String
    let emojis: [String]
    
    static let carTheme = Theme(
        name:  "Cars",
        label: "car.2.fill",
        emojis: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓",
                 "🚑", "🛻", "🚚", "🚛", "🚜", "🛺", "🚔",
                 "🚍", "🚘"]
    )
    
    static let smileyTheme = Theme(
        name:  "Smileys",
        label: "face.smiling.fill",
        emojis: ["😀", "😃", "😄", "😁", "😆", "😅", "😂",
                 "🤣", "🥲", "☺️", "😊", "😇", "🙂", "🙃",
                 "😉", "🥰"]
    )
    
    static let animalTheme = Theme(
        name:  "Animals",
        label: "hare.fill",
        emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻",
                 "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷",
                 "🐸", "🙈"]
    )
    static var randomTheme = [carTheme, smileyTheme, animalTheme].randomElement()
}

struct CardView: View {
    var content: String
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3).foregroundColor(.red)
                Text(content)
                    .font(.largeTitle)
            } else {
                shape.fill()
                shape.foregroundColor(.red)
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}





















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        ContentView()
            .preferredColorScheme(.light)

    }
}

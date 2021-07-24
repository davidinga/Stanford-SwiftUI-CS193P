//
//  MemorizeApp.swift
//  Memorize
//
//  Created by David Inga on 6/9/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}

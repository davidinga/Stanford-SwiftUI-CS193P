//
//  SetGameApp.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import SwiftUI

@main
struct SetGameApp: App {
    private let game = ClassicSetGame()
    var body: some Scene {
        WindowGroup {
            ClassicSetGameView(game: game)
        }
    }
}

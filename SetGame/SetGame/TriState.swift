//
//  TriState.swift
//  SetGame
//
//  Created by David Inga on 8/9/21.
//

import Foundation

enum TriState {
    case low, mid, high

    mutating func next() {
        switch self {
        case .low:
            self = .mid
        case .mid:
            self = .high
        case .high:
            self = .low
        }
    }
}

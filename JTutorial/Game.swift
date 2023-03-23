//
//  Game.swift
//  JTutorial
//
//  Created by Tyler Gee on 3/20/23.
//

import Foundation

class Game: ObservableObject {
    @Published private(set) var grid: Grid
    @Published private(set) var coins: Int
    @Published private(set) var state: State
    
    func flipTileAt(row: Int, col: Int) {
        guard let flippedValue = grid.flipTileAt(row: row, col: col) else { return }
        
        if flippedValue == .voltorb {
            state = .lost
        } else {
            if coins == 0 {
                coins += flippedValue.intValue
            } else {
                coins *= flippedValue.intValue
            }
            
            if coins == grid.maxScore {
                state = .won
            }
        }
        
        print("maxScore: \(grid.maxScore), currScore: \(coins)")
    }
    
    enum State {
        case ongoing, won, lost
    }
    
    init() {
        grid = Grid()
        coins = 0
        state = .ongoing
    }
    
    func reset() {
        grid = Grid()
        coins = 0
        state = .ongoing
    }
}

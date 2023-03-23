//
//  Tile.swift
//  JTutorial
//
//  Created by Tyler Gee on 3/18/23.
//

import Foundation

struct Tile {
    
    var state: State
    var value: Value
    
    mutating func flip() {
        state = state.opposite
    }
    
    // Returns a random, unflipped tile
    static func random() -> Tile {
        return Tile(state: .notFlipped, value: Tile.Value.random())
    }
    
    enum State {
        case flipped
        case notFlipped
        
        var opposite: State {
            switch self {
            case .flipped:
                return .notFlipped
            case .notFlipped:
                return .flipped
            }
        }
    }
    
    enum Value: Int {
        case voltorb, one, two, three
        
        // THIS is necessary for calculating the total points in a row/column
        var intValue: Int {
            switch self {
            case .voltorb:
                return 0
            case .one:
                return 1
            case .two:
                return 2
            case .three:
                return 3
            }
        }
        
        // Represents how much this tile scales the max score by
        var scalarValue: Int {
            self == .voltorb ? 1 : intValue
        }
        
        // Returns a random value
        static func random() -> Value {
            return Value(rawValue: Int.random(in: 0..<4)) ?? .voltorb
        }
    }
}



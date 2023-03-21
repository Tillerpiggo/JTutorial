//
//  GridLabel.swift
//  JTutorial
//
//  Created by Tyler Gee on 3/20/23.
//

import Foundation

struct GridLabel {
    var voltorbCount: Int
    var totalValue: Int
    
    init(tiles: [Tile]) {
        voltorbCount = tiles.reduce(0) { $0 + ($1.value == .voltorb ? 1 : 0) }
        totalValue = tiles.reduce(0) { $0 + $1.value.intValue }
    }
}

//
//  Grid.swift
//  JTutorial
//
//  Created by Tyler Gee on 3/18/23.
//

import Foundation

struct Grid {
    
    private var tiles: [[Tile]]
    
    let rowCount: Int
    let colCount: Int
    
    let rowLabels: [GridLabel]
    let colLabels: [GridLabel]
    let maxScore: Int
    
    // Instantiates a 5x5 Grid with notFlipped tiles
    init() {
        self.rowCount = 5
        self.colCount = 5
        
        // Initialize the grid to be random
        tiles = [[Tile]]()
        for _ in 0..<rowCount {
            // Create a random row and add it to tiles
            var randomRow = [Tile]()
            for _ in 0..<colCount {
                randomRow.append(Tile.random())
            }
            
            tiles.append(randomRow)
        }
        
        // Generate accurate labels for the grid
        var rowLabels = [GridLabel]()
        for row in tiles {
            rowLabels.append(GridLabel(tiles: row))
        }
        
        var colLabels = [GridLabel]()
        for i in 0..<colCount {
            let column = tiles.map { $0[i] }
            colLabels.append(GridLabel(tiles: column))
        }
        
        self.rowLabels = rowLabels
        self.colLabels = colLabels
        
        // Calculate the max score for the grid
        maxScore = tiles.reduce(1) { product, row in
            product * row.reduce(1) { $0 * $1.value.scalarValue }
        }
    }
    
    // Flips the tile at the given position
    mutating func flipTileAt(row: Int, col: Int) -> Tile.Value? {
        guard tiles[row][col].state == .notFlipped else {
            return nil
        }
        
        tiles[row][col].flip()
        return tiles[row][col].value
    }
    
    // Flips all tiles in the grid that aren't already flipped
    mutating func flipAllTiles() {
        for row in 0..<rowCount {
            for col in 0..<colCount {
                _ = flipTileAt(row: row, col: col)
            }
        }
    }
    
    subscript(index: Int) -> [Tile] {
        get {
            return tiles[index]
        }
    }
}

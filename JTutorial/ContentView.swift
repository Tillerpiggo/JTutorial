//
//  ContentView.swift
//  JTutorial
//
//  Created by Tyler Gee on 3/18/23.
//

import SwiftUI
import SpriteKit

// A simple game scene with falling boxes
//class GameScene: SKScene {
//
//    var grid: Grid
//
//    init(grid: Grid) {
//        self.grid = grid
//        super.init()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        self.grid = Grid()
//        super.init(coder: aDecoder)
//    }
//
//    override func didMove(to view: SKView) {
//        //physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
//        for row in 0..<grid.tiles.count {
//            for col in 0..<grid.tiles.first!.count {
//                let tile = SKSpriteNode(color: .red, size: CGSize(width: 20, height: 20))
//                tile.position = CGPoint(x: CGFloat(row) * 30 + 100, y: CGFloat(col) * 30 + 100)
//                tile.color = grid.tiles[row][col].state == .flipped ? .red : .blue
//                addChild(tile)
//            }
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        let touchedNode = self.atPoint(location)
//
//        let row = Int((touchedNode.position.x - 100) / 30)
//        let col = Int((touchedNode.position.y - 100) / 30)
//
//        grid.flipTileAt(row: row, column: col)
//    }
//}

struct ContentView: View {
    
    @StateObject var game: Game
    
//    var scene: SKScene {
//        let scene = GameScene(grid: grid)
//        scene.size = CGSize(width: 300, height: 400)
//        scene.scaleMode = .fill
//        return scene
//    }
    
    var body: some View {
        VStack {
            Text("Score: \(game.coins)")
            GridView(game.grid) { rowTapped, colTapped in
                game.flipTileAt(row: rowTapped, col: colTapped)
            }
            
            DialogBox(stateText)
                .frame(height: 60)
                .padding()
        }
    }
    
    var stateText: String {
        switch game.state {
        case .lost:
            return "You lost!"
        case .won:
            return "You won!"
        case .ongoing:
            return "You're playing Voltorb Flip."
        }
    }
}

struct DialogBox: View {
    
    init(_ text: String) {
        self.text = text
    }
    var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .border(.black)
            HStack {
                Text(text)
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
            }
        }
    }
}

struct GridView: View {
    
    var grid: Grid
    var tappedGridAt: (Int, Int) -> Void
    
    init(_ grid: Grid, tappedGridAt: @escaping (Int, Int) -> Void) {
        self.grid = grid
        self.tappedGridAt = tappedGridAt
    }
    
    var body: some View {
        VStack {
            // TODO: Abstract into GridView, then implement game
            ForEach(0..<grid.rowCount) { row in
                HStack {
                    ForEach(0..<grid.colCount) { col in
                        TileView(grid[row][col])
                            .onTapGesture {
                                tappedGridAt(row, col)
                            }
                    }
                    GridLabelView(grid.rowLabels[row])
                }
            }
            HStack {
                ForEach(0..<grid.colCount) { col in
                    GridLabelView(grid.colLabels[col])
                }
                GridLabelView(grid.colLabels[0])
                    .opacity(0)
            }
        }
    }
}

struct TileView: View {
    
    init(_ tile: Tile) {
        self.tile = tile
    }
    
    var tile: Tile
    var tileText: String {
        switch tile.value {
        case .voltorb:
            return "V"
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        }
    }
    
    var tileBackColor: Color {
        tile.value == .voltorb ? .red : .indigo
    }
    
    let durationAndDelay : CGFloat = 0.1
    let cornerRadius: CGFloat = 4
    var frontDegree: Double { tile.state == .flipped ? 90 : 0 }
    var backDegree: Double { tile.state == .flipped ? 0 : -90 }
    
    
    var front: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
        }
        .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut(duration: durationAndDelay).delay(tile.state == .flipped ? 0 : durationAndDelay), value: frontDegree)
    }
    
    var back: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(width: 50, height: 50)
                .foregroundColor(tileBackColor)
            Text(tileText)
                .frame(width: 20, height: 20)
        }
        .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut(duration: durationAndDelay).delay(tile.state == .notFlipped ? 0 : durationAndDelay), value: backDegree)
        
    }
    
    var body: some View {
        ZStack {
            back
            front
        }
    }
}

struct GridLabelView: View {
    
    init(_ gridLabel: GridLabel) {
        self.gridLabel = gridLabel
    }
    
    var gridLabel: GridLabel
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 50, height: 50)
                .foregroundColor(.green)
            VStack {
                Text("💰 \(gridLabel.totalValue)")
                Text("⛔️ \(gridLabel.voltorbCount)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: Game())
    }
}

//
//  SquareShape.swift
//  Tetris
//
//  Created by Hugo Nordell on 10/9/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

class SquareShape: Shape {
    
    /*
    
    Indices
    | 0 | 1 |
    | 2 | 3 |
    
    Square shapes do not rotate
    
    */
    
    override var blockRowColPositions: [Orientation: Array<(colDiff: Int, rowDiff: Int)>] {
        // Override the computed dictionary from the Shape class
        // Same values as square always looks the same, i.e. no rotation
        return [
            Orientation.Zero: [(0,0), (1,0), (0,1), (1,1)],
            Orientation.Ninety: [(0,0), (1,0), (0,1), (1,1)],
            Orientation.OneEighty: [(0,0), (1,0), (0,1), (1,1)],
            Orientation.TwoSeventy: [(0,0), (1,0), (0,1), (1,1)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<(Block)>] {
        // Bottom blocks are always third and fourth indices of the shape array
        return [
            Orientation.Zero: [blocks[thirdBlockIndex], blocks[fourthBlockIndex]],
            Orientation.Ninety: [blocks[thirdBlockIndex], blocks[fourthBlockIndex]],
            Orientation.OneEighty: [blocks[thirdBlockIndex], blocks[fourthBlockIndex]],
            Orientation.TwoSeventy: [blocks[thirdBlockIndex], blocks[fourthBlockIndex]]
        ]
    }
}

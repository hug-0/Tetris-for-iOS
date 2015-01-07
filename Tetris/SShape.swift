//
//  SShape.swift
//  Tetris
//
//  Created by Hugo Nordell on 10/9/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

class SShape:Shape {
    /*
    
    Orientation 0
    
    | 0•|
    | 1 | 2 |
        | 3 |
    
    Orientation 90
    
      • | 1 | 0 |
    | 3 | 2 |
    
    Orientation 180
    
    | 3•|
    | 2 | 1 |
        | 0 |
    
    Orientation 270
    
      • | 2 | 3 |
    | 0 | 1 |
    
    • marks the row/column indicator for the shape
    
    */
    
    override var blockRowColPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero:       [(0, 0), (0, 1), (1, 1), (1, 2)],
            Orientation.Ninety:     [(2, 0), (1, 0), (1, 1), (0, 1)],
            Orientation.OneEighty:  [(1, 2), (1, 1), (0, 1), (0, 0)],
            Orientation.TwoSeventy: [(0, 1), (1, 1), (1, 0), (2, 0)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.Zero:       [blocks[secondBlockIndex], blocks[fourthBlockIndex]],
            Orientation.Ninety:     [blocks[firstBlockIndex], blocks[thirdBlockIndex], blocks[fourthBlockIndex]],
            Orientation.OneEighty:  [blocks[firstBlockIndex], blocks[thirdBlockIndex]],
            Orientation.TwoSeventy: [blocks[firstBlockIndex], blocks[secondBlockIndex], blocks[fourthBlockIndex]]
        ]
    }
}

//
//  LShape.swift
//  Tetris
//
//  Created by Hugo Nordell on 10/9/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

/*
Orientations 0 and 180:

| 0•|
| 1 |
| 2 |
| 3 |

Orientations 90 and 270:

| 0 | 1•| 2 | 3 |

• marks the row/column indicator for the shape

*/

// Hinges about the second block

class LineShape: Shape {
    override var blockRowColPositions: [Orientation: Array<(colDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero:       [(0,0), (0,1), (0,2), (0,3)],
            Orientation.Ninety:     [(2,0), (1,0), (0,0), (-1,0)],
            Orientation.OneEighty:  [(0,3), (0,2), (0,1), (0,0)],
            Orientation.TwoSeventy: [(-1,0), (0,0), (1,0), (2,0)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<(Block)>] {
        return [
            Orientation.Zero:       [blocks[fourthBlockIndex]],
            Orientation.Ninety:     blocks,
            Orientation.OneEighty:  [blocks[firstBlockIndex]],
            Orientation.TwoSeventy: blocks
        ]
    }
}

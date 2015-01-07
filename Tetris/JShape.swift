//
//  JShape.swift
//  Tetris
//
//  Created by Hugo Nordell on 10/9/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

/*

Orientation 0

•   | 0 |
    | 1 |
| 3 | 2 |

Orientation 90

| 3•|
| 2 | 1 | 0 |

Orientation 180

| 2•| 3 |
| 1 |
| 0 |

Orientation 270

| 0•| 1 | 2 |
| 3 |

• marks the row/column indicator for the shape

Pivots about `1`

*/

class JShape: Shape {
    
    override var blockRowColPositions: [Orientation: Array<(colDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero:       [(1, 0), (1, 1),  (1, 2),  (0, 2)],
            Orientation.Ninety:     [(2, 1), (1, 1),  (0, 1),  (0, 0)],
            Orientation.OneEighty:  [(0, 2), (0, 1),  (0, 0),  (1, 0)],
            Orientation.TwoSeventy: [(0, 0), (1, 0),  (2, 0),  (2, 1)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<(Block)>] {
        return [
            Orientation.Zero: [blocks[thirdBlockIndex], blocks[fourthBlockIndex]],
            Orientation.Ninety: [blocks[firstBlockIndex], blocks[secondBlockIndex], blocks[thirdBlockIndex]],
            Orientation.OneEighty: [blocks[firstBlockIndex], blocks[fourthBlockIndex]],
            Orientation.TwoSeventy: [blocks[firstBlockIndex], blocks[secondBlockIndex], blocks[fourthBlockIndex]]
        ]
    }
}
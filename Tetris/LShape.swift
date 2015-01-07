//
//  LShape.swift
//  Tetris
//
//  Created by Hugo Nordell on 10/9/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

/*

Orientation 0

| 0•|
| 1 |
| 2 | 3 |

Orientation 90

      •
| 2 | 1 | 0 |
| 3 |

Orientation 180

| 3 | 2•|
    | 1 |
    | 0 |

Orientation 270

      * | 3 |
| 0 | 1 | 2 |

• marks the row/column indicator for the shape

Pivots about `1`

*/

class LShape: Shape {
    override var blockRowColPositions: [Orientation: Array<(colDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero:       [ (0, 0), (0, 1),  (0, 2),  (1, 2)],
            Orientation.Ninety:     [ (1, 1), (0, 1),  (-1,1), (-1, 2)],
            Orientation.OneEighty:  [ (0, 2), (0, 1),  (0, 0),  (-1,0)],
            Orientation.TwoSeventy: [ (-1,1), (0, 1),  (1, 1),   (1,0)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<(Block)>] {
        return [
            Orientation.Zero:       [blocks[thirdBlockIndex], blocks[fourthBlockIndex]],
            Orientation.Ninety:     [blocks[firstBlockIndex], blocks[secondBlockIndex], blocks[fourthBlockIndex]],
            Orientation.OneEighty:  [blocks[firstBlockIndex], blocks[fourthBlockIndex]],
            Orientation.TwoSeventy: [blocks[firstBlockIndex], blocks[secondBlockIndex], blocks[thirdBlockIndex]]
        ]
    }
}
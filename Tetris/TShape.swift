//
//  TShape.swift
//  Tetris
//
//  Created by Hugo Nordell on 10/9/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

/*
Orientation 0

   *| 0 |
| 1 | 2 | 3 |

Orientation 90

   *| 1 |
    | 2 | 0 |
    | 3 |

Orientation 180

| 3*| 2 | 1 |
    | 0 |

Orientation 270

   *| 3 |
| 0 | 2 |
    | 1 |

*/

class TShape: Shape {
    
    override var blockRowColPositions: [Orientation: Array<(colDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero:       [(1, 0), (0, 1), (1, 1), (2, 1)],
            Orientation.Ninety:     [(2, 1), (1, 0), (1, 1), (1, 2)],
            Orientation.OneEighty:  [(1, 1), (2, 0), (1, 0), (0, 0)],
            Orientation.TwoSeventy: [(0, 1), (1, 2), (1, 1), (1, 0)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<(Block)>] {
        return [
            Orientation.Zero: [blocks[secondBlockIndex], blocks[thirdBlockIndex], blocks[fourthBlockIndex]],
            Orientation.Ninety: [blocks[firstBlockIndex], blocks[fourthBlockIndex]],
            Orientation.OneEighty: [blocks[firstBlockIndex], blocks[secondBlockIndex], blocks[fourthBlockIndex]],
            Orientation.TwoSeventy: [blocks[firstBlockIndex], blocks[secondBlockIndex]]
        ]
    }  
}

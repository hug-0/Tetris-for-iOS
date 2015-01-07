//
//  Shape.swift
//  Tetris
//
//  Created by Hugo Nordell on 10/9/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

import SpriteKit

// Nbr of orientations : 0, 90, 180, 270
let numberOfOrientations: UInt32 = 4

enum Orientation: Int, Printable {
    case Zero = 0, Ninety, OneEighty, TwoSeventy
    
    var description: String {
        switch self {
        case .Zero:
            return "0"
        case .Ninety:
            return "90"
        case .OneEighty:
            return "180"
        case .TwoSeventy:
            return "270"
        }
    }
    
    static func random() -> Orientation {
        // Randomize orientation of Shape upon creation
        return Orientation(rawValue: Int(arc4random_uniform(numberOfOrientations)))!
    }
    
    static func rotate(orientation: Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.rawValue + (clockwise ? 1 : -1)
        if rotated > Orientation.TwoSeventy.rawValue {
            rotated = Orientation.Zero.rawValue
        } else if rotated < 0 {
            rotated = Orientation.TwoSeventy.rawValue
        }
        return Orientation(rawValue: rotated)!
    }
}

// Number of shape varieties : 7
let numberOfShapeTypes: UInt32 = 7

// Shape Indices : 4 blocks for every shape
let firstBlockIndex: Int = 0
let secondBlockIndex: Int = 1
let thirdBlockIndex: Int = 2
let fourthBlockIndex: Int = 3

class Shape: Hashable, Printable {
    // Shape color
    let color: BlockColor

    // Block array of the shape
    var blocks = Array<Block>()
    
    // Current shape orientation
    var orientation: Orientation
    
    // Column and Row representing the shape's anchor point
    var column: Int
    var row: Int
    
    // Required overrides for subclasses
    
    // Computed dictionary
    var blockRowColPositions: [Orientation: Array<(colDiff: Int, rowDiff: Int)>] {
        return [:]
    }

    var bottomBlocksForOrientations: [Orientation: Array<(Block)>] {
        return [:]
    }

    var bottomBlocks: Array<(Block)> {
        if let bottomBlocks = bottomBlocksForOrientations[orientation] {
            return bottomBlocks
        }
        return []
    }
    
    var hashValue: Int {
        return reduce(blocks, 0) { $0.hashValue ^ $1.hashValue }
    }

    var description: String {
        return "\(color) block facing \(orientation): \(blocks[firstBlockIndex]), \(blocks[secondBlockIndex]), \(blocks[thirdBlockIndex]), \(blocks[fourthBlockIndex])"
    }
    
    init(column: Int, row: Int, color: BlockColor, orientation: Orientation) {
        self.color = color
        self.column = column
        self.row = row
        self.orientation = orientation
        initalizeBlocks()
    }

    // Convenience init
    convenience init(column: Int, row: Int) {
        self.init(column: column, row: row, color: BlockColor.random(), orientation: Orientation.random())
    }
    
    // Cannot be overriden by subclasses
    final func initalizeBlocks() {
        if let blockRowColTranslations = blockRowColPositions[orientation] {
            for i in 0..<blockRowColTranslations.count {
                let blockRow = row + blockRowColTranslations[i].rowDiff
                let blockCol = column + blockRowColTranslations[i].colDiff
                let newBlock = Block(column: blockCol, row: blockRow, color: color)
                blocks.append(newBlock)
            }
        }
    }
    
    final func rotateBlocks(orientation: Orientation) {
        if let blockRowColTranslation:Array<(colDiff: Int, rowDiff: Int)> = blockRowColPositions[orientation] {
            for (index, (colDiff: Int, rowDiff: Int)) in enumerate(blockRowColTranslation) {
                blocks[index].column = column + colDiff
                blocks[index].row = row + rowDiff
            }
        }
    }
    
    final func rotateClockwise() {
        let newOrientation = Orientation.rotate(orientation, clockwise: true)
        rotateBlocks(newOrientation)
        orientation = newOrientation
    }
    
    final func rotateCounterClockwise() {
        let newOrientation = Orientation.rotate(orientation, clockwise: false)
        rotateBlocks(newOrientation)
        orientation = newOrientation
    }
    
    final func lowerShapeByOneRow() {
        shiftBy(0, rows: 1)
    }
    
    final func raiseShapebyOneRow() {
        shiftBy(0, rows: -1)
    }
    
    final func shiftRightByOneCol() {
        shiftBy(1, rows: 0)
    }
    
    final func shiftLeftByOneCol() {
        shiftBy(-1, rows: 0)
    }
    
    final func shiftBy(columns: Int, rows: Int) {
        self.column += columns
        self.row += rows
        for block in blocks {
            block.column += columns
            block.row += rows
        }
    }
    
    final func moveTo(column: Int, row: Int) {
        self.column = column
        self.row = row
        rotateBlocks(orientation)
    }
    
    final class func random(startingColumn: Int, startingRow: Int) -> Shape {
        switch Int(arc4random_uniform(numberOfShapeTypes)) {
        case 0:
            return SquareShape(column: startingColumn, row: startingRow)
        case 1:
            return LineShape(column: startingColumn, row: startingRow)
        case 2:
            return LShape(column: startingColumn, row: startingRow)
        case 3:
            return TShape(column: startingColumn, row: startingRow)
        case 4:
            return JShape(column: startingColumn, row: startingRow)
        case 5:
            return ZShape(column: startingColumn, row: startingRow)
        default:
            return SShape(column: startingColumn, row: startingRow)
        }
    }
}

func ==(lhs: Shape, rhs: Shape) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}








//
//  Tetris.swift
//  Tetris
//
//  Created by Hugo Nordell on 10/9/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

protocol TetrisDelegate {
    
    // Invoked when game ends
    func gameDidEnd(tetris: Tetris)
    
    // Invoked immediately after new game begins
    func gameDidBegin(tetris: Tetris)
    
    // Invoked when falling shape has become part of the gameboard
    func gameShapeDidLand(tetris: Tetris)
    
    // Invoked when a falling shape changed its location
    func gameShapeDidMove(tetris: Tetris)
    
    // Invoked when a falling shape was dropped
    func gameShapeDidDrop(tetris: Tetris)
    
    // Invoked when level up in a given game
    func gameDidLevelUp(tetris: Tetris)
}

let numCols = 10
let numRows = 25
let startCol = 4
let startRow = 0
let previewCol = 12
let previewRow = 0
let pointsPerLine = 100
let levelThreshold = 1000

class Tetris {
    // Set gameboard, next shape and falling shape
    var blockArray: Array2D<Block>
    var nextShape: Shape?
    var fallingShape: Shape?
    
    // Set the delegate
    var delegate: TetrisDelegate?
    
    // Scoring and Levels
    var score: Int
    var level: Int

    init() {
        score = 0
        level = 1
        fallingShape = nil
        nextShape = nil
        blockArray = Array2D<Block>(columns: numCols, rows: numRows)
    }
    
    func beginGame() {
        if (nextShape == nil) {
            nextShape = Shape.random(previewCol, startingRow: previewRow)
        }
        delegate?.gameDidBegin(self)
    }

    func newShape() -> (fallingShape: Shape?, nextShape: Shape?) {
        fallingShape = nextShape
        nextShape = Shape.random(previewCol, startingRow: previewRow)
        fallingShape?.moveTo(startCol, row: startRow)
        
        if detectIllegalPlacement() {
            nextShape = fallingShape
            nextShape!.moveTo(previewCol, row: previewRow)
            // Game ends when start location is illegal placement of block
            endGame()
            return (nil, nil)
        }
        return (fallingShape, nextShape)
    }
    
    func detectIllegalPlacement() -> Bool {
        if let shape = fallingShape {
            for block in shape.blocks {
                if block.column < 0 || block.column >= numCols || block.row < 0 || block.row >= numRows {
                    return true
                } else if blockArray[block.column, block.row] != nil {
                    return true
                }
            }
        }
        // Default return legal placement of block
        return false
    }
    
    func dropShape() {
        if let shape = fallingShape {
            while detectIllegalPlacement() == false {
                shape.lowerShapeByOneRow()
            }
            // Raise one row when detecting illegal placement
            shape.raiseShapebyOneRow()
            delegate?.gameShapeDidDrop(self)
        }
    }
    
    func letShapeFall() {
        if let shape = fallingShape {
            shape.lowerShapeByOneRow()
            if detectIllegalPlacement() {
                shape.raiseShapebyOneRow()
                if detectIllegalPlacement() {
                    endGame()
                } else {
                    settleShape()
                }
            } else {
                delegate?.gameShapeDidMove(self)
                if detectTouch() {
                    settleShape()
                }
            }
        }
    }
    
    func rotateShape() {
        if let shape = fallingShape {
            shape.rotateClockwise()
            if detectIllegalPlacement() {
                shape.rotateCounterClockwise()
            } else {
                delegate?.gameShapeDidMove(self)
            }
        }
    }
    
    func moveShapeLeft() {
        if let shape = fallingShape {
            shape.shiftLeftByOneCol()
            if detectIllegalPlacement() {
                shape.shiftRightByOneCol()
                return
            }
            delegate?.gameShapeDidMove(self)
        }
    }
    
    func moveShapeRight() {
        if let shape = fallingShape {
            shape.shiftRightByOneCol()
            if detectIllegalPlacement() {
                shape.shiftLeftByOneCol()
                return
            }
            delegate?.gameShapeDidMove(self)
        }
    }
    
    func settleShape() {
        if let shape = fallingShape {
            for block in shape.blocks {
                blockArray[block.column, block.row] = block
            }
            // Shape did settle in gameboard
            fallingShape = nil
            delegate?.gameShapeDidLand(self)
        }
    }
    
    func detectTouch() -> Bool {
        if let shape = fallingShape {
            for bottomBlock in shape.bottomBlocks {
                if bottomBlock.row == numRows - 1 ||
                    blockArray[bottomBlock.column, bottomBlock.row + 1] != nil {
                    return true
                }
            }
        }
        return false
    }
    
    func endGame() {
        score = 0
        level = 1
        delegate?.gameDidEnd(self)
    }
    
    func removeCompletedLines() -> (linesRemoved: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>) {
        var removedLines = Array<Array<Block>>()
        
        for var row = numRows - 1; row > 0; row-- {
            var rowOfBlocks = Array<Block>()
            
            for col in 0..<numCols {
                if let block = blockArray[col, row] {
                    rowOfBlocks.append(block)
                }
            }
            
            if rowOfBlocks.count == numCols {
                removedLines.append(rowOfBlocks)
                
                for block in rowOfBlocks {
                    blockArray[block.column, block.row] = nil
                }
            }
        }
        
        // No lines removed, return empty
        if removedLines.count == 0 {
            return ([], [])
        }
        
        // Let scoring be #linesRemoved * points per line * current level for boost
        let pointsEarned = removedLines.count * pointsPerLine * level
        score += pointsEarned
        
        // Level up every levelThreshold number of points
        if score >= level * levelThreshold {
            level += 1
            delegate?.gameDidLevelUp(self)
        }
        
        var fallenBlocks = Array<Array<Block>>()
        for column in 0..<numCols {
            var fallenBlocksArray = Array<Block>()
            
            for var row = removedLines[0][0].row - 1; row > 0; row-- {
                if let block = blockArray[column, row] {
                    var newRow = row
                    
                    while (newRow < numRows - 1 && blockArray[column, newRow + 1] == nil) {
                        newRow++
                    }
                    
                    block.row = newRow
                    blockArray[column, row] = nil
                    blockArray[column, newRow] = block
                    fallenBlocksArray.append(block)
                }
            }
            
            if fallenBlocksArray.count > 0 {
                fallenBlocks.append(fallenBlocksArray)
            }
        }
        return (removedLines, fallenBlocks)
    }
    
    func removeAllBlocks() -> Array<Array<Block>> {
        var allBlocks = Array<Array<Block>>()
        
        for row in 0..<numRows {
            var rowOfBlocks = Array<Block>()
            
            for col in 0..<numCols {
                if let block = blockArray[col, row] {
                    rowOfBlocks.append(block)
                    blockArray[col, row] = nil
                }
            }
            allBlocks.append(rowOfBlocks)
        }
        return allBlocks
    }
}

//
//  Block.swift
//  Tetris
//
//  Created by Hugo Nordell on 10/9/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

import SpriteKit

// Set number of colors allowed
let numberOfColors: UInt32 = 6

enum BlockColor: Int, Printable {
    case Blue = 0, Orange, Purple, Red, Teal, Yellow
    
    var spriteName: String {
        switch self {
        case .Blue:
            return "blue"
        case .Orange:
            return "orange"
        case .Purple:
            return "purple"
        case .Red:
            return "red"
        case .Teal:
            return "teal"
        case .Yellow:
            return "yellow"
        }
    }
    
    var description: String {
        return self.spriteName
    }
    
    static func random() -> BlockColor {
        // Random color from 0..<numberOfColors
        return BlockColor(rawValue: Int(arc4random_uniform(numberOfColors)))!
    }
}

class Block: Hashable, Printable {
    
    // Set computed property
    let color: BlockColor
    
    // Properties of the Block
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?
    
    var spriteName: String {
        return color.description
    }
    
    var hashValue: Int {
        return self.column ^ self.row
    }
    
    var description: String {
        return "\(color): [\(column), \(row)]"
    }
    
    init(column: Int, row: Int, color: BlockColor) {
        self.column = column
        self.row = row
        self.color = color
    }
}

// Allow for comparing one block with another
func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}

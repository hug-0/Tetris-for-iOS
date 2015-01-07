//
//  GameScene.swift
//  Tetris
//
//  Created by Hugo Nordell on 10/9/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

import SpriteKit
//import Foundation

// Properties
let tickLengthLevelOne = NSTimeInterval(600)

// Gameboard grid size
let BlockSize: CGFloat = 20.0
let blockOffset: CGFloat = 6.0

class GameScene: SKScene {
    
    // Keep game layer and shapes in different nodes
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    let LayerPosition = CGPoint(x: blockOffset, y: -blockOffset)
    
    var tick: (() -> ())?
    var tickLengthMS = tickLengthLevelOne
    var lastTick: NSDate?
    
    var textureCache = Dictionary<String, SKTexture>()

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported.")
    }
   
    override init(size: CGSize) {
        super.init(size: size)
        
        // Set anchor point for the scene
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        // Setup background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)
        
        // Add game layer to scene
        gameLayer.position = LayerPosition
        addChild(gameLayer)
        
        // Setup gameboard
        let gameboardTexture = SKTexture(imageNamed: "gameboard")
        let gameboard = SKSpriteNode(texture: gameboardTexture ,size: CGSizeMake(BlockSize*CGFloat(numCols), BlockSize*CGFloat(numRows)+blockOffset))
        gameboard.anchorPoint = CGPoint(x: 0, y: 1.0)
        gameboard.position = LayerPosition
        addChild(gameboard)
        
        // Setup shape layer
        shapeLayer.position = CGPoint(x: 0, y: -blockOffset) //LayerPosition
        addChild(shapeLayer)
        
        // Setup sounds
        runAction(SKAction.repeatActionForever(SKAction.playSoundFileNamed("theme.mp3", waitForCompletion: true)))
    }
    
    func playSounds(sound: String) {
        runAction(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lastTick == nil {
            return
        }
        
        // Secs to MS
        var timePassed = lastTick!.timeIntervalSinceNow * -1000.0
        if timePassed > tickLengthMS {
            lastTick = NSDate()
            tick?()
        }
    }
    
    func startTicking() {
        lastTick = NSDate()
    }
    
    func stopTicking() {
        lastTick = nil
    }
    
    func pointForCol(column: Int, row: Int) -> CGPoint {
        let x: CGFloat = LayerPosition.x + (CGFloat(column) * BlockSize) + (BlockSize/2)
        let y: CGFloat = LayerPosition.y - ((CGFloat(row) * BlockSize) + (BlockSize/2))
        return CGPointMake(x, y)
    }
    
    func addPreviewShapeToScene(shape: Shape, completion: () -> ()) {
        for (index, block) in enumerate(shape.blocks) {
            var texture = textureCache[block.spriteName]
            if texture == nil {
                texture = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName] = texture
            }
            let sprite = SKSpriteNode(texture: texture)
            
            sprite.position = pointForCol(block.column, row: block.row - 2)
            shapeLayer.addChild(sprite)
            block.sprite = sprite
            
            // Animate
            sprite.alpha = 0
            
            let moveAction: SKAction = SKAction.moveTo(pointForCol(block.column, row: block.row), duration: NSTimeInterval(0.2))
            moveAction.timingMode = .EaseOut
            let fadeInAction: SKAction = SKAction.fadeAlphaTo(0.7, duration: 0.4)
            fadeInAction.timingMode = .EaseOut
            sprite.runAction(SKAction.group([moveAction, fadeInAction]))
        }
        runAction(SKAction.waitForDuration(0.2), completion: completion)
    }
    
    func movePreviewShape(shape: Shape, completion: () -> ()) {
        for (index, block) in enumerate(shape.blocks) {
            let sprite = block.sprite!
            let moveTo = pointForCol(block.column, row: block.row)
            let moveAction: SKAction = SKAction.moveTo(moveTo, duration: 0.2)
            moveAction.timingMode = .EaseOut
            sprite.runAction(SKAction.group([moveAction, SKAction.fadeAlphaTo(1.0, duration: 0.2)]), completion: nil)
        }
        runAction(SKAction.waitForDuration(0.2), completion: completion)
    }
    
    func redrawShape(shape: Shape, completion: () -> ()) {
        for (index, block) in enumerate(shape.blocks) {
            let sprite = block.sprite!
            let moveTo = pointForCol(block.column, row: block.row)
            let moveAction: SKAction = SKAction.moveTo(moveTo, duration: 0.05)
            moveAction.timingMode = .EaseOut
            sprite.runAction(moveAction, completion: nil)
        }
        runAction(SKAction.waitForDuration(0.05), completion: completion)
    }
    
    func animateCollapsingLines(linesToRemove: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>, completion: () -> ()) {
        var longestDuration: NSTimeInterval = 0
        
        for (columnIndex, column) in enumerate(fallenBlocks) {
            for (blockIndex, block) in enumerate(column) {
                let newPosition = pointForCol(block.column, row: block.row)
                let sprite = block.sprite!
                
                let delay = (NSTimeInterval(columnIndex)*0.05) + (NSTimeInterval(blockIndex)*0.05)
                let duration = NSTimeInterval(((sprite.position.y - newPosition.y) / BlockSize) * 0.1)
                let moveAction = SKAction.moveTo(newPosition, duration: duration)
                moveAction.timingMode = .EaseOut
                sprite.runAction(SKAction.sequence([SKAction.waitForDuration(delay), moveAction]))
                longestDuration = max(longestDuration, duration + delay)
            }
        }
        
        for (rowIndex, row) in enumerate(linesToRemove) {
            for (blockIndex, block) in enumerate(row) {
                let randomRadius = CGFloat(Int(arc4random_uniform(400) + 100))
                let goLeft = arc4random_uniform(100) % 2 == 0
                
                var point = pointForCol(block.column, row: block.row)
                point = CGPointMake(point.x + (goLeft ? -randomRadius : randomRadius), point.y)
                
                let randomDuration = NSTimeInterval(arc4random_uniform(2)) + 0.5
                
                var startAngle = CGFloat(M_PI)
                var endAngle = startAngle * 2
                
                if goLeft {
                    endAngle = startAngle
                    startAngle = 0
                }
                
                let archPath = UIBezierPath(arcCenter: point, radius: randomRadius, startAngle: startAngle, endAngle: endAngle, clockwise: goLeft)
                let archAction = SKAction.followPath(archPath.CGPath, asOffset: false, orientToPath: true, duration: randomDuration)
                archAction.timingMode = .EaseIn
                let sprite = block.sprite!
                
                sprite.zPosition = 100
                sprite.runAction(SKAction.sequence([SKAction.group([archAction, SKAction.fadeOutWithDuration(NSTimeInterval(randomDuration))]), SKAction.removeFromParent()]))
            }
        }
        runAction(SKAction.waitForDuration(longestDuration), completion: completion)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

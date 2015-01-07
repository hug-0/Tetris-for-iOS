//
//  GameViewController.swift
//  Tetris
//
//  Created by Hugo Nordell on 10/9/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, TetrisDelegate, UIGestureRecognizerDelegate {
    
    var scene: GameScene!
    var tetris: Tetris!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    var panPointReference: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set labels
        scoreLabel.text = "0"
        levelLabel.text = "1"
        
        // Config the view
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        // Create the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        // Set did tick
        scene.tick = didTick
        
        // Set the model and start the game
        tetris = Tetris()
        tetris.delegate = self
        tetris.beginGame()
        
        // Present the scene
        skView.presentScene(scene)

    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        tetris.dropShape()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let swipeRec = gestureRecognizer as? UISwipeGestureRecognizer {
            if let panRec = otherGestureRecognizer as? UIPanGestureRecognizer {
                return true
            }
        } else if let panRec = gestureRecognizer as? UIPanGestureRecognizer {
            if let tap = otherGestureRecognizer as? UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        // Only move if finger panned more than 60% of block's size.
        let currentPoint = sender.translationInView(self.view)
        
        if let originalPoint = panPointReference {
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.6) {
                if sender.velocityInView(self.view).x > CGFloat(0) {
                    tetris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    tetris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .Began {
            panPointReference = currentPoint
        }
    }
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        tetris.rotateShape()
    }
    
    func didTick() {
        tetris.letShapeFall()
    }
    
    func nextShape() {
        let newShape = tetris.newShape()
        
        if let fallingShape = newShape.fallingShape {
            self.scene.addPreviewShapeToScene(newShape.nextShape!) {}
            self.scene.movePreviewShape(fallingShape) {
                self.view.userInteractionEnabled = true
                self.scene.startTicking()
            }
        }
    }
    
    func gameDidBegin(tetris: Tetris) {
        levelLabel.text = "\(tetris.level)"
        scoreLabel.text = "\(tetris.score)"
        scene.tickLengthMS = tickLengthLevelOne
        
        // False when starting a game
        if tetris.nextShape != nil && tetris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(tetris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(tetris: Tetris) {
        view.userInteractionEnabled = false
        scene.stopTicking()
        scene.playSounds("gameover.mp3")
        scene.animateCollapsingLines(tetris.removeAllBlocks(), fallenBlocks: Array<Array<Block>>()) {
            tetris.beginGame()
        }
    }
    
    func gameDidLevelUp(tetris: Tetris) {
        levelLabel.text = "\(tetris.level)"
        if scene.tickLengthMS >= 100 {
            scene.tickLengthMS -= 100
        } else if scene.tickLengthMS > 50 {
            scene.tickLengthMS -= 50
        }
        scene.playSounds("levelup.mp3")
    }
    
    func gameShapeDidDrop(tetris: Tetris) {
        scene.stopTicking()
        scene.redrawShape(tetris.fallingShape!) {
            tetris.letShapeFall()
        }
        scene.playSounds("drop.mp3")
    }
    
    func gameShapeDidLand(tetris: Tetris) {
        scene.stopTicking()
        self.view.userInteractionEnabled = false
        let removedLines = tetris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(tetris.score)"
            scene.animateCollapsingLines(removedLines.linesRemoved, fallenBlocks: removedLines.fallenBlocks) {
                self.gameShapeDidLand(tetris)
            }
            scene.playSounds("bomb.mp3")
        } else {
            nextShape()
        }
    }
    
    func gameShapeDidMove(tetris: Tetris) {
        scene.redrawShape(tetris.fallingShape!) {}
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

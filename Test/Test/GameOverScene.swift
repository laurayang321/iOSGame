//
//  GameOverScene.swift
//  SpriteKitSimpleGame
//
//  Created by Laura Yang on 2017-01-27.
//  Copyright © 2017 Laura Yang. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        
        // 1
        backgroundColor = SKColor.gray
        
        // 2
        let message = won ? "You Won!" : "You Lose :["
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // 4
        run(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.run() {
                // 5
                //let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                
                if let scene = GameScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    self.view!.presentScene(scene, transition: SKTransition.fade(with: UIColor.black, duration: 0.2))
                }
                
                //let scene = GameScene(size: size)
                //self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

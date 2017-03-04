//
//  StartScene.swift
//  Test
//
//  Created by Dalton Danis on 2017-02-16.
//  Copyright © 2017 Dalton Danis. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if atPoint(location).name == "Play" {
                if let scene = GameScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    view!.presentScene(scene, transition: SKTransition.fade(with: UIColor.black, duration: 0.2))
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
    }
}

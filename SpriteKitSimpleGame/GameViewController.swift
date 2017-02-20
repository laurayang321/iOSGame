//
//  GameViewController.swift
//  SpriteKitSimpleGame
//
//  Created by Laura Yang on 2017-01-27.
//  Copyright © 2017 Laura Yang. All rights reserved.
//

import UIKit
import SpriteKit

// GameViewController is a normal UIViewController, except that its root view is a SKView, which is a view that contains a SpriteKit scene.
class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size) //set game scene size
        
        let skView = view as! SKView //type cast view
        skView.showsFPS = true
        skView.showsNodeCount = true
        //background image, cahracter, hero, enemeis; make sure background is always back.
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

//
//  GameViewController.swift
//  Test
//
//  Created by Dalton Danis on 2017-02-16.
//  Copyright © 2017 Dalton Danis. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        if let view = self.view as! SKView? {
            if let scene = StartScene(fileNamed: "StartScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.

            
            // Get the SKScene from the loaded GKScene
            //if let sceneNode = scene.rootNode as! StartScene? {
                
                // Copy gameplay related content over to the scene
                //sceneNode.entities = scene.entities
                //sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                //sceneNode.scaleMode = .aspectFill
            
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeRight, .landscapeLeft]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


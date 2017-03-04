//
//  Labels.swift
//  Test
//
//  Created by Dalton Danis on 2017-03-02.
//  Copyright © 2017 Dalton Danis. All rights reserved.
//

import Foundation
import SpriteKit

func getHealth() -> SKLabelNode {
    let healthLabel = SKLabelNode(text: "Health: \(Settings.Game.health)")
    
    healthLabel.fontName = "Comic Sans MS-bold"
    healthLabel.horizontalAlignmentMode = .left
    healthLabel.position = CGPoint(x: 0, y: -155.25)
    
    return healthLabel
}

func getWave() -> SKLabelNode {
    let waveLabel = SKLabelNode(text: "Wave: 0")
    
    waveLabel.fontName = "Comic Sans MS-bold"
    waveLabel.text = "Wave: \(Settings.Game.initWave)"
    waveLabel.horizontalAlignmentMode = .left
    waveLabel.position = CGPoint(x: -184, y: -155.25)
    
    return waveLabel
}

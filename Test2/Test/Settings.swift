//
//  Settings.swift
//  
//  Settings for the game go inside this file
//
//  Created by Dalton Danis on 2017-02-17.
//  Copyright © 2017 Dalton Danis. All rights reserved.
//

import Foundation
import SpriteKit

struct Settings {
    struct Metrics {
        static let projectileRestPosition = CGPoint(x: 200 - (378), y: 207 - (207))
        static let projectileRadius = CGFloat(5)
        static let projectileTouchThreshold = CGFloat(10)
        static let projectileSnapLimit = CGFloat(10)
        static let forceMultiplier = CGFloat(0.09)
        static let rLimit = CGFloat(60)
    }
    struct Game {
        static let gravity = CGVector(dx: 0,dy: -9.8)
        static let health = 6
        static let initWave = 1
    }
}

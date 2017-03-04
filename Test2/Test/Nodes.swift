//
//  Nodes.swift
//  Test
//
//  Created by Dalton Danis on 2017-02-17.
//  Copyright © 2017 Dalton Danis. All rights reserved.
//

import Foundation
import SpriteKit

class Projectile: SKShapeNode {
    convenience init(path: UIBezierPath, color: UIColor, borderColor:UIColor) {
        self.init()
        self.path = path.cgPath
        self.fillColor = color
        self.strokeColor = borderColor
    }
}

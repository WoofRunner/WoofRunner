//
//  Obstacle.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

class Obstacle: Tile {
    
    override init(_ pos: SCNVector3) {
        super.init(pos)
        geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        position = pos
        physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        physicsBody?.contactTestBitMask = CollisionType.Player
        physicsBody?.categoryBitMask = CollisionType.Player
        let redMat = SCNMaterial()
        redMat.diffuse.contents = UIColor.red
        geometry?.materials = [redMat]
        tileType = TileType.rock
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }
}

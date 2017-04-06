//
//  Trigger.swift
//  WoofRunner
//
//  Created by limte on 30/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class Trigger : GameObject {
    
    init(_ pos: SCNVector3) {
        super.init()
        position = pos
        let triggerGeometry = SCNBox(width: CGFloat(GameSettings.TILE_WIDTH-0.2), height: CGFloat(GameSettings.TILE_WIDTH), length: CGFloat(GameSettings.TILE_WIDTH), chamferRadius: 0)
        
        let physicShape = SCNPhysicsShape(geometry: triggerGeometry, options: nil)
        physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicShape)
        physicsBody?.contactTestBitMask = CollisionType.Player
        physicsBody?.categoryBitMask = CollisionType.Tile
    }
    
    override convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }
}

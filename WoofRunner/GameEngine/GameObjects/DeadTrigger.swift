//
//  DeadPlatform.swift
//  WoofRunner
//
//  Created by limte on 30/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class DeadTrigger : Platform {
    override init(_ pos: SCNVector3) {
        super.init(pos)
        let trigger = GameObject()
        let triggerGeometry = SCNBox(width: CGFloat(Tile.TILE_WIDTH-0.2), height: CGFloat(Tile.TILE_WIDTH), length: CGFloat(Tile.TILE_WIDTH), chamferRadius: 0)
        //trigger.geometry = triggerGeometry
        
        let physicShape = SCNPhysicsShape(geometry: triggerGeometry, options: nil)
        trigger.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicShape)
        trigger.physicsBody?.contactTestBitMask = CollisionType.Player
        trigger.physicsBody?.categoryBitMask = CollisionType.Player
        
        trigger.position = SCNVector3(Tile.TILE_WIDTH/2, Tile.TILE_WIDTH/2, -Tile.TILE_WIDTH/2)
        addChildNode(trigger)
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }
}

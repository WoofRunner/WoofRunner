//
//  JumpTrigger.swift
//  WoofRunner
//
//  Created by limte on 31/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class JumpTrigger : Obstacle {
    
    override init(_ pos: SCNVector3) {
        super.init(pos)
        let trigger = Trigger(SCNVector3(Tile.TILE_WIDTH/2, Tile.TILE_WIDTH/2, -Tile.TILE_WIDTH/2))
        addChildNode(trigger)
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }
}


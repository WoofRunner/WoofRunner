//
//  JumpRock.swift
//  WoofRunner
//
//  Created by limte on 31/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class JumpingRock: Obstacle {
    
    override init(_ pos: SCNVector3) {
        super.init(pos)
        tileType = TileType.jumpingRock
        loadModel(tileType.getModelPath())
        triggerDistance = 0
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }
    
    override func update(_ deltaTime: Float) {
        super.update(deltaTime)
        
        if isTriggered {
            position.y = 3
        }
    }
}

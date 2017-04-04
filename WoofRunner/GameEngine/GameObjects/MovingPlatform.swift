//
//  MovingPlatform.swift
//  WoofRunner
//
//  Created by limte on 5/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class MovingPlatform : Platform {
    
    enum MoveDirection {
        case right
        case left
    }
    
    var isMovingToRight: Bool = true
    
    var moveSpeed: Float = 3
    
    
    override init(_ pos: SCNVector3) {
        super.init(pos)
        tileType = TileType.floorDark
        loadModel(tileType.getModelPath())
        triggerDistance = -10
        
        
        
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }
    
    override func update(_ deltaTime: Float) {
        super.update(deltaTime)
        if !isTriggered { return }
        
        position += SCNVector3(moveSpeed, 0, 0) * deltaTime
        
        if position.x > 2 {
            position.x = 2
            moveSpeed *= -1
        } else if position.x < -2 {
            position.x = -2
            moveSpeed *= -1
        }
        
    }
    
    override func onTriggered() {
        print("move trigered")
    }
}

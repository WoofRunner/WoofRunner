//
//  JumpRock.swift
//  WoofRunner
//
//  Created by limte on 31/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class JumpingObstacle: Obstacle {
    
    private var startHeight: Float = 0
    private var jumpSpeed: Float = 4
    private var jumpTime: Float = 0
    private let FULL_JUMP_LENGTH: Float = 3.142
    
    override init(_ tileModel: TileModel) {
        super.init(tileModel)
        triggerDistance = 0
    }

    override func update(_ deltaTime: Float) {
        super.update(deltaTime)
        
        if isTriggered {
            jumpTime += deltaTime * jumpSpeed
            
            if jumpTime < FULL_JUMP_LENGTH {
                position = SCNVector3(position.x, startHeight + sin(jumpTime) * 2, position.z)
            }
        }
    }
    
    override func onTriggered() {
        if !isTriggered {
            startHeight = position.y
        }
    }
    
    override func deactivate() {
        super.deactivate()
        jumpTime = 0
    }
}

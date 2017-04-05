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
    
    var startHeight: Float = 0
    var jumpSpeed: Float = 4
    
    var jumpTime: Float = 0

    let FULL_JUMP_LENGTH: Float = 3.142
    
    override init(_ pos: SCNVector3) {
        super.init(pos)
        tileType = TileType.jumpingRock
        loadModel(tileType.getModelPath())
        triggerDistance = 0
        
        /*
        let timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        let action = SCNAction.move(by: SCNVector3Make(0, 0, -1), duration: 1)
        runAction(action)
 */
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
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

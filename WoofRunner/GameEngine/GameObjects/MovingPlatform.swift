//
//  MovingPlatform.swift
//  WoofRunner
//
//  Created by limte on 5/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

// A platform that moves to and fro from the start to the end column
class MovingPlatform : Platform {
    enum MoveDirection {
        case right
        case left
    }
    
    var moveDirection: MoveDirection = MoveDirection.right
    var moveSpeed: Float = 3
    
    var rightBound: Float = GameSettings.TILE_WIDTH * Float(GameSettings.PLATFORM_COLUMNS/2)
    var leftBound: Float = GameSettings.TILE_WIDTH * -Float(GameSettings.PLATFORM_COLUMNS/2)
    
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
        
        let displacement = SCNVector3(moveSpeed, 0, 0) * deltaTime

        switch moveDirection {
        case .right:
            position += displacement
            if position.x > rightBound {
                position.x = rightBound
                moveDirection = MoveDirection.left
            }
            
        case .left:
            position -= displacement
            if position.x < leftBound {
                position.x = leftBound
                moveDirection = MoveDirection.right
            }
        }
    }
    
    override func onTriggered() {

    }
}

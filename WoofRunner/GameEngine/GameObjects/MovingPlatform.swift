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
    
    var rightBound: Float = GameSettings.TILE_WIDTH * Float(GameSettings.PLATFORM_COLUMNS/2) - GameSettings.TILE_WIDTH
    var leftBound: Float = GameSettings.TILE_WIDTH * -Float(GameSettings.PLATFORM_COLUMNS/2)

    override init(_ tileModel: TileModel) {
        super.init(tileModel)
        triggerDistance = -9
        createAdjacentDeadTriggers()
    }
    /*
    override init(_ pos: SCNVector3) {
        super.init(pos)
        tileType = TileType.movingPlatform
        loadModel(tileType.getModelPath())
        loadModel(tileType.getModelPath(), offsetPostion: SCNVector3(GameSettings.TILE_WIDTH, 0, 0))
        triggerDistance = -9
        createAdjacentDeadTriggers()
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }
    */
    
    // TODO
    func createAdjacentDeadTriggers() {
        if GameSettings.PLATFORM_COLUMNS < 1 { return }
        
        for colIndex in 1..<GameSettings.PLATFORM_COLUMNS {
            //var deadTrigger = DeadTriggerTile(SCNVector3(colIndex+1, 0, 0))
            //addChildNode(deadTrigger)
            //deadTrigger = DeadTriggerTile(SCNVector3(-colIndex, 0, 0))
            //addChildNode(deadTrigger)
        }
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
    
    override func activate() {
        super.activate()
        moveDirection = MoveDirection.right
    }
}

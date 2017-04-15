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
    
    private enum MoveDirection {
        case right
        case left
    }
    
    private var moveDirection: MoveDirection = MoveDirection.right
    private var moveSpeed: Float = 3
    
    private var rightBound: Float = GameSettings.TILE_WIDTH * Float(GameSettings.PLATFORM_COLUMNS/2) - GameSettings.TILE_WIDTH
    private var leftBound: Float = GameSettings.TILE_WIDTH * -Float(GameSettings.PLATFORM_COLUMNS/2)

    private let MIN_NUM_OF_COL = 1
    
    private let KILL_PLATFORM_NAME = GameSettings.KILL_PLATFORM_NAME
    
    private var deadTriggerModel: TileModel? {
        return TileModelFactory.sharedInstance.findTileModel(name: KILL_PLATFORM_NAME)
    }
    
    override init(_ tileModel: TileModel) {
        super.init(tileModel)
        triggerDistance = -9
        createAdjacentDeadTriggers()
    }

    private func createAdjacentDeadTriggers() {
        if GameSettings.PLATFORM_COLUMNS < MIN_NUM_OF_COL { return }
        
        for colIndex in MIN_NUM_OF_COL..<GameSettings.PLATFORM_COLUMNS {
            createDeadTriggers(SCNVector3(Float(colIndex) + GameSettings.TILE_WIDTH, 0, 0))
            createDeadTriggers(SCNVector3(-colIndex, 0, 0))
        }
    }
    
    private func createDeadTriggers(_ position: SCNVector3) {
        guard let deadTriggerModel = deadTriggerModel else { return }
        guard let deadTrigger = TileFactory.sharedInstance.createTile(deadTriggerModel) else { return }
        deadTrigger.setPositionWithOffset(position: position)
        addChildNode(deadTrigger)
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

    override func activate() {
        super.activate()
        moveDirection = MoveDirection.right
    }
}

//
//  Rock.swift
//  WoofRunner
//
//  Created by limte on 30/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class RotatingAxe: Obstacle {
    
    var interval: Float = 1
    var curTime: Float
    var rotateAmount: CGFloat = CGFloat(90).degreesToRadians
    
    override init(_ pos: SCNVector3) {
        curTime = interval
        super.init(pos)
        tileType = TileType.rotatingAxe
        loadModel(tileType.getModelPath())
        positionOffSet = SCNVector3(GameSettings.TILE_WIDTH/2, 0, -GameSettings.TILE_WIDTH/2)
        pivot = SCNMatrix4MakeTranslation(GameSettings.TILE_WIDTH/2, 0, -GameSettings.TILE_WIDTH/2)
        triggerDistance = -5
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }

    func rotateAxe() {
        let action = SCNAction.rotateBy(x: 0, y: rotateAmount, z: 0, duration: 0.3)
        runAction(action)
    }

    override func update(_ deltaTime: Float) {
        super.update(deltaTime)
        if !isTriggered { return }
        
        curTime += deltaTime
        if curTime >= interval {
            // reset time
            curTime = 0
            rotateAxe()
        }
    }
    
    override func deactivate() {
        super.deactivate()
        rotation = SCNVector4(0, 1, 0, 0)
        removeAllActions()
        curTime = interval
    }
}

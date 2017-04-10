//
//  Rock.swift
//  WoofRunner
//
//  Created by limte on 30/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class RotatingObstacle: Obstacle {
    
    var interval: Float = 1
    var curTime: Float
    var rotateAmount: CGFloat = CGFloat(90).degreesToRadians
    var rotateDuration: Double = 0.3
    
    override init(_ tileModel: TileModel) {
        curTime = interval
        super.init(tileModel)
        positionOffSet = SCNVector3(GameSettings.TILE_WIDTH/2, 0, -GameSettings.TILE_WIDTH/2)
        pivot = SCNMatrix4MakeTranslation(GameSettings.TILE_WIDTH/2, 0, -GameSettings.TILE_WIDTH/2)
        triggerDistance = -5
    }

    func rotateAxe() {
        let action = SCNAction.rotateBy(x: 0, y: rotateAmount, z: 0, duration: rotateDuration)
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

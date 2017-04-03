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
    var currentRotation: Float = 0
    
    override init(_ pos: SCNVector3) {
        super.init(pos)
        tileType = TileType.rotatingAxe
        loadModel(tileType.getModelPath())
        position += SCNVector3(0.5, 0, 0)
        pivot = SCNMatrix4MakeTranslation(0.5, 0, -0.5)
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }
    
    override func update(_ deltaTime: Float) {
        currentRotation += deltaTime
        //rotation = SCNVector4(0, 1, 0, currentRotation)
        /*
        for child in childNodes {
            child.rotation = SCNVector4(0, 1, 0, currentRotation)
        }
 */
    }
}

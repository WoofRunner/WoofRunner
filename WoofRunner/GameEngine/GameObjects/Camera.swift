//
//  Camera.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

class Camera: GameObject {
    
    let height: Float = 5
    let horizontalOffset: Float = 0.5
    let verticalOffset: Float = 5
    
    let xAxis: Float = 1
    let rotationAmount: Float = -0.77
    
    override init() {
        super.init()
        
        camera = SCNCamera()
        position = SCNVector3(x: horizontalOffset, y: height, z: verticalOffset)
        rotation = SCNVector4(xAxis, 0, 0, rotationAmount)
    }
}

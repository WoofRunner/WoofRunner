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
    
    override init() {
        super.init()
        
        camera = SCNCamera()
        position = SCNVector3(x: 0.5, y: 5, z: 5)
        rotation = SCNVector4(1, 0, 0, -0.77)
    }
}

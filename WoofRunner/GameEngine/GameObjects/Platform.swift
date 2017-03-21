//
//  Platform.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

class Platform: GameObject {
    
    let PLATFORM_WIDTH: CGFloat = 5.0
    let PLATFORM_LENGTH: CGFloat = 10.0
    let PLATFORM_HEIGHT: CGFloat = 1.0
    
    
    override init() {
        super.init()
        
        geometry = SCNBox(width: PLATFORM_WIDTH, height: PLATFORM_HEIGHT, length: PLATFORM_LENGTH, chamferRadius: 0.0)
    }
    
    

    
}

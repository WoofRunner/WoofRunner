//
//  Obstacle.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

class Obstacle: Tile {
    
    override init(_ pos: SCNVector3) {
        super.init(pos)
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }
}

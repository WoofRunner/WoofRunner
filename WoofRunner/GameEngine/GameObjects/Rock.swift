//
//  Rock.swift
//  WoofRunner
//
//  Created by limte on 30/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class Rock: Obstacle {
    
    override init(_ pos: SCNVector3) {
        super.init(pos)
        tileType = TileType.rock
        loadModel(tileType.getModelPath())
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }
}

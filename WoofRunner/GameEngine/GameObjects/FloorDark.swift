//
//  FloorDark.swift
//  WoofRunner
//
//  Created by limte on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit


class FloorDark : Platform {
    
    override init(_ pos: SCNVector3) {
        super.init(pos)
        loadModel("art.scnassets/floor_dark.scn")
        
        tileType = TileType.floorDark
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }
}

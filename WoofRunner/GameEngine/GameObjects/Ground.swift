//
//  Ground.swift
//  WoofRunner
//
//  Created by limte on 22/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

enum GroundType {
    case soil
    case grass
}

class Ground : Tile {

    override init(_ pos: SCNVector3) {
        super.init(pos)
        geometry = SCNBox(width: Tile.TILE_WIDTH, height: Tile.TILE_WIDTH, length: Tile.TILE_WIDTH, chamferRadius: 0.05)
        tileType = TileType.ground
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }




}

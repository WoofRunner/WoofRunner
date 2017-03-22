//
//  Tile.swift
//  WoofRunner
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

enum TileType {
    case ground
    case obstacle
}

class Tile: GameObject {
    static let TILE_WIDTH: CGFloat = 1.0
    
    var delegate: PoolManager?
    
    var tileType: TileType = TileType.ground
    
    init(_ pos: SCNVector3) {
        super.init()
        position = pos
        isTickEnabled = true
    }
    
    override convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }

    override func update(_ deltaTime: Float) {
        if worldPosition.z > 2 {
            //destroy()
            delegate?.poolTile(self)
        }
    }
}

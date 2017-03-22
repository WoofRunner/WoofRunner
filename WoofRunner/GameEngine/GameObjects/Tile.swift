//
//  Tile.swift
//  WoofRunner
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class Tile: GameObject {
    static let TILE_WIDTH: CGFloat = 1.0
    
    var delegate: PoolManager?
    
    init(_ pos: SCNVector3) {
        super.init()
        geometry = SCNBox(width: Tile.TILE_WIDTH, height: Tile.TILE_WIDTH, length: Tile.TILE_WIDTH, chamferRadius: 0.05)
        position = pos
        isTickEnabled = true
    }
    
    override convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }

    override func update(_ deltaTime: Float) {
        if worldPosition.z > 2 {
            destroy()
            delegate?.poolTile(self)
        }
    }
}

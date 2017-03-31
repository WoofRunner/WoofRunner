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
    static let TILE_WIDTH: Float = 1
    
    var delegate: PoolManager?
    
    var tileType: TileType = TileType.none
    
    var autoDestroyPositionZ: Float = 5
    
    var triggerDistance: Float = 0
    var isTriggered: Bool = false
    
    
    
    init(_ pos: SCNVector3) {
        super.init()
        position = pos
        isTickEnabled = true
    }
    
    override convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }

    override func update(_ deltaTime: Float) {
        if worldPosition.z > autoDestroyPositionZ {
            delegate?.poolTile(self)
        }
        
        if worldPosition.z > triggerDistance {
            isTriggered = true
            triggered()
        }
    }
    
    func triggered() {
    }
    
    override func deactivate() {
        super.deactivate()
        isTriggered = false
    }
}

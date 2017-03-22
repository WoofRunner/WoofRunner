//
//  PoolManager.swift
//  WoofRunner
//
//  Created by limte on 22/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class PoolManager {

    let NUM_OF_TILES = 100
    
    var availableTiles: [Tile] = []
    var inUseTiles: [Tile] = []
    
    let parentNode: GameObject
    
    // deactivate collision
    // extension poolable
    
    init(_ parentNode: GameObject) {
        self.parentNode = parentNode
        for _ in 0..<NUM_OF_TILES {
            let tile = Tile()
            World.spawnGameObject(tile, parentNode)
            poolTile(tile)
        }
    }

    public func getTile() -> Tile {
        if !availableTiles.isEmpty {
            let tile = availableTiles.removeFirst()
            tile.isHidden = false
            inUseTiles.append(tile)
            return tile
        }
        print("create")
        let tile = Tile()
        World.spawnGameObject(tile, parentNode)
        inUseTiles.append(tile)
        return tile
    }

    public func poolTile(_ tile: Tile) {
        tile.isHidden = true
        tile.position = SCNVector3(-100, 100, -100)
        inUseTiles.remove(object: tile)
        availableTiles.append(tile)
    }

    
    
}

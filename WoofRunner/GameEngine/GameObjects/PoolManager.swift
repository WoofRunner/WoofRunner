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

    let NUM_OF_TILES = 70
    
    var availableTiles: [Tile] = []
    var inUseTiles: [Tile] = []
    
    let parentNode: GameObject
    
    init(_ parentNode: GameObject) {
        self.parentNode = parentNode
        for _ in 0..<NUM_OF_TILES {
            let tile = createNewTile(TileType.floor)
            poolTile(tile)
        }
    }

    public func getTile(_ tileType: TileType) -> Tile {
        guard let tile = findAvailableTile(tileType) else {
            let newTile = createNewTile(tileType)
            inUseTiles.append(newTile)
            return newTile
        }
        
        
        tile.activate()
        inUseTiles.append(tile)
        return tile
    }

    public func poolTile(_ tile: Tile) {
        tile.deactivate()
        inUseTiles.remove(object: tile)
        availableTiles.append(tile)
    }

    private func findAvailableTile(_ tileType: TileType) -> Tile? {
        for tile in availableTiles {
            if tile.tileType == tileType {
                availableTiles.remove(object: tile)
                return tile
            }
        }
        return nil
    }
    
    private func createNewTile(_ tileType: TileType) -> Tile {
        let tile = Platform()
        World.spawnGameObject(tile, parentNode)
        tile.delegate = self
        return tile
    }
}

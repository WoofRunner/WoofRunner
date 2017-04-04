//
//  PoolManager.swift
//  WoofRunner
//
//  Created by limte on 22/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class PoolManager: TileDelegate {

    var availableTiles: [Tile] = []
    var inUseTiles: [Tile] = []
    
    let parentNode: GameObject
    
    init(_ parentNode: GameObject) {
        self.parentNode = parentNode
    }

    public func getTile(_ tileType: TileType) -> Tile? {
        guard let tile = findAvailableTile(tileType) else {
            guard let newTile = createNewTile(tileType) else { return nil }
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
    
    private func createNewTile(_ tileType: TileType) -> Tile? {
        guard let tile = TileFactory.sharedInstance.createTile(tileType) else {
            return nil
        }
        
        World.spawnGameObject(tile, parentNode)
        tile.delegate = self
        return tile
    }
    
    func onTileDestroy(_ tile: Tile) {
        poolTile(tile)
    }
    
    func destroyAllActiveTiles() {
        for tile in inUseTiles {
            tile.destroy()
        }
    }
}

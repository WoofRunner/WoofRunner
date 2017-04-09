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
    
    let NUM_FLOOR = 70
    
    var availableTiles: [Tile] = []
    var inUseTiles: [Tile] = []
    
    let parentNode: GameObject
    
    init(_ parentNode: GameObject) {
        self.parentNode = parentNode
        
        /*
        for _ in 0..<NUM_FLOOR/2 {
            poolTile(createNewTile(TileType.floorDark)!)
        }
        for _ in 0..<NUM_FLOOR/2 {
            poolTile(createNewTile(TileType.floorLight)!)
        }
        for _ in 0..<10 {
            poolTile(createNewTile(TileType.rock)!)
        }
 */
    }

    public func getTile(_ tileModel: TileModel) -> Tile? {
        guard let tile = findAvailableTile(tileModel) else {
            guard let newTile = createNewTile(tileModel) else { return nil }
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

    private func findAvailableTile(_ tileModel: TileModel) -> Tile? {
        for tile in availableTiles {
            if tile.equal(tileModel: tileModel) {
                availableTiles.remove(object: tile)
                return tile
            }
        }
        return nil
    }
    
    private func createNewTile(_ tileModel: TileModel) -> Tile? {
        guard let tile = TileFactory.sharedInstance.createTile(tileModel) else {
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

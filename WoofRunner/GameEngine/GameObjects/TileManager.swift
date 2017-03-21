//
//  PlatformManager.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

class TileManager: GameObject {
    var platforms: [GameObject] = []
    
    var COL_COUNT: Int = 5
    var ROW_COUNT: Int = 20
    
    var tilesData2: [[Int]] = [[0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0],
                              [1, 0, 0, 0, 1],
                              [0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0],
                              [0, 1, 0, 1, 0],
                              [0, 0, 0, 0, 0]]
    
    var tilesData: [[Int]] = [[1, 0, 1, 0, 1],
                              [1, 0, 1, 0, 1],
                              [1, 0, 1, 0, 1],
                              [1, 0, 1, 0, 1],
                              [1, 0, 1, 0, 1],
                              [1, 0, 1, 0, 1],
                              [1, 0, 1, 0, 1],
                              [1, 0, 1, 0, 1],
                              [1, 0, 1, 0, 1],
                              [1, 0, 1, 0, 1],
                              [1, 0, 1, 0, 1]]
    
    var tiles: [Tile] = []
    
    override init() {
        super.init()
        spawnTiles(SCNVector3(0, -1, -10))
        isTickEnabled = true
        position = SCNVector3(x: position.x, y: position.y, z: position.z + 2)
    }
    
    func spawnTiles(_ pos: SCNVector3) {
        for row in 0..<ROW_COUNT {
            for col in 0..<COL_COUNT {
                World.spawnGameObject(Tile(SCNVector3(x: (Float)(col) * Float(Tile.TILE_WIDTH) - 2.0, y: -1, z: -(Float)(row) * Float(Tile.TILE_WIDTH))), self)
                
                if tilesData2[row % tilesData2.count][col] == 1 {
                    World.spawnGameObject(Obstacle(SCNVector3(x: (Float)(col) * Float(Tile.TILE_WIDTH) - 2.0, y: 0, z: -(Float)(row) * Float(Tile.TILE_WIDTH))), self)
                }
            }
        }
    }
    
    override func update(_ deltaTime: Float) {
        //position = SCNVector3(x: position.x, y: position.y, z: position.z + 0.05)
        
    }
}

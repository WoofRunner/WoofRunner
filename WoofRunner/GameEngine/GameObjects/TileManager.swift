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
                              [1, 0, 0, 1, 1],
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
    
    //var tiles: [Tile] = []
    
    var tailIndex: Int = 0
    var platformTail: Float = 0
    
    var poolManager: PoolManager?
    
    let testCube1: GameObject!
    let testCube2: GameObject!
    
    override init() {
        testCube1 = TestCube()
        World.spawnGameObject(testCube1)
        testCube2 = TestCube()
        World.spawnGameObject(testCube2)
        
        super.init()
        poolManager = PoolManager(self)
        isTickEnabled = true
        position = SCNVector3(x: position.x, y: position.y, z: position.z + 2)
        platformTail = position.z - 10.0
        spawnTiles()
        
        testCube1.position.z = 2
        testCube2.position.z = platformTail
    }
    
    func spawnTiles() {
        let curTailIndex = tailIndex
        
        for row in curTailIndex..<ROW_COUNT {
            let rowPosition = calculateIndexPosition(row, 0)
            let worldRowPosition = convertPosition(rowPosition, to: nil)

            if worldRowPosition.z < platformTail {
                break
            }
            tailIndex += 1
            
            for col in 0..<COL_COUNT {
                let tile = poolManager?.getTile()
                //let tile = Tile()
                tile!.position = calculateTilePosition(row, col)
                //tiles.append(tile)
                //World.spawnGameObject(tile, self)
                if tilesData2[row % tilesData2.count][col] == 1 {
                    World.spawnGameObject(Obstacle(calculateObstaclePosition(row, col)), self)
                }
            }
        }
    }
    
    private func calculateTilePosition(_ row: Int, _ col: Int) -> SCNVector3 {
        var position = calculateIndexPosition(row, col)
        position.y = -1
        return position
    }
    
    private func calculateObstaclePosition(_ row: Int, _ col: Int) -> SCNVector3 {
        return calculateIndexPosition(row, col)
    }
    
    private func calculateIndexPosition(_ row: Int, _ col: Int) -> SCNVector3 {
        return SCNVector3(x: (Float)(col) * Float(Tile.TILE_WIDTH) - 2.0, y: 0, z: -(Float)(row) * Float(Tile.TILE_WIDTH))
    }
    
    override func update(_ deltaTime: Float) {
        position = SCNVector3(x: position.x, y: position.y, z: position.z + 0.05)

        spawnTiles()
    }
}



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
    var COL_COUNT: Int = 5
    var ROW_COUNT: Int = 100
    
    var obstacleData: [[Int]] = [[1, 0, 0, 0, 0],
                              [1, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0],
                              [0, 1, 0, 1, 0],
                              [0, 0, 0, 0, 0],
                              [1, 0, 0, 1, 1],
                              [0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0],
                              [0, 1, 0, 1, 0],
                              [0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0]]
    
    /*
    var platformData: [[Int]] = [[2, 1, 2, 1, 2],
                                 [1, 2, 1, 2, 1],
                                 [2, 1, 2, 1, 2],
                                 [1, 2, 1, 2, 1],
                                 [2, 1, 2, 1, 2],
                                 [1, 2, 1, 2, 1],
                                 [2, 1, 2, 1, 2],
                                 [1, 2, 1, 2, 1],
                                 [2, 1, 2, 1, 2],
                                 [1, 2, 1, 2, 1],
                                 [2, 1, 2, 1, 2],
                                 [1, 2, 1, 2, 1]]
    */
    var platformData: [[Int]] = [[2, 1, 2, 1, 2],
                                 [1, 2, 1, 2, 1],
                                 [2, 1, 2, 1, 2],
                                 [1, 2, 1, 2, 1],
                                 [2, 1, 2, 1, 2],
                                 [0, 0, 1, 0, 0],
                                 [0, 0, 1, 0, 0],
                                 [0, 0, 1, 0, 0],
                                 [2, 1, 2, 1, 2],
                                 [1, 2, 1, 2, 1],
                                 [2, 1, 2, 1, 2],
                                 [1, 2, 1, 2, 1]]
    
    
    var tailIndex: Int = 0
    var platformTail: Float = 0
    
    let TAIL_LENGTH: Float = 21
    let PLATFORM_Z_OFFSET: Float = 3
    
    var poolManager: PoolManager?
    
    override init() {
        super.init()
        poolManager = PoolManager(self)
        isTickEnabled = true
        position = SCNVector3(x: position.x, y: position.y, z: position.z + PLATFORM_Z_OFFSET)
        platformTail = position.z - TAIL_LENGTH
    }
    
    convenience init(obstacleData: [[Int]], platformData: [[Int]]) {
        self.init()
        self.obstacleData = obstacleData
        self.platformData = platformData
    }
    
    func spawnTiles() {
        let curTailIndex = tailIndex
        
        for row in curTailIndex..<ROW_COUNT {
            if !canSpawnRow(row) { break }
            
            tailIndex += 1
            
            for col in 0..<COL_COUNT {
                handleTileSpawning(row: row, col: col)
            }
            
            var deadTrigger = DeadTrigger(calculateTilePosition(row, -1))
            World.spawnGameObject(deadTrigger, self)
            
            deadTrigger = DeadTrigger(calculateTilePosition(row, COL_COUNT))
            World.spawnGameObject(deadTrigger, self)
        }
    }
    
    private func handleTileSpawning(row: Int, col: Int) {
        if platformData[row % platformData.count][col] == 1 {
            let platformTile = poolManager?.getTile(TileType.floorLight)
            platformTile?.position = calculateTilePosition(row, col)
        }
        
        if platformData[row % platformData.count][col] == 2 {
            let platformTile = poolManager?.getTile(TileType.floorDark)
            platformTile?.position = calculateTilePosition(row, col)
        }
        
        if platformData[row % platformData.count][col] == 0 {
            let deadTrigger = DeadTrigger(calculateTilePosition(row, col))
            World.spawnGameObject(deadTrigger, self)
        }
        
        if obstacleData[row % obstacleData.count][col] == 1 {
            let obstacleTile = poolManager?.getTile(TileType.rock)
            obstacleTile?.position = calculateObstaclePosition(row, col)
        }
    }
    
    private func calculateTilePosition(_ row: Int, _ col: Int) -> SCNVector3 {
        var position = calculateIndexPosition(row, col)
        position.y = -Tile.TILE_WIDTH
        return position
    }
    
    private func calculateObstaclePosition(_ row: Int, _ col: Int) -> SCNVector3 {
        return calculateIndexPosition(row, col)
    }
    
    private func calculateIndexPosition(_ row: Int, _ col: Int) -> SCNVector3 {
        return SCNVector3(x: (Float)(col) * Tile.TILE_WIDTH - 2.0, y: 0, z: -(Float)(row) * Tile.TILE_WIDTH)
    }
    
    private func canSpawnRow(_ row: Int) -> Bool {
        let rowPosition = calculateIndexPosition(row, 0)
        let worldRowPosition = convertPosition(rowPosition, to: nil)
        return worldRowPosition.z > platformTail
    }
    
    override func update(_ deltaTime: Float) {
        position = SCNVector3(x: position.x, y: position.y, z: position.z + 0.05)

        spawnTiles()
    }
}



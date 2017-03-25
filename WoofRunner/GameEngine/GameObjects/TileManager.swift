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
                              [0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0],
                              [1, 0, 0, 1, 1],
                              [0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0],
                              [0, 1, 0, 1, 0],
                              [0, 0, 0, 0, 0]]
    
    var platformData: [[Int]] = [[1, 1, 1, 1, 1],
                              [1, 1, 1, 1, 1],
                              [1, 1, 1, 1, 1],
                              [1, 1, 1, 1, 1],
                              [0, 1, 1, 1, 1],
                              [0, 1, 1, 1, 1],
                              [0, 1, 1, 1, 1],
                              [1, 1, 1, 1, 1],
                              [1, 1, 1, 1, 1],
                              [1, 1, 1, 1, 1],
                              [1, 1, 1, 1, 1]]

    var tailIndex: Int = 0
    var platformTail: Float = 0
    let TAIL_LENGTH: Float = 21
    
    var poolManager: PoolManager?

    override init() {
        super.init()
        poolManager = PoolManager(self)
        isTickEnabled = true
        position = SCNVector3(x: position.x, y: position.y, z: position.z + 3)
        platformTail = position.z - TAIL_LENGTH
        //spawnTiles()
    }
    
    convenience init(obstacleData: [[Int]], platformData: [[Int]]) {
        self.init()
        self.obstacleData = obstacleData
        self.platformData = platformData
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
                if platformData[row % platformData.count][col] == 1 {
                    let platformTile = poolManager?.getTile(TileType.floor)
                    platformTile!.position = calculateTilePosition(row, col)
                }
                
                if obstacleData[row % obstacleData.count][col] == 1 {
                    let obstacleTile = poolManager?.getTile(TileType.rock)
                    obstacleTile!.position = calculateObstaclePosition(row, col)

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



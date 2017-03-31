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
    
    var obstacleData: [[Int]] = []
    var platformData: [[Int]] = []
    
    var tailIndex: Int = 0
    var platformTail: Float = 0
    
    let TAIL_LENGTH: Float = 21
    let PLATFORM_Z_OFFSET: Float = 3
    let startPosition: SCNVector3
    
    var poolManager: PoolManager?
    
    var isDebug: Bool = true
    
    
    
    override init() {
        startPosition = SCNVector3(x: 0, y: 0, z: 0 + PLATFORM_Z_OFFSET)
        super.init()
        poolManager = PoolManager(self)
        isTickEnabled = true
        position = startPosition
        platformTail = position.z - TAIL_LENGTH
    }
    
    convenience init(obstacleData: [[Int]], platformData: [[Int]]) {
        self.init()
        
        if isDataValid(obstacleData, platformData) {
            self.obstacleData = obstacleData
            self.platformData = platformData
        } else {
            print("WARNING: Data Loaded are Invalid")
        }
    }
    
    private func isDataValid(_ obstacleData: [[Int]], _ platformData: [[Int]]) -> Bool {
        if obstacleData.count != platformData.count {
            return false
        }
        
        for rowIndex in 0..<obstacleData.count {
            if obstacleData[rowIndex].count != platformData[rowIndex].count {
                return false
            }
        }
        
        return true
    }
    
    func spawnTiles() {
        let curTailIndex = tailIndex
        
        for row in curTailIndex..<ROW_COUNT {
            if !canSpawnRow(row) { break }
            
            tailIndex += 1
            
            for col in 0..<COL_COUNT {
                handleTileSpawning(row: row, col: col)
            }
            
            var tile = poolManager?.getTile(TileType.none)
            tile?.position = calculateTilePosition(row, -1)
            
            tile = poolManager?.getTile(TileType.none)
            tile?.position = calculateTilePosition(row, COL_COUNT)

        }
    }
    
    private func handleTileSpawning(row: Int, col: Int) {
        handlePlatformSpawning(row, col)
        handleObstacleSpawning(row, col)
    }
    
    private func handlePlatformSpawning(_ row: Int, _ col: Int) {
        if let tileType: TileType = TileType(rawValue: platformData[row % platformData.count][col]) {
            let tile = poolManager?.getTile(tileType)
            tile?.position = calculateTilePosition(row, col)
        }
    }
    
    private func handleObstacleSpawning(_ row: Int, _ col: Int) {
        if let tileType: TileType = TileType(rawValue: obstacleData[row % obstacleData.count][col]) {
            if tileType == TileType.none {
                return
            }
            
            let tile = poolManager?.getTile(tileType)
            tile?.position = calculateObstaclePosition(row, col)
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
    
    public func restartLevel() {
        position = startPosition
        platformTail = position.z - TAIL_LENGTH
        poolManager?.destroyAllActiveTiles()
        tailIndex = 0
    }
}



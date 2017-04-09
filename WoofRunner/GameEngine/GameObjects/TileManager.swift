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
    
    enum MoveState {
        case wait
        case moving
        case ended
    }
    
    var moveState: MoveState = MoveState.wait
    
    var obstacleData: [[TileModel?]] = []
    var platformData: [[TileModel?]] = []
    
    var tailIndex: Int = 0
    var platformTail: Float = 0
    
    let TAIL_LENGTH: Float = 22
    let PLATFORM_Z_OFFSET: Float = 3.5

    var poolManager: PoolManager?
    
    var isDebug: Bool = true
    
    let WARNING_INVALID_DATA = "WARNING: Data Loaded are Invalid"
    
    var isMoving: Bool = false
    var delay: Float = 3
    
    var delegate: TileManagerDelegate?
    
    var startPosition: SCNVector3 {
        return SCNVector3(x: 0, y: 0, z: 0 + PLATFORM_Z_OFFSET)
    }
    
    var stopPosition: SCNVector3 {
        return SCNVector3(x: 0, y: 0, z: Float(platformData.count) * GameSettings.TILE_WIDTH)
    }
    
    var percentageCompleted: Float {
        return Float(tailIndex)/Float(obstacleData.count)
    }
    
    override init() {
        super.init()
        poolManager = PoolManager(self)
        isTickEnabled = true
        restartLevel()
    }
    
    /*
    convenience init?(obstacleData: [[Int]], platformData: [[Int]]) {
        self.init()
        
        if isDatasValid(obstacleData, platformData) {
            self.obstacleData = obstacleData
            self.platformData = processPlatformData(platformData)
        } else {
            print(WARNING_INVALID_DATA)
            return nil
        }
    }
*/
    // TODO process platform
    convenience init?(obstacleModels: [[TileModel?]], platformModels: [[TileModel?]]) {
        self.init()

        self.obstacleData = obstacleModels
        self.platformData = platformModels
        /*
        self.obstacleData = obstacleModels.map { columns in
            columns.map { item in
                // Empty obstacle
                guard let type = item?.tileId else {
                    return 0
                }

                return type
            }
        }

        self.platformData = platformModels.map { columns in
            columns.map { item in
                // Empty platform
                guard let type = item?.tileId else {
                    return 0
                }

                // +1 because currently TileType is using 0 for empty tile, while TileModelFactory
                // returns DarkFloor for type 0.
                // TODO: Fix this please.
                return type + 1
            }
        }
 */
    }
    
    public func restartLevel() {
        position = startPosition
        platformTail = position.z - TAIL_LENGTH
        poolManager?.destroyAllActiveTiles()
        tailIndex = 0
        moveState = MoveState.wait
    }
    
    // both obstacle and platform data must have same number of rows and cols
    private func isDatasValid(_ obstacleData: [[Int]], _ platformData: [[Int]]) -> Bool {
        if obstacleData.count != platformData.count {
            return false
        }
        
        if !isDataValid(obstacleData) || !isDataValid(platformData){
            return false
        }

        return true
    }
    
    private func isDataValid(_ data: [[Int]]) -> Bool {
        for rowIndex in 0..<data.count {
            if data[rowIndex].count !=  GameSettings.PLATFORM_COLUMNS {
                return false
            }
        }
        return true
    }
    
    // remove other tiles in the same row as the moving platform
    func processPlatformData(_ data: [[Int]]) -> [[Int]]{
        var data = data
        for rowIndex in 0..<data.count {
            for colIndex in 0..<data[rowIndex].count {
                
                if data[rowIndex][colIndex] == TileType.movingPlatform.rawValue {
                    data[rowIndex] = createEmptyDataRow()
                    data[rowIndex][colIndex] = TileType.movingPlatform.rawValue
                    continue
                }
            }
        }
        return data
    }
    
    func createEmptyDataRow() -> [Int] {
        var array = [Int]()
        for _ in 0..<GameSettings.PLATFORM_COLUMNS {
            array.append(-1)
        }
        return array
    }
    
    func spawnTiles() {
        let curTailIndex = tailIndex
        
        for row in curTailIndex..<platformData.count {
            if !canSpawnRow(row) { break }
            
            tailIndex += 1
            
            for col in 0..<platformData[row].count {
                handleTileSpawning(row: row, col: col)
            }
            
            //appendDeadTriggers(row)
        }
    }
    
    private func handleTileSpawning(row: Int, col: Int) {
        handlePlatformSpawning(row, col)
        handleObstacleSpawning(row, col)
    }
    
    private func handlePlatformSpawning(_ row: Int, _ col: Int) {
        guard let tileModel: TileModel = platformData[row][col] else { return }
        let tile = poolManager?.getTile(tileModel)
        tile?.setPositionWithOffset(position: calculateTilePosition(row, col))
    }
    
    private func handleObstacleSpawning(_ row: Int, _ col: Int) {
        guard let tileModel: TileModel = obstacleData[row][col] else { return }
        let tile = poolManager?.getTile(tileModel)
        tile?.setPositionWithOffset(position: calculateObstaclePosition(row, col))
    }
    
    /*
    private func appendDeadTriggers(_ row: Int) {
        var tile = poolManager?.getTile(TileType.none)
        tile?.setPositionWithOffset(position: calculateTilePosition(row, -1))
        
        tile = poolManager?.getTile(TileType.none)
        tile?.setPositionWithOffset(position: calculateTilePosition(row, platformData[row].count))
    }
    */
    
    private func calculateTilePosition(_ row: Int, _ col: Int) -> SCNVector3 {
        var position = calculateIndexPosition(row, col)
        position.y = -GameSettings.TILE_WIDTH
        return position
    }
    
    private func calculateObstaclePosition(_ row: Int, _ col: Int) -> SCNVector3 {
        return calculateIndexPosition(row, col)
    }
    
    private func calculateIndexPosition(_ row: Int, _ col: Int) -> SCNVector3 {
        return SCNVector3(x: (Float)(col) * GameSettings.TILE_WIDTH - Float(GameSettings.PLATFORM_COLUMNS/2), y: 0, z: -(Float)(row) * GameSettings.TILE_WIDTH)
    }
    
    private func canSpawnRow(_ row: Int) -> Bool {
        let rowPosition = calculateIndexPosition(row, 0)
        let worldRowPosition = convertPosition(rowPosition, to: nil)
        return worldRowPosition.z > platformTail
    }

    private func mapToTileType(_ model: TileModel) -> Int {
        return model.tileId
    }
    
    override func update(_ deltaTime: Float) {
        delay -= deltaTime
        
        switch moveState {
        case .wait:
            if delay < 0 {
                moveState = MoveState.moving
            }
            
        case .moving:
            //position = SCNVector3(x: position.x, y: position.y, z: position.z + 4.5 * deltaTime)
            
            if position.z > stopPosition.z {
                moveState = MoveState.ended
                delegate?.onTileManagerEnded()
            }
            
        case .ended:
            break
        }

        spawnTiles()
    }
}



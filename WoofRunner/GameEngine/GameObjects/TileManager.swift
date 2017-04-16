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
    
    private enum MoveState {
        case wait
        case moving
        case ended
    }
    
    private var obstacleData: [[TileModel?]] = []
    private var platformData: [[TileModel?]] = []
    
    private var moveState: MoveState = MoveState.wait
    private var platformSpeed: Float = 6
    private var isMoving: Bool = false
    private var delay: Float = 2
    
    private var tailIndex: Int = 0
    private var platformTail: Float = 0
    private let TAIL_LENGTH: Float = 22
    private let PLATFORM_Z_OFFSET: Float = 3.5
    
    private var poolManager: PoolManager?
    private var NUM_ROWS_TO_POOL = 40
    
    private var isDebug: Bool = true
    
    private let WARNING_INVALID_DATA = "WARNING: Data Loaded are Invalid"
    private let WARNING_CANT_FIND_DEAD_TRIGGER = "WARNING: Cant Find Dead Trigger"
    
    public var delegate: TileManagerDelegate?
    
    private let KILL_PLATFORM_NAME = GameSettings.KILL_PLATFORM_NAME
    
    private var deadTriggerModel: TileModel? {
        return TileModelFactory.sharedInstance.findTileModel(name: KILL_PLATFORM_NAME)
    }
    
    private var startPosition: SCNVector3 {
        return SCNVector3(x: 0, y: 0, z: 0 + PLATFORM_Z_OFFSET)
    }
    
    private var stopPosition: SCNVector3 {
        return SCNVector3(x: 0, y: 0, z: Float(platformData.count) * GameSettings.TILE_WIDTH)
    }
    
    public var percentageCompleted: Float {
        return Float(tailIndex)/Float(obstacleData.count)
    }
    
    override init() {
        super.init()
        poolManager = PoolManager(self)
        isTickEnabled = true
        restartLevel()
    }
    
    convenience init?(obstacleModels: [[TileModel?]], platformModels: [[TileModel?]]) {
        self.init()

        if isDatasValid(obstacleData, platformData) {
            self.obstacleData = obstacleModels
            self.platformData = processPlatformData(platformModels)
        } else {
            print(WARNING_INVALID_DATA)
            return nil
        }
        initPooling()
    }

    public func restartLevel() {
        position = startPosition
        platformTail = position.z - TAIL_LENGTH
        poolManager?.destroyAllActiveTiles()
        tailIndex = 0
        moveState = MoveState.wait
        spawnTiles()
    }
    
    private func initPooling() {
        poolTiles()
        poolManager?.destroyAllActiveTiles()
    }
    
    // both obstacle and platform data must have same number of rows and cols
    private func isDatasValid(_ obstacleData: [[TileModel?]], _ platformData: [[TileModel?]]) -> Bool {
        if obstacleData.count != platformData.count {
            return false
        }
        
        if !isDataValid(obstacleData) || !isDataValid(platformData){
            return false
        }

        return true
    }
    
    private func isDataValid(_ data: [[TileModel?]]) -> Bool {
        for rowIndex in 0..<data.count {
            if data[rowIndex].count !=  GameSettings.PLATFORM_COLUMNS {
                return false
            }
        }
        return true
    }
    
    // remove other tiles in the same row as the moving platform
    private func processPlatformData(_ data: [[TileModel?]]) -> [[TileModel?]]{
        var data = data
        for rowIndex in 0..<data.count {
            for colIndex in 0..<data[rowIndex].count {
                
                if data[rowIndex][colIndex] == nil {
                    data[rowIndex][colIndex] = deadTriggerModel
                    continue
                }
                
                let platformModel = data[rowIndex][colIndex] as? PlatformModel
                if platformModel?.platformBehaviour == PlatformBehaviour.moving {
                    let tempPlatformModel = platformModel
                    data[rowIndex] = createEmptyDataRow()
                    data[rowIndex][colIndex] = tempPlatformModel
                    break
                }
                
            }
        }
        return data
    }
    
    private func createEmptyDataRow() -> [TileModel?] {
        var array = [TileModel?]()
        for _ in 0..<GameSettings.PLATFORM_COLUMNS {
            array.append(nil)
        }
        return array
    }
    
    private func spawnTiles() {
        let curTailIndex = tailIndex
        
        for row in curTailIndex..<platformData.count {
            if !canSpawnRow(row) { break }
            
            tailIndex += 1
            
            for col in 0..<platformData[row].count {
                handleTileSpawning(row: row, col: col)
            }
            
            appendDeadTriggers(row)
        }
    }
    
    private func poolTiles() {
        let length = min(NUM_ROWS_TO_POOL, platformData.count)

        for row in 0..<length {
            for col in 0..<platformData[row].count {
                handleTileSpawning(row: row, col: col)
            }
            appendDeadTriggers(row)
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

    private func appendDeadTriggers(_ row: Int) {
        addDeadTrigger(row: row, col: -1)
        addDeadTrigger(row: row, col: platformData[row].count)
    }
    
    private func addDeadTrigger(row: Int, col: Int) {
        guard let deadTriggerModel = deadTriggerModel else {
            print(WARNING_CANT_FIND_DEAD_TRIGGER)
            return
        }
        let tile = poolManager?.getTile(deadTriggerModel)
        tile?.setPositionWithOffset(position: calculateTilePosition(row, col))
    }
    
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

    override func update(_ deltaTime: Float) {
        delay -= deltaTime
        
        switch moveState {
        case .wait:
            if delay < 0 {
                moveState = MoveState.moving
            }
            
        case .moving:
            position = SCNVector3(x: position.x, y: position.y, z: position.z + platformSpeed * deltaTime)
            
            if position.z > stopPosition.z {
                moveState = MoveState.ended
                delegate?.onTileManagerEnded()
            }
            
        case .ended:
            break
        }

        spawnTiles()
    }
    
    public func stopMoving() {
        moveState = MoveState.ended
    }
}



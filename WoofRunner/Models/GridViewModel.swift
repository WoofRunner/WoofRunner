//
//  TileViewModel.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 22/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SceneKit
import RxSwift
import RxCocoa

class GridViewModel {

    var gridPos: Position
    var position = Variable<SCNVector3>(SCNVector3(0, 0, 0))
    var size = Variable<Float>(1.0)
    var platformType = Variable<TileType>(.none)
    var obstacleType = Variable<TileType>(.none)
    var shouldRender = Variable<Bool>(false)
    
    static var colors = [UIColor.blue, UIColor.red, UIColor.lightGray]
    
    init (row: Int, col: Int) {
        self.gridPos = Position(row: row, col: col)
        self.position.value = SCNVector3(Float(gridPos.getCol()) * Tile.TILE_WIDTH, Float(gridPos.getRow()) * Tile.TILE_WIDTH, 0)
        self.size = Variable<Float>(Float(Tile.TILE_WIDTH))
    }
    
    convenience init() {
        self.init(row: 0, col: 0)
    }
    
    func setPlatform(_ platform: TileType) {
        // Add Platform
        self.platformType.value = platform
    }
    
    // Also removes obstacle
    func removePlatform() {
        platformType.value = .none
        obstacleType.value = .none
    }
    
    func setObstacle(_ obstacle: TileType) {
        guard platformType.value != TileType.none else {
            debugPrint("Error: Adding obstacle to grid without platform")
            return
        }
        // Add Obstacle
        self.obstacleType.value = obstacle
    }
    
    func removeObstacle() {
        obstacleType.value = .none
    }
}

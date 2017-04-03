//
//  TileViewModel.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 22/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import RxSwift
import RxCocoa

class GridViewModel {
    
    static var modelNodeName = "modelNode"
    
    var gridPos: Variable<Position>
    var size = Variable<Float>(1.0)
    var platformType = Variable<TileType>(.none)
    var obstacleType = Variable<TileType>(.none)
    var shouldRender = Variable<Bool>(false)
    
    init (row: Int, col: Int) {
        self.gridPos = Variable<Position>(Position(row: row, col: col))
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
    
    // Remove top level node; obstacle if any else platform
    func removeTop() {
        guard obstacleType.value == .none else {
            return removeObstacle()
        }
        return removePlatform()
    }
}

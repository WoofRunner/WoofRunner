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
    
    var position = Variable<SCNVector3>(SCNVector3(0, 0, 0))
    var size = Variable<Float>(1.0)
    var platformType = Variable<TileType>(.none)
    var obstacleType = Variable<TileType>(.none)
    var shouldRender = Variable<Bool>(false)
    
    static var colors = [UIColor.blue, UIColor.red, UIColor.lightGray]
    
    init (_ position: SCNVector3) {
        self.position.value = position
        self.size = Variable<Float>(Float(Tile.TILE_WIDTH))
    }
    
    init (_ platform: Platform) {
        self.position.value = platform.position
        self.size = Variable<Float>(Float(Tile.TILE_WIDTH))
        setPlatform(platform.tileType)
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

class PlatformStub {
    
    var position: SCNVector3
    var size: Float
    var platformType: TileType
    
    init(position: SCNVector3, platformType: TileType) {
        self.position = position
        self.size = Float(Tile.TILE_WIDTH)
        self.platformType = platformType
    }
}

class ObstacleStub {
    
    var position: SCNVector3
    var obstacleType: TileType
    
    init(position: SCNVector3, obstacleType: TileType) {
        self.position = position
        self.obstacleType = obstacleType
    }
}

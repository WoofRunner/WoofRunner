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
    var groundType = Variable<GroundType?>(nil)
    var obstacleType = Variable<ObstacleType?>(nil)
    var shouldRender = Variable<Bool>(false)
    
    static var colors = [UIColor.blue, UIColor.red, UIColor.lightGray]
    
    init (_ position: SCNVector3) {
        self.position.value = position
        self.size = Variable<Float>(Float(Tile.TILE_WIDTH))
    }
    
    func setGround(_ ground: GroundType) {
        // Add ground
        self.groundType.value = ground
    }
    
    // Also removes obstacle
    func removeGround() {
        groundType.value = nil
        obstacleType.value = nil
    }
    
    func setObstacle(_ obstacle: ObstacleType) {
        guard let _ = groundType.value else {
            debugPrint("Error: Adding obstacle to grid without ground")
            return
        }
        // Add Obstacle
        self.obstacleType.value = obstacle
    }
    
    func removeObstacle() {
        obstacleType.value = nil
    }
}

class GroundStub {
    
    var position: SCNVector3
    var size: Float
    var groundType: GroundType?
    
    init(position: SCNVector3, groundType: GroundType?) {
        self.position = position
        self.size = Float(Tile.TILE_WIDTH)
        self.groundType = groundType
    }
}

class ObstacleStub {
    
    var position: SCNVector3
    var obstacleType: ObstacleType?
    
    init(position: SCNVector3, obstacleType: ObstacleType?) {
        self.position = position
        self.obstacleType = obstacleType
    }
}

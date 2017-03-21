//
//  PlatformManager.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

class PlatformManager: GameObject {
    var platforms: [GameObject] = []
    
    var tilesData2: [[Int]] = [[0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0],
                              [0, 1, 0, 1, 0],
                              [0, 0, 0, 0, 0],
                              [1, 0, 1, 0, 1],
                              [0, 0, 0, 0, 0],
                              [0, 1, 0, 1, 0],
                              [0, 0, 0, 0, 0],
                              [1, 0, 1, 0, 1],
                              [0, 0, 0, 0, 0],
                              [0, 1, 0, 1, 0]]
    
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
    
    var tiles: [Tile] = []
    
    override init() {
        super.init()
        spawnPlatform(SCNVector3(0, -1, -10))
        spawnPlatform(SCNVector3(0, -1, -10-10))
        spawnPlatform(SCNVector3(0, -1, -10-2*10))
        isTickEnabled = true
    }
    
    func spawnPlatform(_ pos: SCNVector3) {
        let platform = Platform()
        platform.position = pos
        World.spawnGameObject(platform)
        platforms.append(platform)
    
        var square2 = Obstacle(SCNVector3(x: 0.0, y: 1.0, z: 2.0))
        World.spawnGameObject(square2, platform)
        
        square2 = Obstacle(SCNVector3(x: 2, y: 1.0, z: 2.0))
        World.spawnGameObject(square2, platform)
        
        square2 = Obstacle(SCNVector3(x: -2, y: 1.0, z: 2.0))
        World.spawnGameObject(square2, platform)
        
        square2 = Obstacle(SCNVector3(x: 1, y: 1.0, z: -1.0))
        World.spawnGameObject(square2, platform)
        
        square2 = Obstacle(SCNVector3(x: -1, y: 1.0, z: -1.0))
        World.spawnGameObject(square2, platform)
        
        square2 = Obstacle(SCNVector3(x: 0, y: 1.0, z: -4.0))
        World.spawnGameObject(square2, platform)
        
        square2 = Obstacle(SCNVector3(x: 2, y: 1.0, z: -4.0))
        World.spawnGameObject(square2, platform)
        
        square2 = Obstacle(SCNVector3(x: -2, y: 1.0, z: -4.0))
        World.spawnGameObject(square2, platform)

    }
    
    override func update(_ deltaTime: Float) {
        for platform in platforms {
            platform.position = SCNVector3(x: platform.position.x, y: platform.position.y, z: platform.position.z + 0.05)
        }
    }
}

//
//  TileFactory.swift
//  WoofRunner
//
//  Created by limte on 4/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

final class TileFactory {
    
    static let sharedInstance: TileFactory = TileFactory()

    let WARNING_INVALID_TILE = "WARNING: Cant create tile, TileType: "
    
    private init() {
    }
    
    public func createTile(_ tileModel: TileModel) -> Tile? {

        if let platformModel = tileModel as?  PlatformModel {
            return createPlatformTile(platformModel)
        }
        
        if let obstacleModel = tileModel as?  ObstacleModel {
            return createObstacleTile(obstacleModel)
        }
        
        return nil
    }

    private func createPlatformTile(_ platformModel: PlatformModel) -> Platform {
        var platform: Platform
        
        switch platformModel.platformBehaviour {
        case .allowsJumping:
            platform = JumpPlatform(platformModel)
        
        case .kill:
            platform = DeadTriggerPlatform(platformModel)
            
        case .moving:
            platform = MovingPlatform(platformModel)
            
        case .none:
            platform = Platform(platformModel)
        
        }
        return platform
    }
    
    private func createObstacleTile(_ obstacleModel: ObstacleModel) -> Obstacle {
        var obstacle: Obstacle
        
        switch obstacleModel.obstacleBehaviour {
        case .jumping:
            obstacle = JumpingObstacle(obstacleModel)
            
        case .rotating:
            obstacle = RotatingObstacle(obstacleModel)
            
        case .none:
            obstacle = Rock(obstacleModel)
            
        }
        return obstacle
    }
}

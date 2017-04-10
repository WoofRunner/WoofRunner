//
//  TileModelFactory.swift
//  WoofRunner
//
//  Created by limte on 7/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

// Tile Model Factory allows creation of new Tile Model 
// Store a list of created TileModel

public final class TileModelFactory {
    
    public static let sharedInstance: TileModelFactory = TileModelFactory()
    
	private(set) var tileModels: [TileModel] = []
    
    private init() {
        createDarkPlatform()
        createLightPlatform()
        createMovingPlatform()
        createAllowsJumpingPlatform()
        createStaticObstacle()
        createJumpingObstacle()
        createRotatingAxeObstacle()
        createKillPlatform()
    }

    public func getTile(tileId: Int) -> TileModel? {
        for tileModel in tileModels {
            if tileModel.tileId == tileId {
                return tileModel
            }
        }
        return nil
    }
    
    public func findTileModel(name: String) -> TileModel? {
        for tileModel in tileModels {
            if tileModel.name == name {
                return tileModel
            }
        }
        return nil
    }

    private func createDarkPlatform() {
        let platformModel = PlatformModel(name: "Dark Platform",
                                          scenePath: "art.scnassets/platform/floor_flat_dark.scn",
                                          iconPath: "display-platform-dark",
                                          platformBehaviour: PlatformBehaviour.none)
        
        tileModels.append(platformModel)
    }
    
    private func createLightPlatform() {
        let platformModel = PlatformModel(name: "Light floor",
                                          scenePath: "art.scnassets/platform/floor_flat_light.scn",
                                          iconPath: "display-platform-light",
                                          platformBehaviour: PlatformBehaviour.none)
        
        tileModels.append(platformModel)
    }
    
    private func createMovingPlatform() {
        let platformModel = PlatformModel(name: "Moving Platform",
                                          scenePath: "art.scnassets/movingPlatform.scn",
                                          iconPath: "display-platform-moving",
                                          platformBehaviour: PlatformBehaviour.moving)
        
        tileModels.append(platformModel)
    }
    
    private func createAllowsJumpingPlatform() {
        let platformModel = PlatformModel(name: "Auto Jump",
                                          scenePath: "art.scnassets/cube3.scn",
                                          iconPath: "display-platform-jump",
                                          platformBehaviour: PlatformBehaviour.allowsJumping)
        
        tileModels.append(platformModel)
    }
    
    private func createKillPlatform() {
        let platformModel = PlatformModel(name: "Kill Platform",
                                          scenePath: nil,
                                          iconPath: nil,
                                          platformBehaviour: PlatformBehaviour.kill)
        
        tileModels.append(platformModel)
    }

    private func createStaticObstacle() {
        let obstacleModel = ObstacleModel(name: "Rock",
                                          scenePath: "art.scnassets/rock/rock.scn",
                                          iconPath: "display-obstacle-rock",
                                          obstacleBehaviour: ObstacleBehaviour.none)
        
        tileModels.append(obstacleModel)
    }
    
    private func createJumpingObstacle() {
        let obstacleModel = ObstacleModel(name: "Jumping Obstacle",
                                          scenePath: "art.scnassets/rock/jumpRock.scn",
                                          iconPath: "display-obstacle-jumping",
                                          obstacleBehaviour: ObstacleBehaviour.jumping)
        
        tileModels.append(obstacleModel)
    }
    
    private func createRotatingAxeObstacle() {
        let obstacleModel = ObstacleModel(name: "Rotating Axe",
                                          scenePath: "art.scnassets/rock/rockWithAxe.scn",
                                          iconPath: "display-obstacle-axe",
                                          obstacleBehaviour: ObstacleBehaviour.rotating)
        
        tileModels.append(obstacleModel)
    }
}

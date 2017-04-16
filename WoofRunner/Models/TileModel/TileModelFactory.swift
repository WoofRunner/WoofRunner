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

    // Dark Platform
    let NAME_DARK_PLATFORM = "Dark Platform"
    let SCENE_DARK_PLATFORM = "art.scnassets/platform/floor_flat_dark.scn"
    let ICON_DARK_PLATFORM = "display-platform-dark"
    
    // Light Platform
    let NAME_LIGHT_PLATFORM = "Light floor"
    let SCENE_LIGHT_PLATFORM = "art.scnassets/platform/floor_flat_light.scn"
    let ICON_LIGHT_PLATFORM = "display-platform-light"
    
    // Moving Platform
    let NAME_MOVING_PLATFORM = "Moving Platform"
    let SCENE_MOVING_PLATFORM = "art.scnassets/movingPlatform.scn"
    let ICON_MOVING_PLATFORM = "display-platform-moving"
    
    // Auto Jump
    let NAME_AUTO_JUMP = "Auto Jump"
    let SCENE_AUTO_JUMP = "art.scnassets/cube3.scn"
    let ICON_AUTO_JUMP = "display-platform-jump"
    
    // Kill Platform
    let NAME_KILL_PLATFORM = "Kill Platform"
    
    // Rock
    let NAME_ROCK = "Rock"
    let SCENE_ROCK = "art.scnassets/rock/rock.scn"
    let ICON_ROCK = "display-obstacle-rock"
    
    // Jumping Obstacle
    let NAME_JUMP_OBSTACLE = "Jumping Obstacle"
    let SCENE_JUMP_OBSTACLE = "art.scnassets/rock/jumpRock.scn"
    let ICON_JUMP_OBSTACLE = "display-obstacle-jumping"
    
    // Rotating Axe
    let NAME_ROTATING_AXE = "Rotating Axe"
    let SCENE_ROTATING_AXE = "art.scnassets/rock/rockWithAxe.scn"
    let ICON_ROTATING_AXE = "display-obstacle-axe"
    
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
        let platformModel = PlatformModel(name: NAME_DARK_PLATFORM,
                                          scenePath: SCENE_DARK_PLATFORM,
                                          iconPath: ICON_DARK_PLATFORM,
                                          platformBehaviour: PlatformBehaviour.none)
        tileModels.append(platformModel)
    }
    
    private func createLightPlatform() {
        let platformModel = PlatformModel(name: NAME_LIGHT_PLATFORM,
                                          scenePath: SCENE_LIGHT_PLATFORM,
                                          iconPath: ICON_LIGHT_PLATFORM,
                                          platformBehaviour: PlatformBehaviour.none)
        tileModels.append(platformModel)
    }
    
    private func createMovingPlatform() {
        let platformModel = PlatformModel(name: NAME_MOVING_PLATFORM,
                                          scenePath: SCENE_MOVING_PLATFORM,
                                          iconPath: ICON_MOVING_PLATFORM,
                                          platformBehaviour: PlatformBehaviour.moving)
        tileModels.append(platformModel)
    }
    
    private func createAllowsJumpingPlatform() {
        let platformModel = PlatformModel(name: NAME_AUTO_JUMP,
                                          scenePath: SCENE_AUTO_JUMP,
                                          iconPath: ICON_AUTO_JUMP,
                                          platformBehaviour: PlatformBehaviour.allowsJumping)
        tileModels.append(platformModel)
    }
    
    private func createKillPlatform() {
        let platformModel = PlatformModel(name: NAME_KILL_PLATFORM,
                                          scenePath: nil,
                                          iconPath: nil,
                                          platformBehaviour: PlatformBehaviour.kill)
        tileModels.append(platformModel)
    }
    
    private func createStaticObstacle() {
        let obstacleModel = ObstacleModel(name: NAME_ROCK,
                                          scenePath: SCENE_ROCK,
                                          iconPath: ICON_ROCK,
                                          obstacleBehaviour: ObstacleBehaviour.none)
        tileModels.append(obstacleModel)
    }
    
    private func createJumpingObstacle() {
        let obstacleModel = ObstacleModel(name: NAME_JUMP_OBSTACLE,
                                          scenePath: SCENE_JUMP_OBSTACLE,
                                          iconPath: ICON_JUMP_OBSTACLE,
                                          obstacleBehaviour: ObstacleBehaviour.jumping)
        tileModels.append(obstacleModel)
    }
    
    private func createRotatingAxeObstacle() {
        let obstacleModel = ObstacleModel(name: NAME_ROTATING_AXE,
                                          scenePath: SCENE_ROTATING_AXE,
                                          iconPath: ICON_ROTATING_AXE,
                                          obstacleBehaviour: ObstacleBehaviour.rotating)
        tileModels.append(obstacleModel)
    }
}

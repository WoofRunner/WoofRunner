//
//  TileModelFactory.swift
//  WoofRunner
//
//  Created by limte on 7/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

public final class TileModelFactory {
    
    public static let sharedInstance: TileModelFactory = TileModelFactory()
    
	public var tileModels: [TileModel] = []
    
    private init() {
        createDarkPlatform()
        createLightPlatform()
        createMovingPlatform()
        createAllowsJumpingPlatform()
        
        createStaticObstacle()
        createJumpingObstacle()
        createRotatingAxeObstacle()
    }

    public func getTile(id: Int) -> TileModel {
        return tileModels[id]
    }

    func createDarkPlatform() {
        let platformModel = PlatformModel(name: "Dark Platform",
                                          scenePath: "art.scnassets/platform/floor_flat_dark.scn",
                                          iconPath: "platform-placeholder",
                                          platformBehaviour: PlatformBehaviour.none)
        
        tileModels.append(platformModel)
    }
    
    func createLightPlatform() {
        let platformModel = PlatformModel(name: "Light floor",
                                          scenePath: "art.scnassets/platform/floor_flat_light.scn",
                                          iconPath: "obstacle-placeholder1",
                                          platformBehaviour: PlatformBehaviour.none)
        
        tileModels.append(platformModel)
    }
    
    func createMovingPlatform() {
        let platformModel = PlatformModel(name: "Moving Platform",
                                          scenePath: "art.scnassets/movingPlatform.scn",
                                          iconPath: "testCat",
                                          platformBehaviour: PlatformBehaviour.moving)
        
        tileModels.append(platformModel)
    }
    
    func createAllowsJumpingPlatform() {
        let platformModel = PlatformModel(name: "Jumping Platform",
                                          scenePath: "art.scnassets/cube3.scn",
                                          iconPath: "obstacle-placeholder2",
                                          platformBehaviour: PlatformBehaviour.allowsJumping)
        
        tileModels.append(platformModel)
    }
    
    func createKillPlatform() {
        let platformModel = PlatformModel(name: "Kill Platform",
                                          scenePath: nil,
                                          iconPath: nil,
                                          platformBehaviour: PlatformBehaviour.kill)
        
        tileModels.append(platformModel)
    }

    func createStaticObstacle() {
        let obstacleModel = ObstacleModel(name: "Rock",
                                          scenePath: "art.scnassets/rock/rock.scn",
                                          iconPath: "obstacle-placeholder2",
                                          obstacleBehaviour: ObstacleBehaviour.none)
        
        tileModels.append(obstacleModel)
    }
    
    func createJumpingObstacle() {
        let obstacleModel = ObstacleModel(name: "Jumping Obstacle",
                                          scenePath: "art.scnassets/rock/jumpRock.scn",
                                          iconPath: "testCat",
                                          obstacleBehaviour: ObstacleBehaviour.jumping)
        
        tileModels.append(obstacleModel)
    }
    
    func createRotatingAxeObstacle() {
        let obstacleModel = ObstacleModel(name: "Rotating Axe",
                                          scenePath: "art.scnassets/rock/rockWithAxe.scn",
                                          iconPath: "testCat",
                                          obstacleBehaviour: ObstacleBehaviour.rotating)
        
        tileModels.append(obstacleModel)
    }

    /*
    public func findPlatformModel(name: String) -> {
        let platformModels = tileModels.filter{ $0 is PlatformModel && $0.name == name}
    }
 */
}

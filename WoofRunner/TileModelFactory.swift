//
//  TileModelFactory.swift
//  WoofRunner
//
//  Created by limte on 7/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

final class TileModelFactory {
    
    static let sharedInstance: TileModelFactory = TileModelFactory()

	static var tileModels: [TileModel] = []
    
    private init() {
        createDarkPlatform()
        createLightPlatform()
        createMovingPlatform()
        createAllowsJumpingPlatform()
        
        createStaticObstacle()
        createJumpingObstacle()
        createRotatingAxeObstacle()
    }

    public static func getTile(id: Int) -> TileModel {
        return TileModelFactory.tileModels[id]
    }

    func createDarkPlatform() {
        let platformModel = PlatformModel(name: "Dark Platform",
                                          scenePath: "art.scnassets/floor_dark.scn",
                                          iconPath: "platform-placeholder",
                                          platformBehaviour: PlatformBehaviour.none)
        
        TileModelFactory.tileModels.append(platformModel)
    }
    
    func createLightPlatform() {
        let platformModel = PlatformModel(name: "Light floor",
                                          scenePath: "art.scnassets/floor_light.scn",
                                          iconPath: "obstacle-placeholder1",
                                          platformBehaviour: PlatformBehaviour.none)
        
        TileModelFactory.tileModels.append(platformModel)
    }
    
    func createMovingPlatform() {
        let platformModel = PlatformModel(name: "Moving Platform",
                                          scenePath: "art.scnassets/movingPlatform.scn",
                                          iconPath: "testCat",
                                          platformBehaviour: PlatformBehaviour.moving)
        
        TileModelFactory.tileModels.append(platformModel)
    }
    
    func createAllowsJumpingPlatform() {
        let platformModel = PlatformModel(name: "Jumping Platform",
                                          scenePath: "art.scnassets/cube3.scn",
                                          iconPath: "obstacle-placeholder2",
                                          platformBehaviour: PlatformBehaviour.allowsJumping)
        
        TileModelFactory.tileModels.append(platformModel)
    }
    
    func createStaticObstacle() {
        let obstacleModel = ObstacleModel(name: "Jumping Platform",
                                          scenePath: "art.scnassets/cube3.scn",
                                          iconPath: "obstacle-placeholder2",
                                          obstacleBehaviour: ObstacleBehaviour.none)
        
        TileModelFactory.tileModels.append(obstacleModel)
    }
    
    func createJumpingObstacle() {
        let obstacleModel = ObstacleModel(name: "Jumping Obstacle",
                                          scenePath: "art.scnassets/rock/jumpRock.scn",
                                          iconPath: "testCat",
                                          obstacleBehaviour: ObstacleBehaviour.jumping)
        
        TileModelFactory.tileModels.append(obstacleModel)
    }
    
    func createRotatingAxeObstacle() {
        let obstacleModel = ObstacleModel(name: "Rotating Axe",
                                          scenePath: "art.scnassets/rock/rockWithAxe.scn",
                                          iconPath: "testCat",
                                          obstacleBehaviour: ObstacleBehaviour.rotating)
        
        TileModelFactory.tileModels.append(obstacleModel)
    }

}

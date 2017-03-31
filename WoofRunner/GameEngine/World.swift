//
//  World.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

class World {
    private static var gameEngine: GameEngine?
    
    public static func setUpWorld(_ view: UIView) {
        gameEngine = GameEngine(view)
    }

    public static func spawnGameObject(_ gameObject: GameObject) {
        _ = isGameEngineValid(taskMessage: "Trying to spawn object")
        gameEngine?.spawnGameObject(gameObject)
    }
    
    public static func spawnGameObject(_ gameObject: GameObject, _ parent: GameObject) {
        _ = isGameEngineValid(taskMessage: "Trying to spawn object")
        gameEngine?.spawnGameObject(gameObject, parent)
    }

    public static func registerGestureInput(_ gameObject: GestureDelegate) {
        _ = isGameEngineValid(taskMessage: "Trying to register gesture input")
        gameEngine?.gestureDelegate = gameObject
    }
    
    public static func projectPoint(_ vector: SCNVector3) -> SCNVector3 {
        guard let gameEngine = gameEngine else {
            _ = isGameEngineValid(taskMessage: "Trying to project point")
            return SCNVector3()
        }
        return gameEngine.projectPoint(vector)
    }
    
    public static func unprojectPoint(_ vector: SCNVector3) -> SCNVector3 {
        guard let gameEngine = gameEngine else {
            _ = isGameEngineValid(taskMessage: "Trying to unproject point")
            return SCNVector3()
        }
        return gameEngine.unprojectPoint(vector)
    }
    
    public static func destroyWorld() {
        _ = isGameEngineValid(taskMessage: "Trying to destroy GameEngine")
        gameEngine?.destroyEngine()
    }
    
    private static func isGameEngineValid(taskMessage: String) -> Bool {
        if World.gameEngine == nil {
            print("WARNING: " + taskMessage + "but GameEngine is nil")
            return false
        }
        return true
    }
}

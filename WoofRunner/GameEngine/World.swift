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
    
    static let MSG_SPAWN_OBJECT = "Trying to spawn object"
    static let MSG_REGISTER_INPUT = "Trying to register gesture input"
    static let MSG_PROJECT_POINT = "Trying to project point"
    static let MSG_UNPROJECT_POINT = "Trying to unproject point"
    static let MSG_DESTROY_ENGINE = "Trying to destroy GameEngine"
    static let MSG_WARNING = "WARNING: "
    static let MSG_GAME_ENGINE_NIL = "but GameEngine is nil"
    
    public static func setUpWorld(_ view: UIView) {
        gameEngine = GameEngine(view)
    }

    public static func spawnGameObject(_ gameObject: GameObject) {
        _ = isGameEngineValid(taskMessage: MSG_SPAWN_OBJECT)
        gameEngine?.spawnGameObject(gameObject)
    }
    
    public static func spawnGameObject(_ gameObject: GameObject, _ parent: GameObject) {
        _ = isGameEngineValid(taskMessage: MSG_REGISTER_INPUT)
        gameEngine?.spawnGameObject(gameObject, parent)
    }

    public static func registerGestureInput(_ gameObject: GestureDelegate) {
        _ = isGameEngineValid(taskMessage: )
        gameEngine?.gestureDelegate = gameObject
    }
    
    public static func projectPoint(_ vector: SCNVector3) -> SCNVector3 {
        guard let gameEngine = gameEngine else {
            _ = isGameEngineValid(taskMessage: MSG_PROJECT_POINT)
            return SCNVector3()
        }
        return gameEngine.projectPoint(vector)
    }
    
    public static func unprojectPoint(_ vector: SCNVector3) -> SCNVector3 {
        guard let gameEngine = gameEngine else {
            _ = isGameEngineValid(taskMessage: MSG_UNPROJECT_POINT)
            return SCNVector3()
        }
        return gameEngine.unprojectPoint(vector)
    }
    
    public static func destroyWorld() {
        _ = isGameEngineValid(taskMessage: MSG_DESTROY_ENGINE)
        gameEngine?.destroyEngine()
    }
    
    private static func isGameEngineValid(taskMessage: String) -> Bool {
        if World.gameEngine == nil {
            print(MSG_WARNING + taskMessage + MSG_GAME_ENGINE_NIL)
            return false
        }
        return true
    }
}

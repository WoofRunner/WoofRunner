//
//  World.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

// World is a public class to contain the GameEngine

class World {
    
    private static var gameEngine: GameEngine?
    
    private static let MSG_SPAWN_OBJECT = "Trying to spawn object"
    private static let MSG_REGISTER_INPUT = "Trying to register gesture input"
    private static let MSG_PROJECT_POINT = "Trying to project point"
    private static let MSG_UNPROJECT_POINT = "Trying to unproject point"
    private static let MSG_DESTROY_ENGINE = "Trying to destroy GameEngine"
    private static let MSG_WARNING = "WARNING: "
    private static let MSG_GAME_ENGINE_NIL = " but GameEngine is nil"
    
    public static func setUpWorld(_ view: SCNView) {
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

    public static func setPause(isPaused: Bool) {
        gameEngine?.isPause = isPaused
    }
    
    private static func isGameEngineValid(taskMessage: String) -> Bool {
        if World.gameEngine == nil {
            print(MSG_WARNING + taskMessage + MSG_GAME_ENGINE_NIL)
            return false
        }
        return true
    }
    
    
}

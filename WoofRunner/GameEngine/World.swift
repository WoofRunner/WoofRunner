//
//  World.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

struct CollisionType {
    static let Player = 0x1 << 1
    static let Block = 0x1 << 2
}

class World {

    private static var gameEngine: GameEngine?
    
    public static func setUpWorld(_ view: UIView) {
        gameEngine = GameEngine(view)
    }

    public static func spawnGameObject(_ gameObject: GameObject) {
        guard let gameEngine = gameEngine else {
            print("WARNING: Trying to spawn object but GameEngine is nil")
            return
        }
        gameEngine.spawnGameObject(gameObject)
    }
    
    public static func spawnGameObject(_ gameObject: GameObject, _ parent: GameObject) {
        guard let gameEngine = gameEngine else {
            print("WARNING: Trying to spawn object but GameEngine is nil")
            return
        }
        gameEngine.spawnGameObject(gameObject, parent)
    }

    public static func registerGestureInput(_ gameObject: GestureDelegate) {
        guard let gameEngine = gameEngine else {
            print("WARNING: Trying to register gesture input but GameEngine is nil")
            return
        }
        gameEngine.gestureDelegate = gameObject
    }
    
    public static func projectPoint(_ vector: SCNVector3) -> SCNVector3 {
        guard let gameEngine = gameEngine else {
            print("WARNING: Trying to project point but GameEngine is nil")
            return SCNVector3()
        }
        return gameEngine.projectPoint(vector)
    }
    
    public static func unprojectPoint(_ vector: SCNVector3) -> SCNVector3 {
        guard let gameEngine = gameEngine else {
            print("WARNING: Trying to unproject point but GameEngine is nil")
            return SCNVector3()
        }
        return gameEngine.unprojectPoint(vector)
    }
    
    public static func destroyWorld() {
        guard let gameEngine = gameEngine else {
            print("WARNING: Trying to destroy GameEngine but GameEngine is nil")
            return
        }
        gameEngine.destroyEngine()
    }
}

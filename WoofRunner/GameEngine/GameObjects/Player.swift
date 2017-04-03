//
//  Player.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

class Player: GameObject {
    var startHeight: Float = 0.3
    let PLAYER_TAG = "player"
    var delegate: PlayerDelegate?
    let startPosition: SCNVector3
    
    var isAir: Bool = false
    var jumpHeight: Float = 2
    var jumpSpeed: Float = 2
    var jumpTime: Float = 0

    var isDeadFall: Bool = false
    var deadFallSpeed: Float = 3
    var deadFallLimitY: Float = -3
    
    override init() {
        startPosition = SCNVector3(x: 0.5, y: startHeight, z: 1.5)
        super.init()
        geometry = SCNSphere(radius: 0.3)
        name = PLAYER_TAG
        physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        physicsBody?.contactTestBitMask = CollisionType.Default
        physicsBody?.categoryBitMask = CollisionType.Default

        isTickEnabled = true
        restart()
        World.registerGestureInput(self)
    }
    
    public func restart() {
        isDeadFall = false
        isAir = false
        position = startPosition
        isHidden = false
    }
    
    private func startJump() {
        if isAir {
            return
        }
        jumpTime = 0
        isAir = true
    }
    
    public override func OnCollide(other: GameObject) {
        if other is Platform {
        }
        
        if other is JumpPlatform {
            startJump()
        }
        
        if other is DeadTriggerTile {
            isDeadFall = true
        }
        
        if other is Obstacle {
            isHidden = true
            delegate?.playerDied()
        }
    }
    
    override func update(_ deltaTime: Float) {
        if isDeadFall {
            handleDeadFall(deltaTime)
        } else if isAir {
            handleInAir(deltaTime)
        }
    }
    
    private func handleDeadFall(_ deltaTime: Float) {
        position = SCNVector3(position.x, position.y - deadFallSpeed * deltaTime, position.z)
        
        if position.y < deadFallLimitY {
            destroy()
        }
    }
    
    private func handleInAir(_ deltaTime: Float) {
        jumpTime += deltaTime
        position = SCNVector3(position.x, startHeight + sin(jumpTime * jumpSpeed) * jumpHeight, position.z)
        
        if position.y < startHeight {
            isAir = false
            position.y = startHeight
        }
    }
    
    public override func panGesture(_ gesture: UIPanGestureRecognizer, _ location: CGPoint) {
        if isDeadFall {
            return
        }
        
        let projectedOrigin = World.projectPoint(position)
        let vpWithZ = SCNVector3(x: Float(location.x), y: Float(location.y), z: projectedOrigin.z)
        let worldPoint = World.unprojectPoint(vpWithZ)
        
        position = SCNVector3(worldPoint.x, position.y, position.z)
    }
    
    override func destroy() {
        isHidden = true
        delegate?.playerDied()
    }
}

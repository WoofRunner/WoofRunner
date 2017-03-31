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
    var isAir: Bool = false
    
    var jumpVelocity: SCNVector3 = SCNVector3(0, 1, 0)
    var gravity: SCNVector3 = SCNVector3(0, 0.5, 0)
    
    var curVelocity: SCNVector3 = SCNVector3.zero()
    
    var jumpHeight: Float = 2
    
    var jumpTime: Float = 0
    var jumpSpeed: Float = 2
    
    var startHeight: Float = 0.3
    
    var isDeadFall: Bool = false
    var deadFallSpeed: Float = 3
    
    let PLAYER_TAG = "player"
    
    override init() {
        super.init()
        geometry = SCNSphere(radius: 0.3)
        name = PLAYER_TAG
        position = SCNVector3(x: 0.5, y: startHeight, z: 1.5)
        physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        physicsBody?.contactTestBitMask = CollisionType.Default
        physicsBody?.categoryBitMask = CollisionType.Default
        
        isTickEnabled = true
    }
    
    private func startJump() {
        if isAir {
            return
        }
        jumpTime = 0
        isAir = true
    }
    
    public override func OnCollide(other: GameObject) {
        if other is JumpPlatform {
            startJump()
        }
        
        if other is DeadTrigger {
            isDeadFall = true
        }
        
        if other is Obstacle {
            destroy()
            //startJump()
            print("collide")
        }
    }
    
    override func update(_ deltaTime: Float) {
        if isDeadFall {
            position = SCNVector3(position.x, position.y - deadFallSpeed * deltaTime, position.z)
        } else if isAir {
            jumpTime += deltaTime
            position = SCNVector3(position.x, startHeight + sin(jumpTime * jumpSpeed) * jumpHeight, position.z)
            
            if position.y < startHeight {
                isAir = false
                position.y = startHeight
                
            }
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
}

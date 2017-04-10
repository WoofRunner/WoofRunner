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
    
    var startHeight: Float = 0
    var delegate: PlayerDelegate?
    let startPosition: SCNVector3
    
    var isAir: Bool = false
    var jumpHeight: Float = 2
    var jumpSpeed: Float = 4.4
    var jumpTime: Float = 0

    var isDeadFall: Bool = false
    var deadFallSpeed: Float = 3
    var deadFallLimitY: Float = -3
    
    let PLAYER_MODEL_PATH = "art.scnassets/player.scn"
    
    var targetPosition: SCNVector3 = SCNVector3.zero()
    var targetPositionX: Float
    let lerpSpeed: Float = 15
    
    override init() {
        startPosition = SCNVector3(x: 0.5, y: startHeight, z: 1.5)
        targetPosition = startPosition
        targetPositionX = 0.5
        super.init()
        loadModel(PLAYER_MODEL_PATH)
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
    
    public func startJump() {
        jumpTime = 0
        isAir = true
    }
    
    public override func onCollide(other: GameObject) {
        if other is Platform {
        }
        
        if other is JumpPlatform {
            //startJump()
        }
        
        if other is DeadTriggerPlatform {
            //isDeadFall = true
        }
        
        if other is Obstacle {
            //destroy()
        }
    }
    
    override func update(_ deltaTime: Float) {
        if isDeadFall {
            handleDeadFall(deltaTime)
        } else if isAir {
            handleInAir(deltaTime)
        }
        
        position = SCNVector3.lerp(position, SCNVector3(targetPositionX, position.y, position.z), deltaTime * lerpSpeed)
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
    
    override func tapGesture(_ gesture: UITapGestureRecognizer, _ location: CGPoint) {
        //World.shake()
        runAction(SCNAction.shake(initialPosition: SCNVector3.zero(), duration: 1))
    }

    public override func panGesture(_ gesture: UIPanGestureRecognizer, _ location: CGPoint) {
        if isDeadFall {
            return
        }
        
        let projectedOrigin = World.projectPoint(position)
        let vpWithZ = SCNVector3(x: Float(location.x), y: Float(location.y), z: projectedOrigin.z)
        let worldPoint = World.unprojectPoint(vpWithZ)
        
        targetPositionX = worldPoint.x
    }
    
    override func destroy() {
        isHidden = true
        delegate?.playerDied()
    }
    
    public func infiniteFalling() {
        isDeadFall = true
    }
}

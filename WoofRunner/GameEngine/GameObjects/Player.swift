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
    
    private var startHeight: Float = -0.1
    private var startOffsetX: Float = 0.5
    private let startPosition: SCNVector3
    public var delegate: PlayerDelegate?
    
    private var isAir: Bool = false
    private var jumpHeight: Float = 2
    private var jumpSpeed: Float = 4.4
    private var jumpTime: Float = 0

    private var isDeadFall: Bool = false
    private var deadFallSpeed: Float = 3
    private var deadFallLimitY: Float = -3
    
    private var targetPositionX: Float = 0
    private let lerpSpeed: Float = 15
    
    private let PLAYER_MODEL_PATH = "art.scnassets/player.scn"
    
    override init() {
        startPosition = SCNVector3(x: startOffsetX, y: startHeight, z: 1.5)
        
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
        targetPositionX = startOffsetX
    }
    
    public override func onCollide(other: GameObject) {
    }
    
    override func update(_ deltaTime: Float) {
        if isDeadFall {
            handleDeadFall(deltaTime)
        } else if isAir {
            handleInAir(deltaTime)
        }
        
        // move player
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
    
    public func startJump() {
        jumpTime = 0
        isAir = true
    }
    
    public func infiniteFalling() {
        isDeadFall = true
    }
}

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

    override init() {
        super.init()
        geometry = SCNSphere(radius: 0.3)
        name = "player"
        position = SCNVector3(x: 0, y: 0.2, z: 2)
        physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        physicsBody?.contactTestBitMask = CollisionType.Player
        //sphere1.physicsBody?.collisionBitMask = bodyNames.Player
        physicsBody?.categoryBitMask = CollisionType.Player
        isTickEnabled = true
    }
   
    override func OnCollide(_ other: GameObject) {
        destroy()
    }
    
    override func update(_ deltaTime: Float) {

    }
    
    public override func panGesture(_ gesture: UIPanGestureRecognizer, _ location: CGPoint) {
        let projectedOrigin = World.projectPoint(SCNVector3Zero)
        let vpWithZ = SCNVector3(x: Float(location.x), y: Float(location.y), z: projectedOrigin.z)
        let worldPoint = World.unprojectPoint(vpWithZ)
        
        position = SCNVector3(worldPoint.x, position.y, position.z)
    }
}

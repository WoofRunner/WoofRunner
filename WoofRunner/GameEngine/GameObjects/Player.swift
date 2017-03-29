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
        let modelScene = SCNScene(named: "art.scnassets/playerCube.scn")!
        //let modelScene = SCNScene(named: "art.scnassets/dragon2.scn")!
        let modelNode = modelScene.rootNode.childNodes[0]
        addChildNode(modelNode)

        //geometry = SCNSphere(radius: 0.4)
        name = "player"
        //position = SCNVector3(x: 0, y: -0.3, z: 1)
        position = SCNVector3(x: 0, y: 0.1, z: 1.5)
        //scale = SCNVector3(0.8, 0.8, 0.8)
        //physicsBody = characterTopLevelNode.physicsBody
        //physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        
        //characterTopLevelNode.physicsBody = nil
        //characterTopLevelNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        //physicsBody?.contactTestBitMask = CollisionType.Player
        //physicsBody?.categoryBitMask = CollisionType.Player
        
        if physicsBody == nil {
            print("body is nil")
        }
        
        //sphere1.physicsBody?.collisionBitMask = bodyNames.Player
        isTickEnabled = true
    }
   
    public override func OnCollide(other: GameObject) {
        print("collide")
        //print("collide" + String(describing: other))
        
        if other is Obstacle {
            destroy()
        }
    }
    
    override func update(_ deltaTime: Float) {
        
    }
    
    public override func panGesture(_ gesture: UIPanGestureRecognizer, _ location: CGPoint) {
        let projectedOrigin = World.projectPoint(position)
        let vpWithZ = SCNVector3(x: Float(location.x), y: Float(location.y), z: projectedOrigin.z)
        let worldPoint = World.unprojectPoint(vpWithZ)
        
        position = SCNVector3(worldPoint.x, position.y, position.z)
    }
}

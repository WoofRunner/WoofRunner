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
    
    var startHeight: Float = 0.4
    
    override init() {
        super.init()
        /*
        let modelScene = SCNScene(named: "art.scnassets/playerCube.scn")!
        let modelNode = modelScene.rootNode.childNodes[0]
        addChildNode(modelNode)
        */
        
        
        geometry = SCNSphere(radius: 0.4)
        name = "player"
        //position = SCNVector3(x: 0, y: -0.3, z: 1)
        position = SCNVector3(x: 0, y: startHeight, z: 1.5)
        //scale = SCNVector3(0.8, 0.8, 0.8)
        //physicsBody = characterTopLevelNode.physicsBody

        //let shape = SCNPhysicsShape(geometry: geometry!, options: nil)
        physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        physicsBody?.contactTestBitMask = CollisionType.Player
        physicsBody?.categoryBitMask = CollisionType.Player
        
        
        
        isTickEnabled = true
        
    }
    
    private func startJump() {
        if isAir {
            return
        }
        jumpTime = 0
        isAir = true
        print("jump")
    }
   
    public override func OnCollide(other: GameObject) {
        if other is Platform {
            print("platform")
        }
        
        if other is Obstacle {
            //print("contact")
            //destroy()
            //startJump()
        }
    }
    
    override func update(_ deltaTime: Float) {
        //print(isAir)
        if isAir {
            jumpTime += deltaTime
            position = SCNVector3(position.x, startHeight + sin(jumpTime * jumpSpeed) * jumpHeight, position.z)
            
            if position.y < startHeight {
                isAir = false
                position.y = startHeight
                
            }
 
        }
    }
    
    public override func panGesture(_ gesture: UIPanGestureRecognizer, _ location: CGPoint) {
        let projectedOrigin = World.projectPoint(position)
        let vpWithZ = SCNVector3(x: Float(location.x), y: Float(location.y), z: projectedOrigin.z)
        let worldPoint = World.unprojectPoint(vpWithZ)
        
        position = SCNVector3(worldPoint.x, position.y, position.z)
    }
}

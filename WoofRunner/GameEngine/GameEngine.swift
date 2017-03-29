//
//  GameEngine.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

class GameEngine:NSObject, SCNSceneRendererDelegate, SCNPhysicsContactDelegate  {
    public var gameObjects: [GameObject] = []
    let scnView: SCNView
    let scnScene: SCNScene
    
    var lastTime: TimeInterval = 0

    public var gestureDelegate: GestureDelegate?
    
    init?(_ view: UIView) {
        guard let view = view as? SCNView else { return nil }
        
        self.scnView = view
        scnScene = SCNScene()
        scnView.scene = scnScene
        super.init()
        scnView.delegate = self
        scnScene.physicsWorld.contactDelegate = self
        scnView.autoenablesDefaultLighting = true
        scnView.showsStatistics = true
        scnView.isPlaying = true
        
        scnView.allowsCameraControl = false
        scnView.debugOptions = SCNDebugOptions.showPhysicsShapes
        
        setUpGesture()
    }
    
    private func setUpGesture() {
        if scnView.allowsCameraControl {
            return
        }
        
        let panGestureReg = UIPanGestureRecognizer(target: self, action: #selector((panGesture)))
        panGestureReg.minimumNumberOfTouches = 1
        panGestureReg.maximumNumberOfTouches = 1
        scnView.addGestureRecognizer(panGestureReg)
        
        scnView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector((tapGesture))))
    }
    
    public func panGesture(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: scnView)
        gestureDelegate?.panGesture(gesture, location)
    }
    
    public func tapGesture(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: scnView)
        gestureDelegate?.tapGesture(gesture, location)
    }
    
    // update loop
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if lastTime == 0 {
            lastTime = time
        }
        let currentTime = time
        let deltaTime: Float = Float(currentTime - lastTime)
        lastTime = currentTime
        
        updateObjects(deltaTime)
        removeDeadObjects()
    }
    
    func updateObjects(_ deltaTime: Float) {
        for gameObject in gameObjects {
            if gameObject.isTickEnabled {
                gameObject.update(deltaTime)
            }  
        }
    }
    
    func removeDeadObjects() {
        let toBeRemovedObjects = gameObjects.filter{$0.isWaitingToBeDestroyed}
        gameObjects = gameObjects.filter{!$0.isWaitingToBeDestroyed}

        for gameObject in toBeRemovedObjects {
            gameObject.removeFromParentNode()
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        contact.nodeA.OnCollide(otherSCNNode: contact.nodeB)
        contact.nodeB.OnCollide(otherSCNNode: contact.nodeA)
        
        /*
        print("A")
        print(contact.nodeA)
        print("B")
        print(contact.nodeB)
        print()
        print()
 */
    }
    
    public func destroyEngine() {
        gameObjects.removeAll()
        gestureDelegate = nil
    }
    
    public func spawnGameObject(_ gameObject: GameObject) {
        scnScene.rootNode.addChildNode(gameObject)
        gameObjects.append(gameObject)
    }
    
    public func spawnGameObject(_ gameObject: GameObject, _ parent: GameObject) {
        parent.addChildNode(gameObject)
        gameObjects.append(gameObject)
    }
    
    public func projectPoint(_ vector: SCNVector3) -> SCNVector3 {
        return scnView.projectPoint(vector)
    }
    
    public func unprojectPoint(_ vector: SCNVector3) -> SCNVector3 {
        return scnView.unprojectPoint(vector)
    }
}

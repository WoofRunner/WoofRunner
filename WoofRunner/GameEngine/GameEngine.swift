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
    
    private var gameObjects: [GameObject] = []
    private let scnView: SCNView
    private let scnScene: SCNScene
    
    private var lastTime: TimeInterval = 0
    public var gestureDelegate: GestureDelegate?
    private let LEVEL_PATH = "art.scnassets/level.scn"
    
    public var isPause: Bool = false
    private var isDebug: Bool = false

    init(_ view: SCNView) {
        self.scnView = view
        
        if let newScnScene = SCNScene(named: LEVEL_PATH) {
            scnScene = newScnScene
        } else {
            scnScene = SCNScene()
        }
        
        scnView.scene = scnScene
        super.init()
        scnView.delegate = self
        scnScene.physicsWorld.contactDelegate = self
        scnView.autoenablesDefaultLighting = true
        scnView.showsStatistics = false
        scnView.isPlaying = true
        scnView.allowsCameraControl = false
        
        if isDebug {
            scnView.debugOptions = SCNDebugOptions.showPhysicsShapes
        }
        
        setUpGesture()
    }
    
    private func setUpGesture() {
        if scnView.allowsCameraControl {
            return
        }
        
        let panGestureReg = UIPanGestureRecognizer(target: self, action: #selector((panGesture)))
		panGestureReg.cancelsTouchesInView = false // Allow Gameplay UI to receive touches
		
        panGestureReg.minimumNumberOfTouches = 1
        panGestureReg.maximumNumberOfTouches = 1
        scnView.addGestureRecognizer(panGestureReg)
		
		let tapGestureReg = UITapGestureRecognizer(target: self, action: #selector((tapGesture)))
		tapGestureReg.cancelsTouchesInView = false // Allow Gameplay UI to receive touches
        scnView.addGestureRecognizer(tapGestureReg)
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
        if isPause {
            return
        }
        
        for gameObject in gameObjects {
            if gameObject.isTickEnabled {
                gameObject.update(deltaTime)
            }  
        }
    }
    
    private func removeDeadObjects() {
        let toBeRemovedObjects = gameObjects.filter{$0.isWaitingToBeDestroyed}
        gameObjects = gameObjects.filter{!$0.isWaitingToBeDestroyed}

        for gameObject in toBeRemovedObjects {
            gameObject.removeFromParentNode()
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        contact.nodeA.onCollide(otherSCNNode: contact.nodeB)
        contact.nodeB.onCollide(otherSCNNode: contact.nodeA)
    }
    
    public func destroyEngine() {
        for gameObject in gameObjects {
            gameObject.removeFromParentNode()
        }
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

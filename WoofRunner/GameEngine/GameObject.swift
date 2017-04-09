//
//  GameObject.swift
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//
// GameObject is a SCNNode wrapper for the GameEngine
import Foundation
import SceneKit

class GameObject: SCNNode, GestureDelegate {

    var isWaitingToBeDestroyed: Bool = false
    var isTickEnabled: Bool = false
    
    let FAR_AWAY_POSITION = SCNVector3(-100, -100, -100)
    
    convenience required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    public func update(_ deltaTime: Float) {
    }

    // to be overriden by subclass to receive onCollide event
    public func onCollide(other: GameObject) {
        
    }
    
    // called when this GameObject collide with another scnnode
    public override func onCollide(otherSCNNode: SCNNode) {
        super.onCollide(otherSCNNode: otherSCNNode)
        guard let otherGameObject = otherSCNNode as? GameObject else {
            return
        }
        onCollide(other: otherGameObject)
    }

    // set to pending destroy to be destroyed by game engine
    public func destroy() {
        isWaitingToBeDestroyed = true
    }
    
    // to be overriden by subclass to receive panGesture
    public func panGesture(_ gesture: UIPanGestureRecognizer, _ location: CGPoint) {}
    
    // to be overriden by subclass to receive tapGesture
    public func tapGesture(_ gesture: UITapGestureRecognizer, _ location: CGPoint) {}
    
    // world position based on local position
    var worldPosition: SCNVector3 {
        return convertPosition(SCNVector3.zero(), to: nil)
    }
    
     // activate GameObject by unhidding
    public func activate() {
        isHidden = false
    }
    
    // deactivate GameObject by hidding and move far away from screen
    public func deactivate() {
        isHidden = true
        position = FAR_AWAY_POSITION
    }
    
    // load model from a scene and add as a child to self
    // - parameters:
    //      -pathName: path to scene
    public func loadModel(_ pathName: String) {
        loadModel(pathName, offsetPostion: SCNVector3.zero())
    }
    
    public func loadModel(_ pathName: String, offsetPostion: SCNVector3) {
        guard let modelScene = SCNScene(named: pathName) else {
            print("WARNING: Cant find path name: " + pathName)
            return
        }
        
        for child in modelScene.rootNode.childNodes {
            child.position += offsetPostion
            addChildNode(child)
        }
    }
}



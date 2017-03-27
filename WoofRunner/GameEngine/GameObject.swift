//
//  GameObject.swift
//  test
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 nus.cs3217.a0126356. All rights reserved.
//

import Foundation
import SceneKit

class GameObject: SCNNode, GestureDelegate {

    var isWaitingToBeDestroyed: Bool = false
    var isTickEnabled: Bool = false
    
    let FAR_AWAY_POSITION = SCNVector3(-100, -100, -100)
    
    override init() {
        super.init()
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    public func update(_ deltaTime: Float) {
    }

    public func OnCollide(other: GameObject) {
        
    }
    
    public override func OnCollide(otherSCNNode: SCNNode) {
        //super.OnCollide(otherSCNNode: otherSCNNode)
        guard let otherGameObject = otherSCNNode as? GameObject else {
            return
        }
        OnCollide(other: otherGameObject)
    }

    public func destroy() {
        isWaitingToBeDestroyed = true
    }
    
    public func panGesture(_ gesture: UIPanGestureRecognizer, _ location: CGPoint) {}
    
    public func tapGesture(_ gesture: UITapGestureRecognizer, _ location: CGPoint) {}
    
    
    var worldPosition: SCNVector3 {
        return convertPosition(SCNVector3.zero(), to: nil)
    }
    
    public func activate() {
        isHidden = false
    }
    
    public func deactivate() {
        isHidden = true
        position = FAR_AWAY_POSITION
    }
}



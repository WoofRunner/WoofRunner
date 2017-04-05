//
//  SCNNode.swift
//  WoofRunner
//
//  Created by limte on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode {
    public func onCollide(otherSCNNode: SCNNode) {
        // notify parent SCNNode when collision happens
        guard let otherParent = otherSCNNode.parent else {
            return
        }
        parent?.onCollide(otherSCNNode: otherParent)
        parent?.onCollide(otherSCNNode: otherSCNNode)
        onCollide(otherSCNNode: otherParent)
    }
}

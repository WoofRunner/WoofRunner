//
//  SCNVector3.swift
//  GameEngine
//
//  Created by limte on 6/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3 {
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.init(x: x, y: y, z: z)
    }
    
    static func zero() -> SCNVector3 {
        return SCNVector3(0, 0, 0)
    }
    
    static func == (left: SCNVector3, right: SCNVector3) -> Bool {
        return left.x == right.x && left.y == right.y && left.z == right.z
    }
    
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    static func += (left:inout SCNVector3, right:SCNVector3) {
        left = left + right
    }
    
    static func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    static func -= (left:inout SCNVector3, right:SCNVector3) {
        left = left - right
    }
    
    static func * (left: SCNVector3, right: Float) -> SCNVector3 {
        return SCNVector3(left.x * right, left.y * right, left.z * right)
    }
    
    static func / (left: SCNVector3, right: Float) -> SCNVector3 {
        return SCNVector3(left.x / right, left.y / right, left.z / right)
    }
    
    static func distance(_ vec: SCNVector3) -> Float {
        return sqrt(distanceSquare(vec))
    }
    
    static func distanceSquare(_ vec: SCNVector3) -> Float {
        return pow(vec.x, 2) + pow(vec.y, 2) + pow(vec.z, 2)
    }

    static func normalize(_ vec: SCNVector3) -> SCNVector3 {
        return (vec / distance(vec))
    }
    
    static func dot(_ vec1: SCNVector3, _ vec2: SCNVector3) -> Float {
        return (vec1.x * vec2.x) + (vec1.y * vec2.y)
    }
    
    static func lerp(_ vec1: SCNVector3, _ vec2: SCNVector3, _ t: Float) -> SCNVector3 {
        return vec1 + ((vec2 - vec1) * t)
    }
}

//
//  Tile.swift
//  WoofRunner
//
//  Created by limte on 18/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

enum TileType {
    case none
    
    case jump
    case rock
    case sword
    
    case floorLight
    case floorDark
    case grass
    
    func isPlatform() -> Bool {
        switch self {
        case .floorLight, .floorDark, .grass:
            return true
        default:
            return false
        }
    }
    
    func isObstacle() -> Bool {
        switch self {
        case .jump, .rock, .sword:
            return true
        default:
            return false
        }
    }
    
    func toString() -> String {
        switch self {
        case .jump:
            return "Jump Platform"
        case .rock:
            return "Rock"
        case .floorLight:
            return "Floor Light"
        case .floorDark:
            return "Floor Dark"
        case .grass:
            return "Grass"
        case .none:
            return "Delete"
        case .sword:
            return "Swinging Sword"
        }
    }
    
    func getSpriteImageName() -> String {
        switch self {
        case .jump:
            return "testCat"
        case .rock:
            return "testCat"
        case .floorLight:
            return "testCat"
        case .floorDark:
            return "testCat"
        case .grass:
            return "testCat"
        case .none:
            return "testCat"
        case .sword:
            return "testCat"
        }
    }
}

class Tile: GameObject {
    static let TILE_WIDTH: Float = 1
    
    var delegate: PoolManager?
    
    var tileType: TileType = TileType.none
    
    var autoDestroyPositionZ: Float = 4
    
    init(_ pos: SCNVector3) {
        super.init()
        position = pos
        isTickEnabled = true
    }
    
    override convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }

    override func update(_ deltaTime: Float) {
        if worldPosition.z > autoDestroyPositionZ {
            delegate?.poolTile(self)
        }
    }
    
    public func loadModel(_ pathName: String) {
        guard let modelScene = SCNScene(named: pathName) else {
            print("WARNING: Cant find path name: " + pathName)
            return
        }
        let modelNode = modelScene.rootNode.childNodes[0]
        addChildNode(modelNode)
    }
}

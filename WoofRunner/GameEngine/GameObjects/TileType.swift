//
//  TileType.swift
//  WoofRunner
//
//  Created by limte on 30/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

enum TileType: Int {
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
    
    func getModelPath() -> String {
        switch self {
        case .jump:
            return "testCat"
        case .rock:
            return "art.scnassets/cube2.scn"
        case .floorLight:
            return "art.scnassets/floor_light.scn"
        case .floorDark:
            return "art.scnassets/floor_dark.scn"
        case .grass:
            return "testCat"
        case .none:
            return "testCat"
        case .sword:
            return "testCat"
        }
    }
}

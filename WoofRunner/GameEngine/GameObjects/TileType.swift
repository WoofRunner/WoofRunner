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

    case rock
    case sword
    
    case floorJump
    case floorLight
    case floorDark
    case grass
    
    case jumpingRock
    
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
        case .floorJump, .rock, .sword:
            return true
        default:
            return false
        }
    }
    
    func toString() -> String {
        switch self {
        case .floorJump:
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
        case .jumpingRock:
            return "Jumping Rock"
        }
    }
    
    func getSpriteImageName() -> String {
        switch self {
        case .floorJump:
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
        case .jumpingRock:
            return "Jumping Rock"
        }
    }
    
    func getModelPath() -> String {
        switch self {
        case .floorJump:
            return "art.scnassets/cube3.scn"
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
        case .jumpingRock:
            return "art.scnassets/cube2.scn"
        }
    }
}

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
    
    case floorLight
    case floorDark
    case floorJump
    
    
    case rock
    case jumpingRock
    case rotatingAxe
    
    case movingPlatform
    
    case sword
    case grass
    
    func isPlatform() -> Bool {
        switch self {
        case .floorLight, .floorDark, .floorJump, .movingPlatform:
            return true
        default:
            return false
        }
    }
    
    func isObstacle() -> Bool {
        switch self {
        case .jumpingRock, .rock, .rotatingAxe:
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
        case .movingPlatform:
            return "Moving Platform"
        case .none:
            return "Delete"
        case .sword:
            return "Swinging Sword"
        case .jumpingRock:
            return "Jumping Rock"
        default:
            return ""
        }
    }
    
    func getSpriteImageName() -> String {
        switch self {
        case .floorJump:
            return "obstacle-placeholder2"
        case .rock:
            return "obstacle-placeholder2"
        case .floorLight:
            return "obstacle-placeholder1"
        case .floorDark:
            return "platform-placeholder"
        case .movingPlatform:
            return "testCat"
        case .none:
            return "testCat"
        case .sword:
            return "testCat"
        case .jumpingRock:
            return "testCat"
        default:
            return ""
        }
    }
    
    func getModelPath() -> String {
        switch self {
        case .floorJump:
            return "art.scnassets/cube3.scn"
        case .rock:
            return "art.scnassets/rock/rock.scn"
        case .floorLight:
            return "art.scnassets/platform/floor_flat_light.scn"
        case .floorDark:
            return "art.scnassets/platform/floor_flat_dark.scn"
        case .movingPlatform:
            return "art.scnassets/platform/floor_flat_dark.scn"
        case .none:
            return "testCat"
        case .sword:
            return "testCat"
        case .jumpingRock:
            return "art.scnassets/rock/jumpRock.scn"
        case .rotatingAxe:
            return "art.scnassets/rock/rockWithAxe.scn"
        default:
            return ""
        }
    }
}

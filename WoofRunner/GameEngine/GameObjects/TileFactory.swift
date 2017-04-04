//
//  TileFactory.swift
//  WoofRunner
//
//  Created by limte on 4/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

final class TileFactory {
    static let sharedInstance: TileFactory = TileFactory()

    private init() {
    }
    
    public func createTile(_ tileType: TileType) -> Tile? {
        let tile: Tile
        
        switch tileType {
        case .floorLight:
            tile = LightPlatform()
            
        case .floorDark:
            tile = DarkPlatform()
            
        case .floorJump:
            tile = JumpPlatform()
            
        case .rock:
            tile = RotatingAxe()
            
        case .jumpingRock:
            tile = JumpingRock()
            
        case .none:
            tile = DeadTriggerTile()
            
        default:
            print("WARNING: Cant Invalid tile, TileType: " + String(describing: tileType))
            return nil
        }
        
        return tile
    }

}

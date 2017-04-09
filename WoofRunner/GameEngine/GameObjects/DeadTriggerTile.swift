//
//  DeadPlatform.swift
//  WoofRunner
//
//  Created by limte on 30/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class DeadTriggerTile : Platform {
    
    override init(_ tileModel: TileModel) {
        super.init(tileModel)
        let trigger = Trigger(SCNVector3(GameSettings.TILE_WIDTH/2, GameSettings.TILE_WIDTH/2, -GameSettings.TILE_WIDTH/2))
        addChildNode(trigger)
    }
}

//
//  JumpFloor.swift
//  WoofRunner
//
//  Created by limte on 31/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class JumpPlatform : Platform {
    
    override init(_ tileModel: TileModel) {
        super.init(tileModel)
    }
    
    override func onCollide(other: GameObject) {
        if let player = other as? Player {
            player.startJump()
        }
    }
}

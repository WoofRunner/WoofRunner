//
//  Ground.swift
//  WoofRunner
//
//  Created by limte on 22/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SceneKit

class Platform : Tile {
    override init(_ pos: SCNVector3) {
        super.init(pos)
    }
    
    convenience init() {
        self.init(SCNVector3(0, 0, 0))
    }
}

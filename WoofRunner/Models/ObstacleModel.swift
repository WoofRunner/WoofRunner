//
//  ObstacleModel.swift
//  WoofRunner
//
//  Created by limte on 7/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

class ObstacleModel: TileModel {
    
    let obstacleBehaviour: ObstacleBehaviour
    
    init(name: String, scenePath: String, iconPath: String, obstacleBehaviour: ObstacleBehaviour) {
        self.obstacleBehaviour = obstacleBehaviour
        super.init(name:name, scenePath: scenePath, iconPath: iconPath)
    }
}

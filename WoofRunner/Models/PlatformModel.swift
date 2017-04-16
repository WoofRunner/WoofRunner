//
//  PlatformModel.swift
//  WoofRunner
//
//  Created by limte on 7/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

public class PlatformModel: TileModel {
    
    let platformBehaviour: PlatformBehaviour
    
    init(name: String, scenePath: String?, iconPath: String?, platformBehaviour: PlatformBehaviour) {
        self.platformBehaviour = platformBehaviour
        super.init(name:name, scenePath: scenePath, iconPath: iconPath)
    }
}

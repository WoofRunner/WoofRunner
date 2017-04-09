//
//  TileModel.swift
//  WoofRunner
//
//  Created by limte on 7/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

public class TileModel {
    static var tileModelCount = 0
    
    let uniqueId: Int
    let name: String
    let scenePath: String
    let iconPath: String
    
    init(name: String, scenePath: String, iconPath: String) {
        self.name = name
        self.scenePath = scenePath
        self.iconPath = iconPath
        
        uniqueId = TileModel.tileModelCount
        TileModel.tileModelCount += 1
    }
}

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
    
    let tileId: Int
    let name: String
    private(set) var scenePath: String?
    private(set) var iconPath: String?

    init(name: String, scenePath: String?, iconPath: String?) {
        self.name = name
        self.scenePath = scenePath
        self.iconPath = iconPath
        
        tileId = TileModel.tileModelCount
        TileModel.tileModelCount += 1
    }
}

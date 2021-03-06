//
//  LoadableGame.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/28/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

/**
 Games that can be loaded implements this protocol.
 */
public protocol LoadableGame {
    func getObstacles() -> [[TileModel?]]
    func getPlatforms() -> [[TileModel?]]
}

//
//  UploadableGame.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import ObjectMapper

public protocol UploadableGame: SaveableGame, Mappable {
    var ownerID: String { get set }
}

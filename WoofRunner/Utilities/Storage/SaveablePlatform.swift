//
//  SaveablePlatform.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/25/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import ObjectMapper

public protocol SaveablePlatform: Mappable {
    var type: String { get set } // TODO: Change this to an enum
    var position: Position { get set }
}

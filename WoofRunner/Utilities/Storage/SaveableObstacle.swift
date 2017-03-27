//
//  SaveableObstacle.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/19/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

public protocol SaveableObstacle {
    var type: String { get set } // TODO: Change this to an enum
    var position: Position { get set }
    var radius: Int { get set }
}

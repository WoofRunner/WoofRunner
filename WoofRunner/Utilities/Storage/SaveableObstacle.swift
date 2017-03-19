//
//  SaveableObstacle.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/19/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

public protocol SaveableObstacle {
    var type: String { get } // TODO: Change this to an enum
    var position: IndexPath { get }
    var radius: Int { get }
}

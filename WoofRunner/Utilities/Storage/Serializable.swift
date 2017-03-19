//
//  Serializable.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/17/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

public protocol Serializable {
    var id: String { get }

    func serialize() -> NSDictionary
}

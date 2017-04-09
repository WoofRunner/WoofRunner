//
//  SaveableObstacle.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/19/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

public protocol SaveableObstacle {
    func toStoredObstacle() -> StoredObstacle
}

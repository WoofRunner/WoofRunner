//
//  SaveableGame.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/19/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

/**
 Classes/structs that implements this are saveable in either CoreData or OnlineStorage.
 */
public protocol SaveableGame: Saveable, Serializable {
    var emptyPlatforms: [Position] { get }
    var jumpPlatforms: [Position] { get }
    var obstacles: [SaveableObstacle] { get }
}

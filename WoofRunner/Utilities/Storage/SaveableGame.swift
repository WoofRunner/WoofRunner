//
//  SaveableGame.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/19/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

/**
 Classes/structs that implements this are saveable in either CoreData or OnlineStorage.
 */
public protocol SaveableGame {
    func toStoredGame() -> StoredGame
}

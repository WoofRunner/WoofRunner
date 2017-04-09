//
//  StoredGame+SaveableGame.swift
//  WoofRunner
//
//  Created by Xu Bili on 4/2/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

extension StoredGame: SaveableGame {

    public func toStoredGame() -> StoredGame {
        return self
    }

    public func load(from storedGame: StoredGame) {
        // Do nothing
    }

}

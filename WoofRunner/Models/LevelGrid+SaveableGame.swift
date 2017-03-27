//
//  LevelGrid+Saveable.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/28/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

extension LevelGrid: SaveableGame {

    func toStoredGame() -> StoredGame {
        // If the game was originally loaded, we return the
        let res: StoredGame

        if let currentStoredGame = storedGame {
            res = currentStoredGame
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            res = StoredGame(context: appDelegate.dataStack.mainContext)

            // Set values for a new StoredGame
            res.setValue(UUID().uuidString, forKey: "uuid")
            res.setValue(Date() as NSDate?, forKey: "createdAt")
        }

        // Set StoredGame values
        // TODO: Stubbed values
        res.setValue(getStoredObstacles(), forKey: "obstacles")
        res.setValue(getStoredPlatforms(), forKey: "platforms")
        res.setValue(Date() as NSDate?, forKey: "updatedAt")

        storedGame = res

        return res
    }

    func load(from storedGame: StoredGame) {
        self.storedGame = storedGame

        // TODO: Map the StoredGame attribute to the game model
    }

    /// Returns the StoredObstacle mapping of the current game model.
    private func getStoredObstacles() -> [StoredObstacle] {
        return [StoredObstacle]()
    }

    /// Returns the StoredPlatform mapping of the current game model.
    /// - Returns: array of StoredPlatform objects
    private func getStoredPlatforms() -> [StoredPlatform] {
        return [StoredPlatform]()
    }

}

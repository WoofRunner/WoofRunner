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
        let rows = platformArray.count
        let columns = platformArray.first?.count ?? 0

        res.setValue(rows, forKey: "rows")
        res.setValue(columns, forKey: "columns")
        res.setValue(getStoredObstacles(), forKey: "obstacles")
        res.setValue(getStoredPlatforms(), forKey: "platforms")
        res.setValue(Date() as NSDate?, forKey: "updatedAt")

        storedGame = res

        return res
    }

    func load(from storedGame: StoredGame) {
        self.storedGame = storedGame
        let obstacles = storedGame.value(forKey: "obstacles") as! [StoredObstacle]
        let platforms = storedGame.value(forKey: "platforms") as! [StoredPlatform]

        for obstacle in obstacles {
            obstacleArray[Int(obstacle.positionX)][Int(obstacle.positionY)] = Int(obstacle.type!)!
        }

        for platform in platforms {
            platformArray[Int(platform.positionX)][Int(platform.positionY)] = Int(platform.type!)!
        }
    }

    /// Returns the StoredObstacle mapping of the current game model.
    private func getStoredObstacles() -> [StoredObstacle] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var res = [StoredObstacle]()

        for (row, obstacles) in obstacleArray.enumerated() {
            for (col, obstacle) in obstacles.enumerated() {
                let storedObstacle = StoredObstacle(context: appDelegate.dataStack.mainContext)
                storedObstacle.setValue(String(obstacle), forKey: "type")
                storedObstacle.setValue(col, forKey: "positionX")
                storedObstacle.setValue(row, forKey: "positionY")

                // Radius of each obstacle not determined yet
                storedObstacle.setValue(1, forKey: "radius")

                res.append(storedObstacle)
            }
        }

        return res
    }

    /// Returns the StoredPlatform mapping of the current game model.
    /// - Returns: array of StoredPlatform objects
    private func getStoredPlatforms() -> [StoredPlatform] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var res = [StoredPlatform]()

        for (row, platforms) in platformArray.enumerated() {
            for (col, platform) in platforms.enumerated() {
                let storedPlatform = StoredPlatform(context: appDelegate.dataStack.mainContext)
                storedPlatform.setValue(String(platform), forKey: "type")
                storedPlatform.setValue(col, forKey: "positionX")
                storedPlatform.setValue(row, forKey: "positionY")

                res.append(storedPlatform)
            }
        }

        return res
    }

}

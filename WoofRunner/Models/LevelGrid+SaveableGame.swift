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
            res = StoredGame(context: appDelegate.coreDataStack.persistentContainer.viewContext)

            // Set values for a new StoredGame
            res.uuid = UUID().uuidString
            res.createdAt = Date() as NSDate?
        }

        // Set StoredGame values
        res.rows = Int16(self.length)
        res.columns = Int16(LevelGrid.levelCols)
        res.updatedAt = Date() as NSDate?

        let storedObstacles = res.mutableSetValue(forKey: "obstacles")
        let storedPlatforms = res.mutableSetValue(forKey: "platforms")

        for obstacle in getStoredObstacles(game: res) {
            storedObstacles.add(obstacle)
        }

        for platform in getStoredPlatforms(game: res) {
            storedPlatforms.add(platform)
        }

        storedGame = res

        return res
    }

    func load(from storedGame: StoredGame) {
        self.storedGame = storedGame

        var obstacles = [StoredObstacle]()
        for obstacle in storedGame.obstacles! {
            obstacles.append(obstacle as! StoredObstacle)
        }

        var platforms = [StoredPlatform]()
        for platform in storedGame.platforms! {
            platforms.append(platform as! StoredPlatform)
        }

        for obstacle in obstacles {
            obstacleArray[Int(obstacle.positionX)][Int(obstacle.positionY)] = Int(obstacle.type!)!
        }

        for platform in platforms {
            platformArray[Int(platform.positionX)][Int(platform.positionY)] = Int(platform.type!)!
        }
    }

    /// Returns the StoredObstacle mapping of the current game model.
    private func getStoredObstacles(game: StoredGame) -> [StoredObstacle] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var res = [StoredObstacle]()

        for (row, obstacles) in obstacleArray.enumerated() {
            for (col, obstacle) in obstacles.enumerated() {
                let storedObstacle = StoredObstacle(
                    context: appDelegate.coreDataStack.persistentContainer.viewContext)
                storedObstacle.type = String(obstacle)
                storedObstacle.positionX = Int16(col)
                storedObstacle.positionY = Int16(row)

                // Radius of each obstacle not determined yet
                storedObstacle.radius = 1

                res.append(storedObstacle)
            }
        }

        return res
    }

    /// Returns the StoredPlatform mapping of the current game model.
    /// - Returns: array of StoredPlatform objects
    private func getStoredPlatforms(game: StoredGame) -> [StoredPlatform] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var res = [StoredPlatform]()

        for (row, platforms) in platformArray.enumerated() {
            for (col, platform) in platforms.enumerated() {
                let storedPlatform = StoredPlatform(
                    context: appDelegate.coreDataStack.persistentContainer.viewContext)
                storedPlatform.type = String(platform)
                storedPlatform.positionX = Int16(row)
                storedPlatform.positionY = Int16(col)

                res.append(storedPlatform)
            }
        }

        return res
    }

}

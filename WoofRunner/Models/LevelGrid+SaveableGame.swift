//
//  LevelGrid+Saveable.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/28/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

/// Extension. Provides saving and loading functionality
/// for the level grid object.
extension LevelGrid: SaveableGame {

    /// Translates the LevelGrid into a StoredGame object using the 
    /// values in the platform and obstacle arrays
    func toStoredGame() -> StoredGame {
        let context = CoreDataManager.shared.context

        // If the game was originally loaded, we return the
        let res: StoredGame

        if let currentStoredGame = storedGame {
            res = currentStoredGame
        } else {
            res = StoredGame(context: context)

            // Set values for a new StoredGame
            res.uuid = UUID().uuidString
            res.createdAt = Date() as NSDate?
        }

        // Set StoredGame values
        preprocessLevel()

        res.rows = Int16(self.length)
        res.columns = Int16(LevelGrid.levelCols)

        removeCurrentObstacles(game: res)
        removeCurrentPlatforms(game: res)
        createStoredObstacles(game: res)
        createStoredPlatforms(game: res)

        storedGame = res

        return res
    }

    /// Translate the StoredGame object back into the LevelGrid
    /// - Parameters:
    ///     - storedGame: StoredGame object from CoreData which holds the level data
    func load(from storedGame: StoredGame) {
        self.storedGame = storedGame

        obstacleArray = storedGame.getObstacles().map { column in
            return column.map { $0 as? ObstacleModel }
        }
        platformArray = storedGame.getPlatforms().map { column in
            return column.map { $0 as? PlatformModel }
        }
		
		// Reinit Level
		length = platformArray.count
		gridViewModelArray.value = [[GridViewModel]](repeating: [GridViewModel](repeating: GridViewModel(),
		                                                                        count: LevelGrid.levelCols),
		                                             count: length)
		
		// Setup GridVMs
		for row in 0...length - 1 {
			for col in 0...LevelGrid.levelCols - 1 {
				let gridVM = GridViewModel(row: row, col: col)
				gridVM.setType(platform: platformArray[row][col],
				               obstacle: obstacleArray[row][col])
				setupObservables(gridVM)
				// Append to array
				gridViewModelArray.value[row][col] = gridVM
			}
		}
    }

    /// Returns the StoredObstacle mapping of the current game model.
    /// - Parameters:
    ///     - game: StoredGame object which will be populated with level obstacle data
    /// - Returns: array of StoredObstacle objects
    private func createStoredObstacles(game: StoredGame) {
        let context = CoreDataManager.shared.context

        for (row, obstacles) in obstacleArray.enumerated() {
            for (col, obstacle) in obstacles.enumerated() {
                // Obstacle does not exist
                guard let obstacleId = obstacle?.tileId else {
                    continue
                }

                let storedObstacle = StoredObstacle(context: context)
                storedObstacle.type = Int16(obstacleId)
                storedObstacle.positionX = Int16(row)
                storedObstacle.positionY = Int16(col)

                game.addToObstacles(storedObstacle)
            }
        }
    }

    /// Returns the StoredPlatform mapping of the current game model.
    /// - Parameters:
    ///     - game: StoredGame object which will be populated with level platform data
    /// - Returns: array of StoredPlatform objects
    private func createStoredPlatforms(game: StoredGame) {
        let context = CoreDataManager.shared.context

        for (row, platforms) in platformArray.enumerated() {
            for (col, platform) in platforms.enumerated() {
                // Platform does not exist
                guard let platformId = platform?.tileId else {
                    continue
                }

                let storedPlatform = StoredPlatform(context: context)
                storedPlatform.type = Int16(platformId)
                storedPlatform.positionX = Int16(row)
                storedPlatform.positionY = Int16(col)

                game.addToPlatforms(storedPlatform)
            }
        }
    }

    /// Removes the current StoredPlatforms
    private func removeCurrentPlatforms(game: StoredGame) {
        guard let currentPlatforms = game.platforms else {
            fatalError("Game has no current platforms")
        }

        game.removeFromPlatforms(currentPlatforms)

        for item in currentPlatforms {
            guard let platform = item as? StoredPlatform else {
                fatalError("Current platform is not a StoredPlatform")
            }

            CoreDataManager.shared.context.delete(platform)
        }
    }

    /// Removes current StoredObstacles
    private func removeCurrentObstacles(game: StoredGame) {
        guard let currentObstacles = game.obstacles else {
            fatalError("Game has no current obstacles")
        }

        game.removeFromPlatforms(currentObstacles)

        for item in currentObstacles {
            guard let obstacle = item as? StoredObstacle else {
                fatalError("Current platform is not a StoredObstacle")
            }

            CoreDataManager.shared.context.delete(obstacle)
        }
    }
    
    // Pre-process the level before saving
    private func preprocessLevel() {
        // Truncate trailling empty rows from back to front
        var platformLength = self.length
        for index in 0...platformLength - 1 {
            let row = gridViewModelArray.value[platformLength - index - 1]
            if !isEmptyRow(row) {
                platformLength = platformLength - index
                break
            }
        }
        // Update level variables with new length
        gridViewModelArray.value = Array(gridViewModelArray.value
                                                            .prefix(platformLength))
        platformArray = Array(platformArray.prefix(platformLength))
        obstacleArray = Array(obstacleArray.prefix(platformLength))
        
        length = platformLength
    }
    
    // Returns if the row is empty of platform and obstacles
    private func isEmptyRow(_ row: [GridViewModel]) -> Bool {
        for gridVM in row {
			if gridVM.platformType.value != nil
				|| gridVM.obstacleType.value != nil {
                return false
            }
        }
        return true
    }

}

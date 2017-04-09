//
//  LevelGrid+Saveable.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/28/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

extension LevelGrid: SaveableGame {

    func toStoredGame() -> StoredGame {
        let cdm = CoreDataManager.getInstance()
        let context = cdm.context

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
        
        createStoredObstacles(game: res)
        createStoredPlatforms(game: res)

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
            obstacleArray[Int(obstacle.positionX)][Int(obstacle.positionY)] = TileModelFactory.sharedInstance.getTile(id: Int(obstacle.type)) as? ObstacleModel
        }

        for platform in platforms {
            platformArray[Int(platform.positionX)][Int(platform.positionY)] = TileModelFactory.sharedInstance.getTile(id: Int(platform.type)) as? PlatformModel
        }
		
		// Reinit Level
		length = platformArray.count
		gridViewModelArray = [[GridViewModel]](repeating: [GridViewModel](repeating: GridViewModel(),
		                                                                  count: LevelGrid.levelCols),
		                                       count: length)
		
		// Setup GridVMs
		for row in 0...length - 1 {
			for col in 0...LevelGrid.levelCols - 1 {
				let gridVM = GridViewModel(row: row, col: col)
				gridVM.setType(platform: platformArray[row][col]!,
				               obstacle: obstacleArray[row][col]!)
				setupObservables(gridVM)
				// Append to array
				gridViewModelArray[row][col] = gridVM
			}
		}
    }

    /// Returns the StoredObstacle mapping of the current game model.
    private func createStoredObstacles(game: StoredGame) {
        let cdm = CoreDataManager.getInstance()
        let context = cdm.context

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
    /// - Returns: array of StoredPlatform objects
    private func createStoredPlatforms(game: StoredGame) {
        let cdm = CoreDataManager.getInstance()
        let context = cdm.context

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
    
    // Pre-process the level before saving
    private func preprocessLevel() {
        // Truncate trailling empty rows
        var platformLength = self.length - 1
        for index in 0...platformLength {
            let row = gridViewModelArray[platformLength - index]
            if !isEmptyRow(row) {
                platformLength = platformLength - index
                break
            }
        }
        gridViewModelArray = Array(gridViewModelArray.prefix(platformLength + 1))
        platformArray = Array(platformArray.prefix(platformLength + 1))
        obstacleArray = Array(obstacleArray.prefix(platformLength + 1))
        
        length = platformLength + 1
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

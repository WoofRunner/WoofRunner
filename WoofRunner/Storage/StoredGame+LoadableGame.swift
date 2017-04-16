//
//  StoredGame+LoadableGame.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/28/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

extension StoredGame: LoadableGame {

    /// Returns the stored platforms as a 2D array.
    /// - Returns: 2D array of platform types
    public func getPlatforms() -> [[TileModel?]] {
        var res = create2DArray(rows: Int(rows), cols: Int(columns), initialValue: nil)
        let storedPlatforms = self.platforms?.map { platform in
            guard let storedPlatform = platform as? StoredPlatform else {
                fatalError("Unable to convert to StoredPlatform")
            }

            return storedPlatform
        } ?? [StoredPlatform]()

        for platform in storedPlatforms {
            let row = Int(platform.positionX)
            let col = Int(platform.positionY)

            res[row][col] = mapToPlatformModel(platform)
        }

        return res
    }

    /// Returns the stored obstacles of a game as a 2D array.
    /// - Returns: 2D array of obstacle types
    public func getObstacles() -> [[TileModel?]] {
        var res = create2DArray(rows: Int(rows), cols: Int(columns), initialValue: nil)
        let storedObstacles = self.obstacles?.map { $0 as! StoredObstacle } ?? [StoredObstacle]()

        for obstacle in storedObstacles {
            let row = Int(obstacle.positionX)
            let col = Int(obstacle.positionY)

            res[row][col] = mapToObstacleModel(obstacle)
        }

        return res
    }

    private func mapToObstacleModel(_ obstacle: StoredObstacle) -> TileModel? {
        let tileId = Int(obstacle.type)
        let tiles = TileModelFactory.sharedInstance.tileModels
        return tiles[tileId]
    }

    private func mapToPlatformModel(_ platform: StoredPlatform) -> TileModel? {
        let tileId = Int(platform.type)
        let tiles = TileModelFactory.sharedInstance.tileModels
        return tiles[tileId]
    }

    private func create2DArray(rows: Int, cols: Int, initialValue: TileModel?) -> [[TileModel?]] {
        return [[TileModel?]](repeating: [TileModel?](repeating: initialValue, count: cols), count: rows)
    }

}

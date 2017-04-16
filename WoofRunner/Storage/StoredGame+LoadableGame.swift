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
    public func getPlatforms() -> [[PlatformModel?]] {
        var res = create2DPlatformsArray(rows: Int(rows), cols: Int(columns), initialValue: nil)
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
    public func getObstacles() -> [[ObstacleModel?]] {
        var res = create2DObstaclesArray(rows: Int(rows), cols: Int(columns), initialValue: nil)
        let storedObstacles = self.obstacles?.map { $0 as! StoredObstacle } ?? [StoredObstacle]()

        for obstacle in storedObstacles {
            let row = Int(obstacle.positionX)
            let col = Int(obstacle.positionY)

            res[row][col] = mapToObstacleModel(obstacle)
        }

        return res
    }

    private func mapToObstacleModel(_ obstacle: StoredObstacle) -> ObstacleModel? {
        let tileId = Int(obstacle.type)
        let tiles = TileModelFactory.sharedInstance.tileModels
        guard let obstacle = tiles[tileId] as? ObstacleModel else {
            return nil
        }

        return obstacle
    }

    private func mapToPlatformModel(_ platform: StoredPlatform) -> PlatformModel? {
        let tileId = Int(platform.type)
        let tiles = TileModelFactory.sharedInstance.tileModels
        guard let platform = tiles[tileId] as? PlatformModel else {
            return nil
        }

        return platform
    }

    private func create2DArray(rows: Int, cols: Int, initialValue: TileModel?) -> [[TileModel?]] {
        return [[TileModel?]](repeating: [TileModel?](repeating: initialValue, count: cols), count: rows)
    }


    private func create2DObstaclesArray(rows: Int,
                                        cols: Int,
                                        initialValue: ObstacleModel?) -> [[ObstacleModel?]] {
        return [[ObstacleModel?]](
            repeating: [ObstacleModel?](repeating: initialValue, count: cols), count: rows)
    }

    private func create2DPlatformsArray(rows: Int,
                                        cols: Int,
                                        initialValue: PlatformModel?) -> [[PlatformModel?]] {
        return [[PlatformModel?]](
            repeating: [PlatformModel?](repeating: initialValue, count: cols), count: rows)
    }

}

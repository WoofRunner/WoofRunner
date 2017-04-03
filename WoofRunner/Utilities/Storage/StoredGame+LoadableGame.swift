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
    public func getPlatforms() -> [[Int]] {
        let DEFAULT_VALUE = 0

        var res = create2DArray(rows: Int(rows), cols: Int(columns), initialValue: DEFAULT_VALUE)
        let storedPlatforms = self.platforms?.map { $0 as! StoredPlatform } ?? [StoredPlatform]()

        for platform in storedPlatforms {
            let row = Int(platform.positionX)
            let col = Int(platform.positionY)

            res[row][col] = Int(platform.type!)!
        }

        return res
    }

    /// Returns the stored obstacles of a game as a 2D array.
    /// - Returns: 2D array of obstacle types
    public func getObstacles() -> [[Int]] {
        let DEFAULT_VALUE = 0

        var res = create2DArray(rows: Int(rows), cols: Int(columns), initialValue: DEFAULT_VALUE)
        let storedObstacles = self.obstacles?.map { $0 as! StoredObstacle } ?? [StoredObstacle]()

        for obstacle in storedObstacles {
            let row = Int(obstacle.positionX)
            let col = Int(obstacle.positionY)

            res[row][col] = Int(obstacle.type!)!
        }

        return res
    }

    private func create2DArray(rows: Int, cols: Int, initialValue: Int) -> [[Int]] {
        return [[Int]](repeating: [Int](repeating: initialValue, count: cols), count: rows)
    }

}

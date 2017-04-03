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
            let col = Int(platform.positionX)
            let row = Int(platform.positionY)

            res[col][row] = Int(platform.type!)!
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
            let col = Int(obstacle.positionX)
            let row = Int(obstacle.positionY)

            res[col][row] = Int(obstacle.type!)!
        }

        return res
    }

    private func create2DArray(rows: Int, cols: Int, initialValue: Int) -> [[Int]] {
        return [[Int]](repeating: [Int](repeating: initialValue, count: rows), count: cols)
    }

}

//
//  GameStorageManager.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/27/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import RxSwift
import Result
import BrightFutures

/**
 Singleton method to handle game storage, both online and offline.
 */
public class GameStorageManager {

    // MARK: - Shared singleton instance
    public static var shared = GameStorageManager()

    // MARK: - Private variables

    private let osm = OnlineStorageManager.shared
    private let cdm = CoreDataManager.shared

    // MARK: - Private initializer

    private init() {}

    // MARK: - Public methods

    /// Returns an array of all the games stored in memory.
    /// - Returns: array of UploadableGame from memory
    public func getAllGames() -> Future<[StoredGame], CoreDataManagerError> {
        return cdm.loadAll()
    }

    /// Returns all games created by the owner that have been uploaded to the marketplace.
    /// - Returns: array of UploadableGame that has been uploaded
    public func getUploadedGames() -> Future<[StoredGame], CoreDataManagerError> {
        // TODO: Implement filter for uploaded games
        return cdm.loadAll()
    }

    public func getGame(uuid: String) -> Future<StoredGame, CoreDataManagerError> {
        return cdm.load(uuid)
    }

    /// Saves the game to CoreData.
    public func saveGame(_ game: SaveableGame) -> Future<StoredGame, CoreDataManagerError> {
        return cdm.save(game)
    }

    /// Deletes a game from CoreData.
    public func deleteGame(_ uuid: String) -> Future<Bool, CoreDataManagerError> {
        return cdm.delete(uuid: uuid)
    }

    /// Uploads the game with the corresponding UUID to Firebase.
    /// - Parameters:
    ///     - uuid: UUID string of the game to upload
    public func uploadGame(uuid: String) {
        cdm.load(uuid)
            .onSuccess { game in
                self.osm.save(game)
            }
            .onFailure { _ in
                // TODO: Handle error
            }
    }

    /// Downloads the game with the corresponding UUID from Firebase into CoreData.
    /// - Parameters:
    ///     - uuid: UUID string of the game to download
    public func downloadGame(uuid: String) -> Future<StoredGame, OnlineStorageManagerError> {
        let future = osm.load(uuid)
            .map { json in
                self.mapJSONtoStoredGame(json: json!)
            }
            .andThen { storedGame in
                let _ = self.cdm.save(storedGame.value!)
            }

        return future
    }

    /// Loads a preview of all the games loaded on Firebase.
    /// - Returns: array of GamePreviews
    public func loadAllPreviews() -> Future<[PreviewGame], OnlineStorageManagerError> {
        return osm.loadAll()
    }

    // MARK: - Private methods

    private func mapJSONtoStoredGame(json: NSDictionary) -> StoredGame {
        // TODO: Check for existing game under the same UUID
        let storedGame = StoredGame(context: cdm.context)

        storedGame.uuid = json.value(forKey: "uuid") as? String
        storedGame.ownerId = json.value(forKey: "ownerId") as? String
        storedGame.name = json.value(forKey: "name") as? String

        guard let rows = json.value(forKey: "rows") as? Int,
            let columns = json.value(forKey: "columns") as? Int else {
                fatalError("JSON value for rows or column is not a number")
        }

        storedGame.rows = Int16(rows)
        storedGame.columns = Int16(columns)

        let platforms: [StoredPlatform]
        if let JSONPlatforms = json.value(forKey: "platforms") {
            platforms = mapJSONtoStoredPlatforms(json: JSONPlatforms as! [NSDictionary])
        } else {
            platforms = []
        }

        let obstacles: [StoredObstacle]
        if let JSONObstacles = json.value(forKey: "obstacles") {
            obstacles = mapJSONtoStoredObstacles(json: JSONObstacles as! [NSDictionary])
        } else {
            obstacles = []
        }

        let storedObstacles = storedGame.mutableSetValue(forKey: "obstacles")
        let storedPlatforms = storedGame.mutableSetValue(forKey: "platforms")

        for obstacle in obstacles {
            storedObstacles.add(obstacle)
        }

        for platform in platforms {
            storedPlatforms.add(platform)
        }

        let formatter = OnlineStorageManager.getDateFormatter()
        storedGame.createdAt = formatter.date(
            from: json.value(forKey: "createdAt") as! String) as NSDate?
        storedGame.updatedAt = formatter.date(
            from: json.value(forKey: "updatedAt") as! String) as NSDate?

        return storedGame
    }

    private func mapJSONtoStoredPlatforms(json: [NSDictionary]) -> [StoredPlatform] {
        var res = [StoredPlatform]()
        for platformJSON in json {
            let platform = StoredPlatform(context: cdm.context)

            guard let positionX = platformJSON.value(forKey: "positionX") as? Int,
                let positionY = platformJSON.value(forKey: "positionY") as? Int else {
                    fatalError("Platform positions cannot be converted to Int")
            }

            guard let type = platformJSON.value(forKey: "type") as? Int else {
                fatalError("Platform type cannot be converted to Int")
            }

            platform.positionX = Int16(positionX)
            platform.positionY = Int16(positionY)
            platform.type = Int16(type)

            res.append(platform)
        }

        return res
    }

    private func mapJSONtoStoredObstacles(json: [NSDictionary]) -> [StoredObstacle] {
        var res = [StoredObstacle]()
        for obstacleJSON in json {
            let obstacle = StoredObstacle(context: cdm.context)

            guard let positionX = obstacleJSON.value(forKey: "positionX") as? Int,
                let positionY = obstacleJSON.value(forKey: "positionY") as? Int else {
                    fatalError("Obstacle positions cannot be converted to Int")
            }

            guard let type = obstacleJSON.value(forKey: "type") as? Int else {
                fatalError("Obstacle type cannot be converted to Int")
            }

            obstacle.positionX = Int16(positionX)
            obstacle.positionY = Int16(positionY)
            obstacle.type = Int16(type)

            res.append(obstacle)
        }

        return res
    }

}

public enum GameStorageManagerError: Error {
    case GameNotFound
    case GamesNotLoaded
    case GameNotUploaded
    case GameNotDownloaded
}

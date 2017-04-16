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

    /// Injects the preloaded JSON games into CoreData.
    /// - Returns: A future containing all the StoredGame saved.
    public func injectPreloadedGames() -> Future<[StoredGame], CoreDataManagerError> {
        guard let path = Bundle.main.url(
            forResource: "PreloadedGames", withExtension: "json") else {
                fatalError("Preloaded games not found")
        }

        guard let data = try? Data(contentsOf: path, options: .mappedIfSafe) else {
            fatalError("Preloaded JSON cannot be mapped")
        }

        guard let preloadedJSON = try? JSONSerialization.jsonObject(
            with: data, options: .init(rawValue: 0)) else {
                fatalError("JSON cannot be read.")
        }

        guard let json = preloadedJSON as? NSDictionary else {
            fatalError("JSON cannot be mapped to NSDictionary")
        }

        var futures = [Future<StoredGame, CoreDataManagerError>]()
        for game in json.allValues {
            guard let gameDict = game as? NSDictionary else {
                fatalError("Preloaded game cannot be decoded to NSDictionary")
            }

            let storedGame = mapJSONtoStoredGame(json: gameDict)
            storedGame.isPreloaded = true
            futures.append(cdm.save(storedGame))
        }

        return futures.sequence().andThen { _ in
            // Mark the user's games as preloaded
            UserDefaults.standard.set(true, forKey: "preloaded")
        }
    }

    /// Returns an array of all custom games stored in memory.
    /// - Returns: array of StoredGame in storage
    public func getAllCustomGames() -> Future<[StoredGame], CoreDataManagerError> {
        return cdm.loadAll()
            .map { games in
                return games.filter { !$0.isPreloaded }
        }
    }

    /// Returns an array of all preloaded games in memory.
    /// - Returns: array of StoredGame in storage
    public func getAllPreloadedGames() -> Future<[StoredGame], CoreDataManagerError> {
        return cdm.loadAll()
            .map { games in
                return games.filter { $0.isPreloaded }
        }
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
        return osm.load(uuid)
            .map { json -> StoredGame in
                let game = self.mapJSONtoStoredGame(json: json!)
                game.isDownloaded = true

                return game
            }
            .andThen { storedGame in
                guard let game = storedGame.value else {
                    fatalError("Stored game is not loaded")
                }

                let _ = self.cdm.save(game)
        }
    }

    /// Loads a preview of all the games loaded on Firebase.
    /// - Returns: array of GamePreviews
    public func loadAllPreviews() -> Future<[PreviewGame], OnlineStorageManagerError> {
        let auth = AuthManager.shared
        guard auth.loggedIn else {
            fatalError("User needs to be logged in before accessing marketplace")
        }

        let ownerId: String
        if let googleId = auth.googleProfile?.userId {
            ownerId = googleId
        } else if let facebookId = auth.facebookToken?.userId {
            ownerId = facebookId
        } else {
            fatalError("User needs to be logged in before accessing marketplace")
        }

        return osm.loadAll()
            .map { games in
                return games.filter { $0.ownerID != ownerId }
        }
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

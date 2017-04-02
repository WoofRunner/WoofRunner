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

    // MARK: - Private class variables

    private static var instance: GameStorageManager?

    // MARK: - Private variables

    private let osm = OnlineStorageManager.getInstance()
    private let cdm = CoreDataManager.getInstance()

    // MARK: - Private initializer

    private init() {}

    // MARK: - Public static methods

    /// Returns an instance of GameStorageManager.
    /// - Returns: the single GameStorageManager that exists
    public static func getInstance() -> GameStorageManager {
        if let existingInstance = instance {
            return existingInstance
        } else {
            instance = GameStorageManager()
            return instance!
        }
    }

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

    // MARK: - Private methods

    /// Loads a preview of all the games loaded on Firebase.
    /// - Returns: array of GamePreviews
    private func loadAllPreviews() -> Future<NSDictionary?, OnlineStorageManagerError> {
        // TODO: Update this method to load previews instead of actual games
        return osm.loadAll()
    }

    private func mapJSONtoStoredGame(json: NSDictionary) -> StoredGame {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storedGame = StoredGame(
            context: appDelegate.coreDataStack.persistentContainer.viewContext)

        storedGame.uuid = json.value(forKey: "uuid") as? String
        storedGame.ownerId = json.value(forKey: "ownerId") as? String

        let platforms: [StoredPlatform]
        if let JSONPlatforms = json.value(forKey: "platforms") {
            platforms = mapJSONtoStoredPlatforms(
                json: JSONPlatforms as! [NSDictionary])
        } else {
            platforms = []
        }

        let obstacles: [StoredObstacle]
        if let JSONObstacles = json.value(forKey: "obstacles") {
            obstacles = mapJSONtoStoredObstacles(
                json: JSONObstacles as! [NSDictionary])
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        var res = [StoredPlatform]()
        for platformJSON in json {
            let platform = StoredPlatform(
                context: appDelegate.coreDataStack.persistentContainer.viewContext)

            platform.positionX = Int16(platformJSON.value(forKey: "positionX") as! String)!
            platform.positionY = Int16(platformJSON.value(forKey: "positionY") as! String)!
            platform.type = platformJSON.value(forKey: "type") as? String

            res.append(platform)
        }

        return res
    }

    private func mapJSONtoStoredObstacles(json: [NSDictionary]) -> [StoredObstacle] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        var res = [StoredObstacle]()
        for obstacleJSON in json {
            let obstacle = StoredObstacle(
                context: appDelegate.coreDataStack.persistentContainer.viewContext)

            obstacle.positionX = Int16(obstacleJSON.value(forKey: "positionX") as! String)!
            obstacle.positionY = Int16(obstacleJSON.value(forKey: "positionY") as! String)!
            obstacle.radius = Int16(obstacleJSON.value(forKey: "radius") as! String)!
            obstacle.type = obstacleJSON.value(forKey: "type") as? String

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

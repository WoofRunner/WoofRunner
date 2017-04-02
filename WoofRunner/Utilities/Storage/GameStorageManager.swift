//
//  GameStorageManager.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/27/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

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
    public func downloadGame(uuid: String) -> Future<NSDictionary?, OnlineStorageManagerError> {
        return osm.load(uuid)
    }

    // MARK: - Private methods

    /// Loads a preview of all the games loaded on Firebase.
    /// - Returns: array of GamePreviews
    private func loadAllPreviews() -> Future<NSDictionary?, OnlineStorageManagerError> {
        // TODO: Update this method to load previews instead of actual games
        return osm.loadAll()
    }

}

public enum GameStorageManagerError: Error {
    case GameNotFound
    case GamesNotLoaded
    case GameNotUploaded
    case GameNotDownloaded
}

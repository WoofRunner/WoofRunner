//
//  GameStorageManager.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/27/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import RxSwift

/**
 Singleton method to handle game storage, both online and offline.
 */
public class GameStorageManager {

    // MARK: - Private class variables

    private static var instance: GameStorageManager?

    // MARK: - Private variables

    private let osm = OnlineStorageManager.getInstance()
    private let cdm = CoreDataManager.getInstance()
    public private(set) var games = Variable<[String: UploadableGame]>([:])

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
    public func getAllGames() -> [UploadableGame] {
        let res = [UploadableGame]()

        for (uuid, game) in games.value {
            print(uuid)
            print(game)
            // TODO: Map StoredGame to UploadableGame
        }

        return res
    }

    /// Returns all games created by the owner that have been uploaded to the marketplace.
    /// - Returns: array of UploadableGame that has been uploaded
    public func getUploadedGames() -> [UploadableGame] {
        let res = [UploadableGame]()

        for (uuid, game) in games.value {
            // TODO: Map StoredGame to UploadableGame
            print(uuid)
            print(game)
        }

        return res
    }

    public func getGame(uuid: String) -> UploadableGame? {
        // Loads the game from memory.
        return games.value[uuid]
    }

    /// Saves the game to CoreData.
    public func saveGame(_ game: UploadableGame) {
        // Saves the game to CoreData.
        reloadGames()
    }

    /// Uploads the game with the corresponding UUID to Firebase.
    /// - Parameters:
    ///     - uuid: UUID string of the game to upload
    public func uploadGame(uuid: String) {
        // Uploads the game with UUID in `games` to Firebase
    }

    /// Downloads the game with the corresponding UUID from Firebase into CoreData.
    /// - Parameters:
    ///     - uuid: UUID string of the game to download
    public func downloadGame(uuid: String) {
        // Get the game from downloaded games from Firebase and save it to CoreData.
        // Reload games from CoreData.
    }

    // MARK: - Private methods

    /// Reloads all games from CoreData and store them in memory.
    private func reloadGames() {
    }

}

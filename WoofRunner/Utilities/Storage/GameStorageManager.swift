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
    public private(set) var games = Variable<[String: StoredGame]>([:])

    public private(set) var error = Variable<Bool>(false)
    private var retryCount = 0

    // MARK: - Private initializer

    private init() {
        reloadGames()
    }

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
    public func getAllGames() -> [StoredGame] {
        return games.value.map { (_, game) in game }
    }

    /// Returns all games created by the owner that have been uploaded to the marketplace.
    /// - Returns: array of UploadableGame that has been uploaded
    public func getUploadedGames() -> [StoredGame] {
        let res = [StoredGame]()

        for (uuid, game) in games.value {
            // TODO: Persist a list of uploaded games
            print(uuid)
            print(game)
        }

        return res
    }

    public func getGame(uuid: String) -> StoredGame? {
        // Loads the game from memory.
        return games.value[uuid]
    }

    /// Saves the game to CoreData.
    public func saveGame(_ game: SaveableGame) {
        cdm.save(game)
            .onSuccess { _ in
                self.reloadGames()
            }
            .onFailure { _ in
                // TODO: Throw an error here
            }
    }

    /// Uploads the game with the corresponding UUID to Firebase.
    /// - Parameters:
    ///     - uuid: UUID string of the game to upload
    public func uploadGame(uuid: String) {
        guard let storedGame = games.value[uuid] else {
            // TODO: Throw an error here.
            return
        }

        osm.save(storedGame)
    }

    /// Downloads the game with the corresponding UUID from Firebase into CoreData.
    /// - Parameters:
    ///     - uuid: UUID string of the game to download
    public func downloadGame(uuid: String) {
        // Get the game from downloaded games from Firebase and save it to CoreData.
        osm.load(uuid).onSuccess { game in
            self.cdm.context.sync(
                [game as! [String: Any]], inEntityNamed: "StoredGame") { _ in
                self.reloadGames()
            }
        }
        .onFailure { error in
            // TODO: Throw error here
        }
    }

    // MARK: - Private methods

    /// Reloads all games from CoreData and store them in memory.
    private func reloadGames() {
        cdm.loadAll()
            .onSuccess { games in
                for game in games {
                    self.games.value[game.uuid!] = game
                }

                // Error handling
                self.retryCount = 0
                self.error.value = false
            }
            .onFailure { _ in
                // Retry for 5 times before displaying error
                if self.retryCount < 5 {
                    self.reloadGames()
                    self.retryCount += 1
                } else {
                    self.error.value = true
                }
        }
    }

}

public enum GameStorageManagerError: Error {
    case GameNotFound
    case GamesNotLoaded
    case GameNotUploaded
    case GameNotDownloaded
}

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

    /// Returns an instance of GameStorageManager
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

    public func getAllGames() -> [UploadableGame] {
        let res = [UploadableGame]()

        for (uuid, game) in games.value {
            // TODO: Map StoredGame to UploadableGame
            print(uuid)
            print(game)
        }

        return res
    }

    public func getLocalGames() -> [UploadableGame] {
        let res = [UploadableGame]()

        for (uuid, game) in games.value {
            print(uuid)
            print(game)
            // TODO: Map StoredGame to UploadableGame
        }

        return res
    }

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
        // Checks between local games and online games before making the call to load from Firebase
        return nil
    }

    public func saveGame(_ game: UploadableGame) {
        // Saves the game to CoreData
    }

    public func uploadGame(uuid: String) {
        // Gets the game from loaded games from CoreData and upload to Firebase
    }

    public func downloadGame(uuid: String) {
        // Get the game from downloaded games from Firebase and save it to CoreData
    }

}

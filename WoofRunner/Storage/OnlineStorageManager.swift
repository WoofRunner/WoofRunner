//
//  OnlineStorageManager.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/15/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseDatabase
import BrightFutures
import Result

/**
 Singleton that manages the online storage of the user created games.
 */
public class OnlineStorageManager {

    // MARK: - Private static variables
    private static var instance: OnlineStorageManager?

    // MARK: - Private variables
    private let ref: FIRDatabaseReference

    // MARK: - Private constants
    private static let GAMES = "games"

    // MARK: - Initializers
    private init(reference: FIRDatabaseReference) {
        self.ref = reference
    }

    convenience private init() {
        self.init(reference: FIRDatabase.database().reference(withPath: OnlineStorageManager.GAMES))
    }

    // MARK: - Public methods

    /// Gets the singleton instance with the default reference.
    /// - Returns: singleton instance of OnlineStorageManager
    public static func getInstance() -> OnlineStorageManager {
        if let singleton = instance {
            return singleton
        } else {
            instance = OnlineStorageManager()
            return instance!
        }
    }

    /// Gets the singleton instance with a reference.
    /// (Normally for testing purposes)
    /// - Parameters:
    ///     - with: Firebase DB reference to instantiate OnlineStorageManager with
    /// - Returns: singleton instance of OnlineStorageManager
    public static func getInstance(with reference: FIRDatabaseReference) -> OnlineStorageManager {
        if let singleton = instance {
            return singleton
        } else {
            instance = OnlineStorageManager(reference: reference)
            return instance!
        }
    }

    public static func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

        return formatter
    }

    /// Loads a game using its UUID.
    /// - Parameters:
    ///     - uuid: UUID of the game that is requested
    /// - Returns: Future that contains an NSDictionary representing the game object
    public func load(_ uuid: String) -> Future<NSDictionary?, OnlineStorageManagerError> {
        return Future { complete in
            ref.child(uuid).observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                complete(.success(value))
            }) { error in
                complete(.failure(OnlineStorageManagerError.FetchError))
            }
        }
    }

    /// Loads all game from Firebase database.
    public func loadAll() -> Future<[PreviewGame], OnlineStorageManagerError> {
        return Future { complete in
            ref.observeSingleEvent(of: .value, with: { snapshot in
                let games: [NSDictionary]
                let value = snapshot.value as? NSDictionary
                if let values = value?.allValues {
                    games = values as! [NSDictionary]
                } else {
                    games = []
                }

                games.map { self.mapJSONtoPreviewGame(json: $0) }
                    .sequence()
                    .onSuccess { previews in
                        complete(.success(previews))
                }
            }) { error in
                complete(.failure(OnlineStorageManagerError.FetchError))
            }
        }
    }

    /// Uploads a StoredGame into Firebase database.
    /// - Parameters:
    ///     - game: game model object that extends Serializable
    public func save(_ game: StoredGame) {
        let auth = AuthManager.shared
        guard let ownerId = auth.facebookToken?.userId else {
            fatalError("Cannot call OSM save game when user is unauthenticated")
        }

        game.ownerId = ownerId
        ref.child(game.uuid!).setValue(mapToJSON(game: game))
    }

    /// Clears all game data in online storage manager
    public func clear() {
        ref.setValue([])
    }

    // MARK: - Private methods

    private func mapToJSON(game: StoredGame) -> NSDictionary {
        var gameJSON = [String: Any]()

        gameJSON["uuid"] = game.uuid
        gameJSON["ownerId"] = game.ownerId
        gameJSON["rows"] = game.rows
        gameJSON["columns"] = game.columns

        gameJSON["obstacles"] = mapObstaclesToJSON(game: game)
        gameJSON["platforms"] = mapPlatformsToJSON(game: game)

        let formatter = OnlineStorageManager.getDateFormatter()
        gameJSON["createdAt"] = formatter.string(from: game.createdAt as! Date)
        gameJSON["updatedAt"] = formatter.string(from: game.updatedAt as! Date)

        return NSDictionary(dictionary: gameJSON)
    }

    private func mapObstaclesToJSON(game: StoredGame) -> [NSDictionary] {
        guard let obstacles = game.obstacles else {
            return []
        }

        var res = [NSDictionary]()
        for item in obstacles {
            let obstacle = item as! StoredObstacle
            var obstacleJSON = [String: Any]()

            obstacleJSON["positionX"] = obstacle.positionX
            obstacleJSON["positionY"] = obstacle.positionY
            obstacleJSON["type"] = obstacle.type

            res.append(NSDictionary(dictionary: obstacleJSON))
        }

        return res
    }

    private func mapPlatformsToJSON(game: StoredGame) -> [NSDictionary] {
        guard let platforms = game.platforms else {
            return []
        }

        var res = [NSDictionary]()
        for item in platforms {
            let platform = item as! StoredPlatform
            var platformJSON = [String: Any]()

            platformJSON["positionX"] = platform.positionX
            platformJSON["positionY"] = platform.positionY
            platformJSON["type"] = platform.type

            res.append(NSDictionary(dictionary: platformJSON))
        }

        return res
    }

    private func mapJSONtoPreviewGame(json: NSDictionary) -> Future<PreviewGame, NoError> {
        return Future { complete in
            let formatter = OnlineStorageManager.getDateFormatter()
            var preview = PreviewGame(
                uuid: json.value(forKey: "uuid") as! String,
                name: json.value(forKey: "name") as! String,
                ownerID: json.value(forKey: "ownerId") as! String,
                ownerName: nil,
                createdAt: formatter.date(from: json.value(forKey: "createdAt") as! String)!,
                updatedAt: formatter.date(from: json.value(forKey: "updatedAt") as! String)!
            )

            AuthManager.shared.getName(ownerId: preview.ownerID).onSuccess { name in
                preview.setOwnerName(name)
                complete(.success(preview))
            }
        }

    }

}

public enum OnlineStorageManagerError: Error {
    case FetchError
    case AuthError
}

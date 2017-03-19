//
//  OnlineStorageManager.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/15/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Firebase
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
    private let GAMES = "games"

    // MARK: - Initializers
    private init(reference: FIRDatabaseReference) {
        self.ref = reference
    }

    convenience private init() {
        self.init(reference: FIRDatabase.database().reference())
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

    /// Loads a game using its UUID.
    /// - Parameters:
    ///     - uuid: UUID of the game that is requested
    /// - Returns: Future that contains an NSDictionary representing the game object
    public func load(_ uuid: String) -> Future<NSDictionary?, OnlineStorageManagerError> {
        return Future { complete in
            ref.child(GAMES).child(uuid).observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                complete(.success(value))
            }) { error in
                complete(.failure(OnlineStorageManagerError.FetchError))
            }
        }
    }

    /// Saves the game in Firebase database.
    /// - Parameters:
    ///     - game: game model object that extends Serializable
    public func save(_ game: Serializable) {
        ref.child(GAMES).child(game.id).setValue(game.serialize())
    }

    /// Clears all game data in online storage manager
    public func clear() {
        ref.child(GAMES).setValue([])
    }

}

public enum OnlineStorageManagerError: Error {
    case FetchError
}

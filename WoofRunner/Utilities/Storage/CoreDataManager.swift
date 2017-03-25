//
//  CoreDataManager.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/11/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import CoreData
import UIKit // Imported to get default context from AppDelegate
import BrightFutures
import Result

/**
 Manages reading and writing operations from CoreData.
 
 These methods are implemented with BrightFutures, usage examples can be found in the test cases.
 Most of them returns a Future, which has two callbacks, `onSuccess` and `onFailure`.
 
 Examples can be found in the documentation here:
 http://cocoadocs.org/docsets/BrightFutures/5.1.0/
 */
public class CoreDataManager {

    // MARK: - Private variables
    private static var instance: CoreDataManager?
    private let context: NSManagedObjectContext
    private let privateContext = NSManagedObjectContext(
        concurrencyType: .privateQueueConcurrencyType)

    // MARK: - Private constants
    private static let STORED_GAME = "StoredGame"

    // MARK: - Initializers
    private init(context: NSManagedObjectContext) {
        self.context = context
        self.privateContext.parent = context
    }

    private convenience init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        self.init(context: appDelegate.coreDataStack.persistentContainer.viewContext)
    }

    // MARK: - Public methods

    /// Returns an instance of CoreDataManager
    /// - Returns: the single CoreDataManager that exists
    public static func getInstance() -> CoreDataManager {
        if let existingInstance = instance {
            return existingInstance
        } else {
            instance = CoreDataManager()
            return instance!
        }
    }

    /// Returns an instance of CoreDataManager with NSManagedObjectContext
    /// - Parameters:
    ///     - context: NSManagedContext to get CoreDataManager with
    /// - Returns: the single CoreDataManager that exists
    public static func getInstance(with context: NSManagedObjectContext) -> CoreDataManager {
        if let existingInstance = instance {
            return existingInstance
        } else {
            instance = CoreDataManager(context: context)
            return instance!
        }
    }

    /// Saves a Saveable object into CoreData.
    /// - Parameters:
    ///     - game: object that conforms to Saveable
    ///     - completion: block to be executed after game is loaded
    public func save(_ game: SaveableGame) -> Future<StoredGame, CoreDataManagerError> {
        return Future { complete in
            DispatchQueue.main.async {
                var storedGame: StoredGame

                if self.exists(game) {
                    // Force unwrap here since we know that game has to already exist in core data
                    storedGame = self.fetch(game.uuid!)!
                } else {
                    storedGame = StoredGame(context: self.context)
                    storedGame.createdAt = Date() as NSDate?
                    storedGame.uuid = game.uuid
                }

                storedGame.updatedAt = Date() as NSDate?
                self.save()

                complete(.success(storedGame))
            }
        }
    }

    /// Loads a game given its UUID from CoreData, asynchronous execution that returns a Future.
    /// - Parameters:
    ///     - uuid: UUID string of a game
    /// - Returns: a Future object with a StoredGame? object, throws FetchGameError.notFound if
    ///     game does not exist
    public func load(_ uuid: String) -> Future<StoredGame, CoreDataManagerError> {
        return Future { complete in
            DispatchQueue.main.async {
                let storedGame = self.fetch(uuid)

                if let fetchedGame = storedGame {
                    complete(.success(fetchedGame))
                } else {
                    complete(.failure(CoreDataManagerError.notFound))
                }
            }
        }
    }

    /// Loads all games from CoreData, asynchronous execution that returns a Future.
    /// - Returns: a Future object with a [StoredGame] object
    public func loadAll() -> Future<[StoredGame], NoError> {
        return Future { complete in
            DispatchQueue.main.async {
                let fetchedGames = self.fetchAll()

                complete(.success(fetchedGames))
            }
        }
    }

    /// Clears all StoredGame object in CoreData.
    public func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataManager.STORED_GAME)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        let _ = try? context.execute(deleteRequest)
    }

    // MARK: - Private methods

    /// Checks if Saveable object already exists in CoreData.
    /// - Parameters:
    ///     - game: object that conforms to Saveable
    /// - Returns: true if the game already exists in CoreData.
    private func exists(_ game: SaveableGame) -> Bool {
        let fetchRequest = generateFetchRequest(uuid: game.uuid!)

        guard let count = try? self.context.count(for: fetchRequest), count == 0 else {
            return true
        }

        return false
    }

    /// Fetches a game from context.
    /// - Parameters:
    ///     - uuid: UUID string of a game
    /// - Returns: StoredGame of the requested game, nil if game does not exist
    private func fetch(_ uuid: String) -> StoredGame? {
        let request = generateFetchRequest(uuid: uuid)
        let storedGame = try? context.fetch(request).first

        return storedGame as! StoredGame?
    }

    /// Fetches all the games from context.
    /// - Returns: an array of StoredGame, empty array if there are no games
    private func fetchAll() -> [StoredGame] {
        let request = generateFetchRequest(entity: CoreDataManager.STORED_GAME)
        let storedGames = try? context.fetch(request)

        return storedGames as! [StoredGame]
    }

    /// Generates a NSFetchRequest.
    /// - Parameters:
    ///     - uuid: UUID string of StoredGame to fetch
    /// - Returns: NSFetchRequest with UUID as predicate
    private func generateFetchRequest(uuid: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: CoreDataManager.STORED_GAME)
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid)

        return fetchRequest
    }

    /// Generates a NSFetchRequest for all entities of a single entity type.
    /// - Parameters:
    ///     - entity: name of entity to get NSFetchRequest for
    private func generateFetchRequest(entity: String) -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    }

    /// Saves the current context.
    private func save() {
        do {
            try privateContext.save()
            context.performAndWait {
                do {
                    try self.context.save()
                } catch {
                    fatalError("Failed to save to context \(error)")
                }
            }
        } catch {
            fatalError("Failed to save to context \(error)")
        }
    }

}

public enum CoreDataManagerError: Error {
    case notFound
    case coreDataError
}

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

/**
 Singleton to manage reading and writing from CoreData.
 */
public class CoreDataManager {

    public var delegate: CoreDataManagerDelegate?

    private let context: NSManagedObjectContext
    private let privateContext = NSManagedObjectContext(
        concurrencyType: .privateQueueConcurrencyType)
    private static let STORED_GAME = "StoredGame"

    public init(context: NSManagedObjectContext) {
        self.context = context
        self.privateContext.parent = context
    }

    public convenience init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        self.init(context: appDelegate.coreDataStack.persistentContainer.viewContext)
    }

    /// Saves a Saveable object into CoreData.
    /// - Parameters:
    ///     - game: object that conforms to Saveable
    ///     - completion: block to be executed after game is loaded
    public func save(_ game: Saveable) -> Future<StoredGame, CoreDataManagerError> {
        return Future { complete in
            DispatchQueue.main.async {
                var storedGame: StoredGame

                if self.exists(game) {
                    storedGame = self.fetch(game.uuid)!
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

    /// Clears all StoredGame object in CoreData.
    public func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataManager.STORED_GAME)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        let _ = try? context.execute(deleteRequest)
    }

    /// Checks if Saveable object already exists in CoreData.
    /// - Parameters:
    ///     - game: object that conforms to Saveable
    /// - Returns: true if the game already exists in CoreData.
    private func exists(_ game: Saveable) -> Bool {
        let fetchRequest = generateFetchRequest(uuid: game.uuid)

        guard let count = try? self.context.count(for: fetchRequest), count == 0 else {
            return true
        }

        return false
    }

    /// Fetches a game from context. This is a private method that does not
    /// trigger the onLoad and onRequest delegate methods.
    /// - Parameters:
    ///     - uuid: UUID string of a game
    /// - Returns: StoredGame of the requested game, nil if game does not exist
    private func fetch(_ uuid: String) -> StoredGame? {
        let request = generateFetchRequest(uuid: uuid)
        let storedGame = try? context.fetch(request).first

        return storedGame as! StoredGame?
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

/**
 Define actions to be executed before and after CoreData load/save operations.
 */
public protocol CoreDataManagerDelegate {
    func onRequest()
    func onComplete()
}

public enum CoreDataManagerError: Error {
    case notFound
    case coreDataError
}

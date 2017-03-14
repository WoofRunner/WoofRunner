//
//  CoreDataManager.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/11/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import CoreData
import UIKit // Imported to get default context from AppDelegate

/**
 Singleton to manage reading and writing from CoreData.
 */
public class CoreDataManager {

    public var delegate: CoreDataManagerDelegate?

    private let context: NSManagedObjectContext
    private static let STORED_GAME = "StoredGame"

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    public convenience init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        self.init(context: appDelegate.coreDataStack.persistentContainer.viewContext)
    }

    /// Saves a Saveable object into CoreData.
    /// - Parameters:
    ///     - game: object that conforms to Saveable
    ///     - completion: block to be executed after game is loaded
    public func save(_ game: Saveable) {
    }

    /// Loads a game given its UUID from CoreData.
    /// - Parameters:
    ///     - uuid: UUID string of a game
    public func load(_ uuid: String) {
    }

    /// Fetches a game from context. This is a private method that does not
    /// trigger the onLoad and onRequest delegate methods.
    /// - Parameters:
    ///     - uuid: UUID string of a game
    /// - Returns: StoredGame of the requested game, nil if game does not exist
    private func fetch(_ uuid: String) {
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

    /// Checks if Saveable object already exists in CoreData.
    /// - Parameters:
    ///     - game: object that conforms to Saveable
    /// - Returns: true if the game already exists in CoreData.
    private func exists(_ game: Saveable) -> Bool {
        return false
    }

    /// Saves the current context.
    private func save() {
        do {
            try context.save()
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

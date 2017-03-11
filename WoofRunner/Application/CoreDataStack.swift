//
//  CoreDataStack.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/11/2017.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import CoreData

/*
 Essential methods needed to implement data persistance via CoreData.

 Instead of initializing new project and leaving all the code in AppDelegate,
 we move it into a separate class that can be reused in different projects.

 Inspiration and code taken from:
 https://blog.jayway.com/2016/08/12/whats-new-core-data-swift-3-0/
 */
public class CoreDataStack {

    private static let CORE_DATA_CONTAINER_NAME = "WoofRunner"

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.CORE_DATA_CONTAINER_NAME)
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in

            if let error = error {
                fatalError("Unresolved error \(error)")
            }

        })

        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )

        let documentsDirectory = paths[0]

        return documentsDirectory
    }

    private func firstUserLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: "launchedBefore")
    }

}

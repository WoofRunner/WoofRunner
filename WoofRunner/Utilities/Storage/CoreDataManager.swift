//
//  CoreDataManager.swift
//  WoofRunner
//
//  Created by Xu Bili on 3/11/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import CoreData
import UIKit

/**
 Singleton to manage reading and writing from CoreData.
 */
public class CoreDataManager {

    private let context: NSManagedObjectContext

    public init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // Get context from CoreDataStack
        self.context = appDelegate.coreDataStack.persistentContainer.viewContext
    }

}

//
//  Database.swift
//  TickTask
//
//  Created by Joshua Grant on 4/23/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import CoreData

class Database
{
    static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TickTask")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error
            {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    static func save()
    {
        let context = container.viewContext
        
        if context.hasChanges
        {
            do
            {
                try context.save()
            }
            catch
            {
                print("Error saving the context: \(error)")
            }
        }
    }
}

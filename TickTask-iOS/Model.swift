//
//  Model.swift
//  TickTask-iOS
//
//  Created by Joshua Grant on 5/24/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import CoreData

class Model
{
    static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (description, error) in
            guard error == nil else { fatalError("\(String(describing: error))") }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    static func save()
    {
        do
        {
            if context.hasChanges
            {
                try context.save()
            }
        }
        catch
        {
            print("Error saving the database: \(error)")
        }
    }
}

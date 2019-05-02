//
//  TaskGroup+.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 4/24/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import CoreData

// A task group is all of the completed sessions under a given name

extension TaskGroup
{
    var totalDuration: Double {
        get {
            var total: Double = 0
            
            if let tasks = tasks
            {
                for task in tasks
                {
                    if let task = task as? Task
                    {
                        total += task.duration
                    }
                    else
                    {
                        print("This code is buggy")
                    }
                }
            }
            else
            {
                print("This code is also hard to follow. We should simplify....")
            }
            
            return total
        }
    }
    
    static func createNewTaskGroup(name: String) -> TaskGroup
    {
        let taskGroup = TaskGroup(context: Database.container.viewContext) as TaskGroup
        taskGroup.name = name
        return taskGroup
    }
    
    static func deleteTaskGroup(taskGroup: TaskGroup)
    {
        Database.container.viewContext.delete(taskGroup)
    }
    
    static func taskGroupMatching(name: String) -> TaskGroup?
    {
        let fetchRequest: NSFetchRequest<TaskGroup> = TaskGroup.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do
        {
            return try Database.container.viewContext.fetch(fetchRequest).first
        }
        catch
        {
            print("Error fetching the taskGroup: \(error)")
        }
        
        return nil
    }
    
    static func allTaskGroups() -> [TaskGroup]
    {
        let fetchRequest: NSFetchRequest<TaskGroup> = TaskGroup.fetchRequest()
        
        do
        {
            return try Database.container.viewContext.fetch(fetchRequest)
        }
        catch
        {
            print("Error fetching all task groups: \(error)")
        }
        
        return []
    }
    
    static func taskGroupsMatchingAutocompleteSegment(segment: String) -> [TaskGroup]
    {
        let fetchRequest: NSFetchRequest<TaskGroup> = TaskGroup.fetchRequest()
        fetchRequest.fetchLimit = 10
        fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", segment)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do
        {
            return try Database.container.viewContext.fetch(fetchRequest)
        }
        catch
        {
            print("Error fetching the task groups: \(error)")
        }
        
        return []
    }
    
    static func renameTaskGroup(taskGroup: TaskGroup, with newName: String)
    {
        taskGroup.name = newName
    }
    
    // 1. find a string containing any of the characters
    // 2. the strings with larger groups of characters are ordered higher in the list
}

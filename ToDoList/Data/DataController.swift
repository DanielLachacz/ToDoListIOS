//
//  DataController.swift
//  ToDoList
//
//  Created by Daniel Łachacz on 22/07/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer = NSPersistentContainer(name: "ToDoList")
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func initializeStack(/*completion: @escaping () -> Void*/) {
        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("colud not load store \(error.localizedDescription)")
                return
            }
            print("store loaded")
           // completion()
        }
    }
    
    func insertTask(title: String, description: String, date: Date) throws {
        
        let task = Task(context: self.context)
        task.title = title
        task.text = description
        task.date = date
        task.status = false
        
        self.context.insert(task)
        do {
             try self.context.save()
        } catch {
            fatalError("Failure to save new Task \(error)")
        }
    }
    
    func delete(task: Task) throws {
        self.context.delete(task)
        try self.context.save()
    }
    
    func updateTask(task: Task) throws {
        do {
        try self.context.save()
        } catch {
            fatalError("Failure to edit Task \(error)")
        }
    }
    
    func updateStatusCompleted(task: Task) throws {  // The new task status is always false.
        task.status = true                           // Thanks to the status we know if the task is done.
        try self.context.save()
    }
    
    func updateStatusActive(task: Task) throws {
        task.status = false
        try self.context.save()
    }
    
    func fetchTasks() throws -> [Task] {
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        let tasks = try self.context.fetch(request)
        return tasks
    }
    
    func fetchActiveTasks() throws -> [Task] {
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = NSPredicate(format: "status = %d", false)
       
        let tasks = try self.context.fetch(request)
        return tasks
    }
    
    func fetchCompletedTasks() throws -> [Task] {
           let request = NSFetchRequest<Task>(entityName: "Task")
           request.predicate = NSPredicate(format: "status = %d", true)
          
           let tasks = try self.context.fetch(request)
           return tasks
       }
}

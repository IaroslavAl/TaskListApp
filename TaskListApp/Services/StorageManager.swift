//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Iaroslav Beldin on 19.05.2023.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchTasks() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func createTask(withTitle title: String) -> Task {
        let task = Task(context: persistentContainer.viewContext)
        task.title = title
        saveContext()
        return task
    }
    
    func updateTask(_ task: Task, title: String) {
        task.title = title
        saveContext()
    }
    
    func deleteTask(_ task: Task){
        persistentContainer.viewContext.delete(task)
        saveContext()
    }
}

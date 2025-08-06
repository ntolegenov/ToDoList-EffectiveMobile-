//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Madi Sharipov on 06.08.2025.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    private init() {
        container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Для тестов
    static func createForTesting() -> CoreDataManager {
        let manager = CoreDataManager()
        manager.container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        return manager
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func deleteAllTodos() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoItem.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error deleting all todos: \(error)")
        }
    }
    
    func saveTodos(_ todos: [TodoModel]) {
        let context = container.viewContext
        
        for todo in todos {
            let todoItem = TodoItem(context: context)
            todoItem.id = Int32(todo.id)
            todoItem.title = todo.title
            todoItem.todoDescription = todo.description
            todoItem.isCompleted = todo.isCompleted
            todoItem.createdAt = todo.createdAt
            todoItem.userId = Int32(todo.userId)
        }
        
        save()
    }
    
    func fetchTodos() -> [TodoItem] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching todos: \(error)")
            return []
        }
    }
    
    func searchTodos(with query: String) -> [TodoItem] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR todoDescription CONTAINS[cd] %@", query, query)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error searching todos: \(error)")
            return []
        }
    }
    
    func addTodo(title: String, description: String?) {
        let context = container.viewContext
        let todoItem = TodoItem(context: context)
        todoItem.id = Int32.random(in: 1000...9999)
        todoItem.title = title
        todoItem.todoDescription = description
        todoItem.isCompleted = false
        todoItem.createdAt = Date()
        todoItem.userId = 1
        
        save()
    }
    
    func updateTodo(_ todo: TodoItem, title: String, description: String?, isCompleted: Bool) {
        todo.title = title
        todo.todoDescription = description
        todo.isCompleted = isCompleted
        
        save()
    }
    
    func deleteTodo(_ todo: TodoItem) {
        let context = container.viewContext
        context.delete(todo)
        save()
    }
}

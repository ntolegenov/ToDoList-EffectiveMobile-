//
//  TodoDetailInteractor.swift
//  ToDoList
//
//  Created by Madi Sharipov on 06.08.2025.
//

import Foundation
import CoreData

protocol TodoDetailInteractorProtocol: AnyObject {
    func loadTodo(_ todo: TodoItem?)
    func saveTodo(title: String, description: String, isCompleted: Bool)
    func deleteTodo(_ todo: TodoItem)
}

protocol TodoDetailInteractorOutput: AnyObject {
    func todoLoaded(_ todo: TodoItem?)
    func todoSaved()
    func todoDeleted()
    func saveFailed(_ error: String)
}

class TodoDetailInteractor: TodoDetailInteractorProtocol {
    weak var output: TodoDetailInteractorOutput?
    private let coreDataManager = CoreDataManager.shared
    
    func loadTodo(_ todo: TodoItem?) {
        output?.todoLoaded(todo)
    }
    
    func saveTodo(title: String, description: String, isCompleted: Bool) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            output?.saveFailed("Title cannot be empty")
            return
        }
        
        // Если у нас есть существующий todo, обновляем его
        if let existingTodo = getCurrentTodo() {
            coreDataManager.updateTodo(existingTodo, title: title, description: description, isCompleted: isCompleted)
        } else {
            // Создаем новый todo
            coreDataManager.addTodo(title: title, description: description.isEmpty ? nil : description)
        }
        
        output?.todoSaved()
    }
    
    func deleteTodo(_ todo: TodoItem) {
        coreDataManager.deleteTodo(todo)
        output?.todoDeleted()
    }
    
    private func getCurrentTodo() -> TodoItem? {
        // В реальном приложении здесь была бы логика для получения текущего todo
        // Для простоты возвращаем nil
        return nil
    }
}

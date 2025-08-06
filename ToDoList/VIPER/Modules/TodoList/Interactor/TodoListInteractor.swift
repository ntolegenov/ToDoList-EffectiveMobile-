//
//  TodoListInteractor.swift
//  ToDoList
//
//  Created by Madi Sharipov on 06.08.2025.
//

import Foundation
import CoreData

protocol TodoListInteractorProtocol: AnyObject {
    func loadTodos()
    func searchTodos(query: String)
    func deleteTodo(_ todo: TodoItem)
    func toggleTodoCompletion(_ todo: TodoItem)
}

protocol TodoListInteractorOutput: AnyObject {
    func todosLoaded(_ todos: [TodoItem])
    func todosSearched(_ todos: [TodoItem])
    func todoDeleted()
    func todoUpdated()
    func loadingStarted()
    func loadingFailed(_ error: String)
}

class TodoListInteractor: TodoListInteractorProtocol {
    weak var output: TodoListInteractorOutput?
    private let coreDataManager = CoreDataManager.shared
    private let networkManager = NetworkManager.shared
    
    func loadTodos() {
        output?.loadingStarted()
        
        Task {
            do {
                // Сначала загружаем из CoreData
                let localTodos = coreDataManager.fetchTodos()
                
                await MainActor.run {
                    if localTodos.isEmpty {
                        // Если локальных данных нет, загружаем с сервера
                        Task {
                            await self.loadFromServer()
                        }
                    } else {
                        self.output?.todosLoaded(localTodos)
                    }
                }
            }
        }
    }
    
    private func loadFromServer() async {
        do {
            let response = try await networkManager.fetchTodos()
            
            await MainActor.run {
                // Сохраняем в CoreData
                self.coreDataManager.saveTodos(response.todos)
                
                // Загружаем из CoreData
                let todos = self.coreDataManager.fetchTodos()
                self.output?.todosLoaded(todos)
            }
        } catch {
            await MainActor.run {
                self.output?.loadingFailed("Failed to load todos: \(error.localizedDescription)")
            }
        }
    }
    
    func searchTodos(query: String) {
        let todos = coreDataManager.searchTodos(with: query)
        output?.todosSearched(todos)
    }
    
    func deleteTodo(_ todo: TodoItem) {
        coreDataManager.deleteTodo(todo)
        output?.todoDeleted()
    }
    
    func toggleTodoCompletion(_ todo: TodoItem) {
        todo.isCompleted.toggle()
        coreDataManager.save()
        output?.todoUpdated()
    }
}

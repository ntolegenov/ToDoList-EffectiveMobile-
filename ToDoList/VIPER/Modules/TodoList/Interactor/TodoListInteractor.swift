import Foundation
import CoreData

// MARK: - Protocol TodoListInteractorProtocol
protocol TodoListInteractorProtocol: AnyObject {
    func loadTodos()
    func searchTodos(query: String)
    func deleteTodo(_ todo: TodoItem)
    func toggleTodoCompletion(_ todo: TodoItem)
}

// MARK: - Protocol TodoListInteractorOutput
protocol TodoListInteractorOutput: AnyObject {
    func todosLoaded(_ todos: [TodoItem])
    func todosSearched(_ todos: [TodoItem])
    func todoDeleted()
    func todoUpdated()
    func loadingStarted()
    func loadingFailed(_ error: String)
}

// MARK: - Class TodoListInteractor
class TodoListInteractor: TodoListInteractorProtocol {
    weak var output: TodoListInteractorOutput?
    private let coreDataManager = CoreDataManager.shared
    private let networkManager = NetworkManager.shared
    
    func loadTodos() {
        output?.loadingStarted()
        
        // Вся логика загрузки данных теперь здесь
        let localTodos = coreDataManager.fetchTodos()
        
        if localTodos.isEmpty {
            Task {
                await self.loadFromServer()
            }
        } else {
            output?.todosLoaded(localTodos)
        }
    }
    
    private func loadFromServer() async {
        do {
            let response = try await networkManager.fetchTodos()
            
            await MainActor.run {
                self.coreDataManager.saveTodos(response.todos)
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
        // Здесь мы просто сохраняем изменения в Core Data,
        // так как toggleTodoCompletion уже меняет isCompleted
        todo.isCompleted.toggle()
        coreDataManager.save()
        output?.todoUpdated()
    }
}

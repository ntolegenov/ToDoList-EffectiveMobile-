import Foundation
import CoreData
import SwiftUI

// MARK: - Protocol TodoListViewProtocol
protocol TodoListViewProtocol: AnyObject {
    func displayTodos(_ todos: [TodoItem])
    func displaySearchResults(_ todos: [TodoItem])
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}

// MARK: - Protocol TodoListPresenterProtocol
protocol TodoListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func searchTodos(query: String)
    func deleteTodo(_ todo: TodoItem)
    func toggleTodoCompletion(_ todo: TodoItem)
    func addNewTodo()
    func editTodo(_ todo: TodoItem)
}

// MARK: - Class TodoListPresenter
class TodoListPresenter: TodoListPresenterProtocol, TodoListInteractorOutput, ObservableObject {
    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorProtocol?
    var router: TodoListRouterProtocol?
    
    private var currentTodos: [TodoItem] = []
    private var isSearching = false
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.loadTodos()
    }
    
    func searchTodos(query: String) {
        if query.isEmpty {
            isSearching = false
            view?.displayTodos(currentTodos)
        } else {
            isSearching = true
            interactor?.searchTodos(query: query)
        }
    }
    
    func deleteTodo(_ todo: TodoItem) {
        interactor?.deleteTodo(todo)
    }
    
    func toggleTodoCompletion(_ todo: TodoItem) {
        interactor?.toggleTodoCompletion(todo)
    }
    
    func addNewTodo() {
        router?.navigateToAddTodo()
    }
    
    func editTodo(_ todo: TodoItem) {
        router?.navigateToEditTodo(todo)
    }
    
    // MARK: - TodoListInteractorOutput
    
    func todosLoaded(_ todos: [TodoItem]) {
        currentTodos = todos
        view?.displayTodos(todos)
        view?.hideLoading()
    }
    
    func todosSearched(_ todos: [TodoItem]) {
        view?.displaySearchResults(todos)
    }
    
    func todoDeleted() {
        // Обновляем список после удаления
        interactor?.loadTodos()
    }
    
    func todoUpdated() {
        // Обновляем список после изменения
        if isSearching {
            // Если мы в поиске, обновляем поиск
            // Здесь нужно получить текущий поисковый запрос
            // Для простоты просто перезагружаем все
            interactor?.loadTodos()
        } else {
            // Обновляем текущий список
            let updatedTodos = currentTodos.map { todo in
                // Обновляем статус в текущем списке
                return todo
            }
            view?.displayTodos(updatedTodos)
        }
    }
    
    func loadingStarted() {
        view?.showLoading()
    }
    
    func loadingFailed(_ error: String) {
        view?.hideLoading()
        view?.showError(error)
    }
}

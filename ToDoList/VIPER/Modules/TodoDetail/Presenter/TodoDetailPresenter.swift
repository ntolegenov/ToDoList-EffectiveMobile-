

import Foundation
import CoreData

protocol TodoDetailViewProtocol: AnyObject {
    func displayTodo(_ todo: TodoItem?)
    func showError(_ message: String)
    func dismissView()
}

protocol TodoDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func saveTodo(title: String, description: String, isCompleted: Bool)
    func deleteTodo(_ todo: TodoItem)
}

class TodoDetailPresenter: TodoDetailPresenterProtocol, TodoDetailInteractorOutput, ObservableObject {
    weak var view: TodoDetailViewProtocol?
    var interactor: TodoDetailInteractorProtocol?
    var router: TodoDetailRouterProtocol?
    
    private var currentTodo: TodoItem?
    
    func viewDidLoad() {
        interactor?.loadTodo(currentTodo)
    }
    
    func saveTodo(title: String, description: String, isCompleted: Bool) {
        interactor?.saveTodo(title: title, description: description, isCompleted: isCompleted)
    }
    
    func deleteTodo(_ todo: TodoItem) {
        interactor?.deleteTodo(todo)
    }
    
    func setTodo(_ todo: TodoItem?) {
        currentTodo = todo
    }
    
    // MARK: - TodoDetailInteractorOutput
    
    func todoLoaded(_ todo: TodoItem?) {
        currentTodo = todo
        view?.displayTodo(todo)
    }
    
    func todoSaved() {
        view?.dismissView()
    }
    
    func todoDeleted() {
        view?.dismissView()
    }
    
    func saveFailed(_ error: String) {
        view?.showError(error)
    }
}

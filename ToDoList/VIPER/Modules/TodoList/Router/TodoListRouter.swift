
import SwiftUI
import CoreData

protocol TodoListRouterProtocol: AnyObject {
    func navigateToAddTodo()
    func navigateToEditTodo(_ todo: TodoItem)
}

class TodoListRouter: TodoListRouterProtocol {
    weak var viewController: UIViewController?
    
    func navigateToAddTodo() {
        let addTodoView = AddTodoView()
        let hostingController = UIHostingController(rootView: addTodoView)
        viewController?.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func navigateToEditTodo(_ todo: TodoItem) {
        let editTodoView = EditTodoView(todo: todo)
        let hostingController = UIHostingController(rootView: editTodoView)
        viewController?.navigationController?.pushViewController(hostingController, animated: true)
    }
}

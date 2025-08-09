import Foundation
import SwiftUI

class TodoListViewWrapper: NSObject, TodoListViewProtocol, ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    func displayTodos(_ todos: [TodoItem]) {
        self.todos = todos
    }
    
    func displaySearchResults(_ todos: [TodoItem]) {
        self.todos = todos
    }
    
    func showLoading() {
        isLoading = true
    }
    
    func hideLoading() {
        isLoading = false
    }
    
    func showError(_ message: String) {
        errorMessage = message
    }
    
    func refreshData() {
        // Обновление данных
    }
}




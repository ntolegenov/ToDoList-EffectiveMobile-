import Foundation

struct TodoListEntity {
    let todos: [TodoItem]
    let searchQuery: String
    let isLoading: Bool
    let errorMessage: String?
}

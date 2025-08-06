//
//  TodoListEntity.swift
//  ToDoList
//
//  Created by Madi Sharipov on 06.08.2025.
//

import Foundation

struct TodoListEntity {
    let todos: [TodoItem]
    let searchQuery: String
    let isLoading: Bool
    let errorMessage: String?
}

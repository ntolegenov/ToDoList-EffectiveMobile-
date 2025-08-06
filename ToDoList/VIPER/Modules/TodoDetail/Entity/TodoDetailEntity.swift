//
//  TodoDetailEntity.swift
//  ToDoList
//
//  Created by Madi Sharipov on 06.08.2025.
//

import Foundation
import CoreData

struct TodoDetailEntity {
    let todo: TodoItem?
    let title: String
    let description: String
    let isCompleted: Bool
    let isEditing: Bool
}

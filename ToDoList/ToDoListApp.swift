//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Madi Sharipov on 06.08.2025.
//

import SwiftUI

@main
struct ToDoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TodoListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

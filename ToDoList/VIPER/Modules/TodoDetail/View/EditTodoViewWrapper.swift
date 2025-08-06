//
//  EditTodoViewWrapper.swift
//  ToDoList
//
//  Created by Madi Sharipov on 06.08.2025.
//

import SwiftUI

class EditTodoViewWrapper: NSObject, TodoDetailViewProtocol {
    private var todo: TodoItem?
    private var errorMessage: String?
    
    func displayTodo(_ todo: TodoItem?) {
        self.todo = todo
    }
    
    func showError(_ message: String) {
        errorMessage = message
    }
    
    func dismissView() {
        // Закрытие view
    }
}

struct EditTodoView: View {
    let todo: TodoItem
    @StateObject private var presenter = TodoDetailPresenter()
    @State private var title = ""
    @State private var description = ""
    @State private var isCompleted = false
    @State private var showingDeleteAlert = false
    @Environment(\.dismiss) private var dismiss
    
    private let viewWrapper = EditTodoViewWrapper()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Todo Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    Toggle("Completed", isOn: $isCompleted)
                }
                
                Section {
                    Button("Delete Todo", role: .destructive) {
                        showingDeleteAlert = true
                    }
                }
            }
            .navigationTitle("Edit Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        presenter.saveTodo(title: title, description: description, isCompleted: isCompleted)
                    }
                    .disabled(title.isEmpty)
                }
            }
            .alert("Delete Todo", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    presenter.deleteTodo(todo)
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this todo?")
            }
        }
        .onAppear {
            loadTodoData()
            setupVIPER()
            presenter.viewDidLoad()
        }
    }
    
    private func loadTodoData() {
        title = todo.title ?? ""
        description = todo.todoDescription ?? ""
        isCompleted = todo.isCompleted
    }
    
    private func setupVIPER() {
        let interactor = TodoDetailInteractor()
        let router = TodoDetailRouter()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewWrapper
        presenter.setTodo(todo)
        
        interactor.output = presenter
        
        // Получаем rootViewController более безопасным способом
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            router.viewController = window.rootViewController
        }
    }
}



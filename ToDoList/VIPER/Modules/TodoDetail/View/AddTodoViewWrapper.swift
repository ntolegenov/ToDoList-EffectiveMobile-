//
//  AddTodoViewWrapper.swift
//  ToDoList
//
//  Created by Madi Sharipov on 06.08.2025.
//

import SwiftUI

class AddTodoViewWrapper: NSObject, TodoDetailViewProtocol {
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

struct AddTodoView: View {
    @StateObject private var presenter = TodoDetailPresenter()
    @State private var title = ""
    @State private var description = ""
    @State private var isCompleted = false
    @Environment(\.dismiss) private var dismiss
    
    private let viewWrapper = AddTodoViewWrapper()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Todo Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    Toggle("Completed", isOn: $isCompleted)
                }
            }
            .navigationTitle("Add Todo")
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
        }
        .onAppear {
            setupVIPER()
            presenter.viewDidLoad()
        }
    }
    
    private func setupVIPER() {
        let interactor = TodoDetailInteractor()
        let router = TodoDetailRouter()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewWrapper
        
        interactor.output = presenter
        
        // Получаем rootViewController более безопасным способом
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            router.viewController = window.rootViewController
        }
    }
}



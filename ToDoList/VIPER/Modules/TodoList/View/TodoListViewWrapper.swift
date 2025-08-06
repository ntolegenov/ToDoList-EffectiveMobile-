//
//  TodoListViewWrapper.swift
//  ToDoList
//
//  Created by Madi Sharipov on 06.08.2025.
//

import SwiftUI

class TodoListViewWrapper: NSObject, TodoListViewProtocol {
    private var todos: [TodoItem] = []
    private var isLoading = false
    private var errorMessage: String?
    
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

struct TodoListView: View {
    @StateObject private var presenter = TodoListPresenter()
    @State private var searchText = ""
    @State private var todos: [TodoItem] = []
    @State private var isLoading = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private let viewWrapper = TodoListViewWrapper()
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar
                
                if isLoading {
                    loadingView
                } else if todos.isEmpty {
                    emptyStateView
                } else {
                    todoListView
                }
            }
            .navigationTitle("ToDo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
        .onAppear {
            setupVIPER()
            presenter.viewDidLoad()
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search todos...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchText) { _, newValue in
                    presenter.searchTodos(query: newValue)
                }
        }
        .padding()
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .foregroundColor(.gray)
                .padding(.top)
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "list.bullet")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No todos yet")
                .font(.title2)
                .foregroundColor(.gray)
            Text("Tap + to add your first todo")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    private var todoListView: some View {
        List {
            ForEach(todos, id: \.self) { todo in
                TodoRowView(todo: todo) {
                    presenter.toggleTodoCompletion(todo)
                } onEdit: {
                    presenter.editTodo(todo)
                } onDelete: {
                    presenter.deleteTodo(todo)
                }
            }
        }
    }
    
    private var addButton: some View {
        Button(action: {
            presenter.addNewTodo()
        }) {
            Image(systemName: "plus")
        }
    }
    
    private func setupVIPER() {
        let interactor = TodoListInteractor()
        let router = TodoListRouter()
        
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

struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title ?? "")
                    .strikethrough(todo.isCompleted)
                    .foregroundColor(todo.isCompleted ? .gray : .primary)
                
                if let description = todo.todoDescription, !description.isEmpty {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                if let createdAt = todo.createdAt {
                    Text(createdAt, style: .date)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 4)
    }
}



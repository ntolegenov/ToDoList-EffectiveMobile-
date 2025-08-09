import SwiftUI

// MARK: - TodoListView (SwiftUI View)
struct TodoListView: View {
    @StateObject private var presenter = TodoListPresenter()
    @StateObject private var viewWrapper = TodoListViewWrapper() // Эта строка была добавлена
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                // Заголовок и поиск
                HStack {
                    Text("Задачи")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $searchText)
                        .onChange(of: searchText) { _, newValue in
                            presenter.searchTodos(query: newValue)
                        }
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Состояния: загрузка, пусто или список
                if viewWrapper.isLoading {
                    loadingView
                } else if viewWrapper.todos.isEmpty {
                    emptyStateView
                } else {
                    todoListView
                }
            }
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .onAppear {
                setupVIPER()
                presenter.viewDidLoad()
            }
        }
        .alert("Error", isPresented: Binding<Bool>(
            get: { viewWrapper.errorMessage != nil },
            set: { _ in viewWrapper.errorMessage = nil }
        )) {
            Button("OK") {}
        } message: {
            if let message = viewWrapper.errorMessage {
                Text(message)
            }
        }
    }

    // MARK: - Private Views
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .foregroundColor(.gray)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var todoListView: some View {
        List {
            ForEach(viewWrapper.todos, id: \.self) { todo in
                TodoRowView(todo: todo) {
                    presenter.toggleTodoCompletion(todo)
                } onEdit: {
                    presenter.editTodo(todo)
                } onDelete: {
                    presenter.deleteTodo(todo)
                }
            }
            .onDelete { indexSet in
                if let index = indexSet.first {
                    presenter.deleteTodo(viewWrapper.todos[index])
                }
            }
        }
        .listStyle(.plain)
    }
    
    private var addButton: some View {
        Button(action: {
            presenter.addNewTodo()
        }) {
            Image(systemName: "plus")
        }
    }
    
    // MARK: - VIPER Setup
    
    private func setupVIPER() {
        let interactor = TodoListInteractor()
        let router = TodoListRouter()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewWrapper
        
        interactor.output = presenter
    }
}

// MARK: - TodoRowView
struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(todo.isCompleted ? .green : .blue)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title ?? "")
                    .font(.headline)
                    .strikethrough(todo.isCompleted)
                    .foregroundColor(todo.isCompleted ? .gray : .primary)
                
                if let description = todo.todoDescription, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            if !todo.isCompleted {
                Menu {
                    Button(action: onEdit) {
                        Label("Редактировать", systemImage: "pencil")
                    }
                    Button(role: .destructive, action: onDelete) {
                        Label("Удалить", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

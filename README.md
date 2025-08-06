# ToDo List App

Простое приложение для ведения списка дел (ToDo List) с возможностью добавления, редактирования, удаления задач.


## Технологии

- **SwiftUI** - для пользовательского интерфейса
- **CoreData** - для локального хранения данных
- **URLSession** - для сетевых запросов
- **async/await** - для асинхронного программирования
- **VIPER Architecture** - для архитектуры приложения
- **XCTest** - для unit тестирования

## API

Приложение использует API: `https://dummyjson.com/todos`

## Архитектура VIPER

Приложение построено с использованием архитектуры VIPER с четким разделением компонентов:

### TodoList Module:
- **View** (`TodoListView.swift`) - отображение списка задач
- **Interactor** (`TodoListInteractor.swift`) - бизнес-логика
- **Presenter** (`TodoListPresenter.swift`) - управление представлением
- **Entity** (`TodoListEntity.swift`) - модели данных
- **Router** (`TodoListRouter.swift`) - навигация

### TodoDetail Module:
- **View** (`AddTodoView.swift`, `EditTodoView.swift`) - формы добавления/редактирования
- **Interactor** (`TodoDetailInteractor.swift`) - бизнес-логика
- **Presenter** (`TodoDetailPresenter.swift`) - управление представлением
- **Entity** (`TodoDetailEntity.swift`) - модели данных
- **Router** (`TodoDetailRouter.swift`) - навигация

### Общие компоненты:
- **Models** (`TodoModel.swift`) - модели данных для API
- **Network** (`NetworkManager.swift`) - сетевой слой
- **Utils** (`CoreDataManager.swift`) - управление CoreData

## Установка и запуск

1. Клонируйте репозиторий:
```bash
git clone <repository-url>
cd ToDoList
```

2. Откройте проект в Xcode 15:
```bash
open ToDoList.xcodeproj
```

3. Выберите симулятор iPhone и нажмите Run (⌘+R)

## Тестирование

Для запуска unit тестов:

1. В Xcode выберите Product → Test (⌘+U)
2. Или в терминале:
```bash
xcodebuild -project ToDoList.xcodeproj -scheme ToDoList -destination 'platform=iOS Simulator,name=iPhone 15' test
```

### Тесты включают:
- **NetworkManagerTests** - тестирование сетевого слоя
- **CoreDataManagerTests** - тестирование работы с CoreData
- **TodoListPresenterTests** - тестирование логики презентера

## Структура проекта

```
ToDoList/
├── ToDoList/
│   ├── VIPER/
│   │   ├── Common/
│   │   │   ├── Models/
│   │   │   ├── Network/
│   │   │   └── Utils/
│   │   └── Modules/
│   │       ├── TodoList/
│   │       │   ├── Entity/
│   │       │   ├── Interactor/
│   │       │   ├── Presenter/
│   │       │   ├── Router/
│   │       │   └── View/
│   │       └── TodoDetail/
│   │           ├── Entity/
│   │           ├── Interactor/
│   │           ├── Presenter/
│   │           ├── Router/
│   │           └── View/
│   ├── ToDoListApp.swift
│   └── Persistence.swift
├── ToDoListTests/
│   ├── NetworkManagerTests.swift
│   ├── CoreDataManagerTests.swift
│   └── TodoListPresenterTests.swift
└── README.md
```


## Требования

- Xcode 15+
- iOS 17.0+
- Swift 5.0+


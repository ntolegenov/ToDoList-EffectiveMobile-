# ToDo List App

Простое приложение для ведения списка дел (ToDo List) с возможностью добавления, редактирования, удаления задач.

## Функциональность

### Основные возможности:
- ✅ Отображение списка задач на главном экране
- ✅ Каждая задача содержит: название, описание, дату создания и статус (выполнена/не выполнена)
- ✅ Добавление новой задачи
- ✅ Редактирование существующей задачи
- ✅ Удаление задачи
- ✅ Поиск по задачам
- ✅ Загрузка списка задач из API при первом запуске
- ✅ Многопоточность для всех операций
- ✅ Сохранение данных в CoreData
- ✅ Восстановление данных при повторном запуске
- ✅ Unit тесты для основных компонентов
- ✅ Совместимость с Xcode 15

### Бонусные возможности:
- ✅ Архитектура VIPER с четким разделением компонентов

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

## Многопоточность

Все операции выполняются в фоновом потоке с использованием `async/await`:
- Загрузка данных из API
- Сохранение/загрузка из CoreData
- Поиск задач
- Добавление/редактирование/удаление задач

UI остается отзывчивым во время выполнения операций.

## CoreData

Приложение использует CoreData для локального хранения:
- Модель `TodoItem` с полями: id, title, todoDescription, isCompleted, createdAt, userId
- Автоматическое сохранение при изменениях
- Восстановление данных при запуске приложения

## Git

Проект использует Git для контроля версий с соответствующим `.gitignore` файлом.

## Требования

- Xcode 15+
- iOS 17.0+
- Swift 5.0+

## Автор

Madi Sharipov

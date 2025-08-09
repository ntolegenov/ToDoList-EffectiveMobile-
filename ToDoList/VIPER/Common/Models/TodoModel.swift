import Foundation


struct TodoModel: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String?
    let isCompleted: Bool
    let userId: Int
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description = "todo"
        case isCompleted = "completed"
        case userId
        case createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        userId = try container.decode(Int.self, forKey: .userId)
        createdAt = Date() // API не предоставляет дату создания, используем текущую
    }
    
    init(id: Int, title: String, description: String?, isCompleted: Bool, userId: Int, createdAt: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.userId = userId
        self.createdAt = createdAt
    }
}

struct TodoResponse: Codable {
    let todos: [TodoModel]
    let total: Int
    let skip: Int
    let limit: Int
}

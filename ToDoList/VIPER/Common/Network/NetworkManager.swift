import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://jsonplaceholder.typicode.com/todos"
    
    private init() {}
    
    func fetchTodos() async throws -> TodoResponse {
        guard let url = URL(string: "\(baseURL)/todos") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw NetworkError.serverError("Server returned an error with status code: \(statusCode)")
        }
        
        do {
            let todoResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
            return todoResponse
        } catch {
            throw NetworkError.decodingError
        }
    }
}

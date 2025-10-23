//
//  TodoServiceProtocol.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/12/25.
//

import Foundation

protocol TodoServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void)
}

final class TodoService: TodoServiceProtocol {
    
    private let session: URLSession
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    init(session: URLSession = .shared) {
         self.session = session
     }
     
    
    func fetchTodos(completion: @escaping (Result<[Todo], any Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/todos") else {
            completion(.failure(TodoServiceError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            // 네트워크 에러 체크
            if let error = error {
                completion(.failure(TodoServiceError.networkError(error)))
                return
            }
            
            // HTTP 상태 코드 체크
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                let statusError = NSError(
                    domain: "HTTPError",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode)"]
                )
                completion(.failure(TodoServiceError.networkError(statusError)))
                return
            }
            
            // 데이터 존재 여부 체크
            guard let data = data else {
                completion(.failure(TodoServiceError.noData))
                return
            }
            
            // JSON 디코딩
            do {
                let decoder = JSONDecoder()
                let todos = try decoder.decode([Todo].self, from: data)
                completion(.success(todos))
            } catch {
                completion(.failure(TodoServiceError.decodingError))
            }
        }
        
        task.resume()
    }
}


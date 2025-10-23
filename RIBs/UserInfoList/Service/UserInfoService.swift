//
//  UserInfoService.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/8/25.
//

import Foundation

protocol UserInfoServiceProtocol {
    func fetchUserInfos(completion: @escaping (Result<[User], Error>) -> Void)
}

final class UserInfoService: UserInfoServiceProtocol {
    
    private let session = URLSession.shared
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    func fetchUserInfos(completion: @escaping (Result<[User], Error>) -> Void) {
           guard let url = URL(string: "\(baseURL)/users") else {
               completion(.failure(UserServiceError.invalidURL))
               return
           }
           
           session.dataTask(with: url) { data, response, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               
               guard let data = data else {
                   completion(.failure(UserServiceError.noData))
                   return
               }
               
               do {
                   let users = try JSONDecoder().decode([User].self, from: data)
                   completion(.success(users))
               } catch {
                   completion(.failure(error))
               }
           }.resume()
       }
}

// MARK: - UserServiceError

enum UserServiceError: Error, LocalizedError {
    case invalidURL
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다"
        case .noData:
            return "데이터를 받아올 수 없습니다"
        }
    }
}

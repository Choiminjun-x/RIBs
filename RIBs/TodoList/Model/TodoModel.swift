//
//  TodoModel.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/12/25.
//

import Foundation

struct Todo: Codable {
    let id: Int
    let userId: Int
    let title: String
    var completed: Bool
}

// MARK: - Custom Errors
enum TodoServiceError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .noData:
            return "데이터가 없습니다."
        case .decodingError:
            return "데이터 파싱에 실패했습니다."
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        }
    }
}

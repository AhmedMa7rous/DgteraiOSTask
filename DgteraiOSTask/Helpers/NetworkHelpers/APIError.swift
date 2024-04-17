//
//  APIError.swift
//  DgteraiOSTask
//
//  Created by Ahmed Mahrous on 16/04/2024.
//

import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed
    case encodingFailed
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.decodingFailed, .decodingFailed):
            return true
        case (.encodingFailed, .encodingFailed):
            return true
        case (.requestFailed(let error1), .requestFailed(let error2)):
            return "\(error1)" == "\(error2)"
        default:
            return false
        }
    }
}

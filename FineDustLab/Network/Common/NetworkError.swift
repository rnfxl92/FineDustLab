//
//  NetworkError.swift
//  Pagination
//
//  Created by 김종권 on 2021/09/30.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
    case invalidAuth
    case serverError
    case transportError
    case unknown
    
    init(_ afError: AFError) {
        switch afError {
        case .invalidURL:
            self = .invalidURL
        default:
            self = .serverError
        }
    }
}

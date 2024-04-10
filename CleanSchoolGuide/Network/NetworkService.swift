//
//  NetworkService.swift
//  FineDustLab
//
//  Created by 박성민 on 4/7/24.
//

import Foundation
import Combine
import Alamofire

final class NetworkService {
    
    static let shared = NetworkService()
        
    func request<R: Decodable>(_ endpoint: Endpoint<R>) -> AnyPublisher<R, Error> {
   
        let urlString = endpoint.baseURL + endpoint.path
        print(urlString)
        let encoding: ParameterEncoding
        // 리퀘스트 메소드를 지정. GET인 경우 URL 파라미터/ 기타의 경우 JSON 파라미터 바디
        switch endpoint.method {
        case .get:
            encoding = URLEncoding.default
        default:
            encoding = JSONEncoding.default
        }
        return AF.request(
            urlString,
            method: endpoint.method,
            parameters: endpoint.method == .get ? endpoint.queryParameters?.toDictionary(): endpoint.bodyParameters?.toDictionary(),
            encoding: encoding,
            headers: HTTPHeaders(endpoint.headers ?? [:])
        )
        .publishDecodable(type: R.self)
        .value()
        .retry(3)
        .mapError(NetworkError.init(_:))
        .eraseToAnyPublisher()
    }
    
}


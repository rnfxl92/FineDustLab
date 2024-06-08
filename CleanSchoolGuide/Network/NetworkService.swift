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
    
    func download<R: Decodable>(_ endPoint: Endpoint<R>, completion: ((Bool) -> Void)?){
        let url = endPoint.baseURL + endPoint.path
        // 파일매니저
        let fileManager = FileManager.default
        // 앱 경로
        let appURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // 파일 경로 생성
        
        let fileURL = appURL.appendingPathComponent("\(Date.now.toString(dateFormat: .MMddahmm)).xlsx")
        // 파일 경로 지정 및 다운로드 옵션 설정 ( 이전 파일 삭제 , 디렉토리 생성 )
        let destination: DownloadRequest.Destination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        // 다운로드 시작
        AF.download(
            url,
            method: .get,
            parameters: endPoint.queryParameters?.toDictionary(),
            encoding: JSONEncoding.default,
            to: destination
        ).downloadProgress { (progress) in
//            // 이 부분에서 프로그레스 수정
//            self.progressView.progress = Float(progress.fractionCompleted)
//            self.progressLabel.text = "\(Int(progress.fractionCompleted * 100))%"
        }.response{ response in
            if response.error != nil {
                completion?(false)
            } else {
                completion?(true)
            }
        }
        
    }
    
}


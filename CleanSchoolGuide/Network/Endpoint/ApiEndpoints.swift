//
//  ApiEndpoints.swift
//  FineDustLab
//
//  Created by 박성민 on 4/6/24.
//

import Foundation

import Alamofire

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var queryParameters: Encodable? { get }
    var bodyParameters: Encodable? { get }
    var headers: [String: String]? { get }
}

protocol Responsable {
    associatedtype Response
}

class Endpoint<R: Decodable>: Requestable, Responsable {
    typealias Response = R

    var baseURL: String
    var path: String
    var method: Alamofire.HTTPMethod
    var queryParameters: Encodable?
    var bodyParameters: Encodable?
    var headers: [String: String]?

    init(baseURL: String,
         path: String = "",
         method: Alamofire.HTTPMethod = .get,
         queryParameters: Encodable? = nil,
         bodyParameters: Encodable? = nil,
         headers: [String: String]? = [:]
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.headers = headers
    }
}

struct APIEndpoints {
    
    static func getSchoolInfo(with schoolName: SchoolSearchRequestDto) -> Endpoint<SchoolInfoWrapper> {
        
        return Endpoint(baseURL: "https://open.neis.go.kr/hub",
                        path: "/schoolInfo",
                        method: .get,
                        queryParameters: schoolName
                        
        )
    }
    
    static func getSurveyData(with type: SurveyRequestDto) -> Endpoint<SurveyData?> {
        return Endpoint(
            baseURL: "https://finedustlab-api-ko.net",
            path: "/survey/data",
            method: .get,
            queryParameters: type
        )
    }
    
    static func postSurveyData(with surveyData: SetSurveyReqeustDto) -> Endpoint<EmptyData?> {
        
        return Endpoint(
            baseURL: "https://finedustlab-api-ko.net",
            path: "/survey/set",
            method: .post,
            bodyParameters: surveyData
        )
    }
    
    static func getWeaher(with location: WeatherRequestDto) -> Endpoint<WeatherModel?> {
        
        return Endpoint(
            baseURL: "https://finedustlab-api-ko.net",
            path: "/weather/get",
            method: .get,
            queryParameters: location
        )
    }
    
    static func getExternalFineStatus(with location: ExternalFineStatusRequestDto) -> Endpoint<FineStatusModel?> {
        
        return Endpoint(
            baseURL: "https://finedustlab-api-ko.net",
            path: "/finestatus/get",
            method: .get,
            queryParameters: location
        )
    }
    
    static func getIntertalFineStatus(with schoolInfo: InternalFineStatusRequestDto) -> Endpoint<InternalFineStatusModel?> {
        
        return Endpoint(
            baseURL: "https://finedustlab-api-ko.net",
            path: "/classroom/get",
            method: .get,
            queryParameters: schoolInfo
        )
    }
    
    static func postClassroomFineData(with data: FineDustPostRequestDto) -> Endpoint<EmptyData?> {
        
        return Endpoint(
            baseURL: "https://finedustlab-api-ko.net",
            path: "/classroom/set",
            method: .post,
            bodyParameters: data
        )
    }
    
    static func postUserData(with data: SaveUserProfileDto) -> Endpoint<EmptyData?> {
        
        return Endpoint(
            baseURL: "https://finedustlab-api-ko.net",
            path: "/user/set",
            method: .post,
            bodyParameters: data
        )
    }
    
    static func getUserData(with data: getUserProfileDto) -> Endpoint<ServerUserModel> {
        return Endpoint(
            baseURL: "https://finedustlab-api-ko.net",
            path: "/user/get",
            method: .get,
            queryParameters: data
        )
    }
    
}

extension Encodable {
    func toDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonData = try JSONSerialization.jsonObject(with: data)
            return jsonData as? [String: Any]
        } catch {
            return nil
        }
    }
}

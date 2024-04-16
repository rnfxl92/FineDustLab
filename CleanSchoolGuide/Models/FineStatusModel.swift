//
//  FineStatusModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/16/24.
//

import Foundation

struct FineStatusModel: Codable {
    let result: String
    let finedustFactor: String?
    let ultrafineFactor: String?
    let status: Status?
    
    enum CodingKeys: String, CodingKey {
        case result
        case finedustFactor = "finedust_factor"
        case ultrafineFactor = "ultrafine_factor"
        case status
    }
    
    enum Status: String, Codable {
        case good
        case bad
        
        var description: String {
            switch self {
            case .good:
                return "좋아요"
            case .bad:
                return "안좋아요"
            }
        }
    }
}

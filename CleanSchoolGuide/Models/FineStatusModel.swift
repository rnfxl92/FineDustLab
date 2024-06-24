//
//  FineStatusModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/16/24.
//

import UIKit

struct FineStatusModel: Codable {
    let result: String
    let finedustFactor: String?
    let ultrafineFactor: String?
    let ultraStatus: Status?
    let fineStatus: Status?
    
    enum CodingKeys: String, CodingKey {
        case result
        case finedustFactor = "finedust_factor"
        case ultrafineFactor = "ultrafine_factor"
        case ultraStatus = "ultra_status"
        case fineStatus = "fine_status"
    }
    
    enum Status: String, Codable {
        case good
        case fine
        case bad
        case very_bad = "very bad"
        
        var description: String {
            switch self {
            case .good:
                return "좋음"
            case .fine:
                return "보통"
            case .bad:
                return "나쁨"
            case .very_bad:
                return "매우 나쁨"
                
            }
        }
        
        var fontColor: UIColor {
            switch self {
            case .good:
                return .blue300
            case .fine:
                return .green300
            case .bad:
                return .orange300
            case .very_bad:
                return .red200
            }
        }
        
        var image: UIImage {
            switch self {
            case .good:
                return .imgGood
            case .fine:
                return .imgOkay
            case .bad:
                return .imgBad
            case .very_bad:
                return .imgVeryBad
            }
        }
    }
}

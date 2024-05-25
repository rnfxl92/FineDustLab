//
//  InternalFindStatusModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/17/24.
//

import UIKit

struct InternalFineStatusModel: Codable {
    let finedustFactor: Int
    let ultrafineFactor: Int
    let ultraStatus: Status?
    let fineStatus: Status?
    
    enum CodingKeys: String, CodingKey {
        case finedustFactor = "finedust_factor"
        case ultrafineFactor = "ultrafine_factor"
        case ultraStatus = "ultra_status"
        case fineStatus = "fine_status"
    }
    
    enum Status: String, Codable {
        case good
        case okay
        case bad
        
        var description: String {
            switch self {
            case .good:
                return "좋아요!"
            case .okay:
                return "괜찮아요"
            case .bad:
                return "안좋아요"
            }
        }
        
        var fontColor: UIColor {
            switch self {
            case .good:
                return .orange300
            case .okay:
                return .orange300
            case .bad:
                return .gray600
            }
        }
        
        var image: UIImage {
            switch self {
            case .good:
                return .imgGood
            case .okay:
                return .imgOkay
            case .bad:
                return .imgBad
            }
        }
    }
}

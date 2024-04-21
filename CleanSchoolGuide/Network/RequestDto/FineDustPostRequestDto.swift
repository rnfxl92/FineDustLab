//
//  FineDustPostRequestDto.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/21/24.
//

import Foundation

struct FineDustPostRequestDto: Encodable {
    let classroom: Classroom
    let userProfile: UserProfile
    
    struct Classroom: Encodable {
        let finedustFactor: Int
        let ultrafineFactor: Int
        
        enum CodingKeys: String, CodingKey {
            case finedustFactor = "finedust_factor"
            case ultrafineFactor = "ultrafine_factor"
        }
    }
    
    struct UserProfile: Encodable {
        let schoolCode: String
        let grade: Int
        let classNum: Int
        let studentNum: Int // 없애야함
        let name: String
        let userType: UserType
        
        enum CodingKeys: String, CodingKey {
            case schoolCode = "school_code"
            case grade, name
            case classNum = "class_num"
            case studentNum = "student_num"
            case userType = "user_type"
        }
    }
}

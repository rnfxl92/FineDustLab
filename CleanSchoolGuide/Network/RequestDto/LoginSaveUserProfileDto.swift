//
//  LoginSaveUserProfileDto.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/24/24.
//

import Foundation

struct SaveUserProfileDto: Encodable {
    let userProfile: UserProfile
    let uid: String
    
    struct UserProfile: Codable {
        let schoolCode: String
        let grade: Int
        let classNum: Int
        let name: String
        let userType: UserType
        let schoolName: String
        let schoolAddress: String
        
        enum CodingKeys: String, CodingKey {
            case schoolCode = "school_code"
            case grade, name
            case classNum = "class_num"
            case userType = "user_type"
            case schoolName = "school_name"
            case schoolAddress = "school_address"
        }
    }
}

struct getUserProfileDto: Encodable {
    let uid: String
}

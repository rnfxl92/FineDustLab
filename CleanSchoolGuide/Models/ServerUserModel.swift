//
//  ServerUserModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/25/24.
//

import Foundation

class ServerUserModel: Codable {
    let schoolCode: Int
    let userType: UserType
    let name: String
    let schoolAddress: String
    let schoolName: String
    let grade: Int
    let classNum: Int
    
    enum CodingKeys: String, CodingKey {
        case schoolCode = "school_code"
        case userType = "user_type"
        case name
        case schoolAddress = "school_address"
        case schoolName = "school_name"
        case grade
        case classNum = "class_num"
    }
    
    func toUserInfo() -> UserInfo {
        .init(
            name: name,
            school: .init(
                sdSchulCode: "\(schoolCode)",
                schulNm: schoolName,
                orgRdnma: schoolAddress
            ),
            grade: grade,
            classNum: classNum,
            studentNum: nil
        )
    }
}

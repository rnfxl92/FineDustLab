//
//  FindEmailReqeustDto.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/1/24.
//

import Foundation

struct FindEmailReqeustDto: Encodable {
    let name: String
    let schoolCode: String
    
    enum CodingKeys: String, CodingKey {
        case schoolCode
        case name
    }
}

//
//  SchoolSearchRequestDto.swift
//  FineDustLab
//
//  Created by 박성민 on 4/6/24.
//

import Foundation

struct SchoolSearchRequestDto: Encodable {
    let key: String = Environment.neisKey
    let type: String = "json"
    let schoolName: String
    
    enum CodingKeys: String, CodingKey {
        case schoolName = "SCHUL_NM"
        case key
        case type = "Type"
    }
}

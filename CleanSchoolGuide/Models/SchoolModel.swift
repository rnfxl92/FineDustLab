//
//  SchoolModel.swift
//  Mimun
//
//  Created by 박성민 on 3/9/24.
//

import Foundation

struct SchoolInfoWrapper: Codable {
    let schoolInfo: [SchoolInfo]
}

// MARK: - SchoolInfo
struct SchoolInfo: Codable {
    let head: [Head]?
    let row: [SchoolModel]?
}

// MARK: - Head
struct Head: Codable {
    let listTotalCount: Int?
    let result: ResultModel?

    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case result = "RESULT"
    }
}

// MARK: - Result
struct ResultModel: Codable {
    let code, message: String

    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}

struct SchoolModel: Codable, Hashable {
    let sdSchulCode, schulNm: String
    let orgRdnma: String
    
    enum CodingKeys: String, CodingKey {
        case sdSchulCode = "SD_SCHUL_CODE"
        case schulNm = "SCHUL_NM"
        case orgRdnma = "ORG_RDNMA"

    }
}

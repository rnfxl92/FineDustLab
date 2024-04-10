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
    let atptOfcdcScCode, atptOfcdcScNm, sdSchulCode, schulNm: String
    let schulKndScNm, lctnScNm, juOrgNm: String
    let orgRdnzc, orgRdnma, orgRdnda: String
    let orgTelno: String

    enum CodingKeys: String, CodingKey {
        case atptOfcdcScCode = "ATPT_OFCDC_SC_CODE"
        case atptOfcdcScNm = "ATPT_OFCDC_SC_NM"
        case sdSchulCode = "SD_SCHUL_CODE"
        case schulNm = "SCHUL_NM"
        case schulKndScNm = "SCHUL_KND_SC_NM"
        case lctnScNm = "LCTN_SC_NM"
        case juOrgNm = "JU_ORG_NM"
        case orgRdnzc = "ORG_RDNZC"
        case orgRdnma = "ORG_RDNMA"
        case orgRdnda = "ORG_RDNDA"
        case orgTelno = "ORG_TELNO"
    }
}

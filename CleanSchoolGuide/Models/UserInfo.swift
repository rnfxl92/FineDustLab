//
//  UserInfo.swift
//  Mimun
//
//  Created by 박성민 on 3/16/24.
//

import Foundation

struct UserInfo: Codable {
    let name: String
    let school: SchoolModel
    let grade: Int
    let classNum: Int
    let studentNum: Int?
}

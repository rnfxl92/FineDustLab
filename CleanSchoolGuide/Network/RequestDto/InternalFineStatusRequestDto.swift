//
//  InternalFineStatusRequestDto.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/17/24.
//

import Foundation

struct InternalFineStatusRequestDto: Encodable {
    let schoolCode: Int
    let grade: Int
    let classNum: Int
}

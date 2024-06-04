//
//  surveyAnswerByXlsRequestDto.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/4/24.
//

import Foundation

struct SurveyAnswerByXlsRequestDto: Encodable {
    let schoolCode: String
    let grade: String
    let class_num: String
}

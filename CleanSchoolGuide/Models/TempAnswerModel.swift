//
//  TempAnswerModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/23/24.
//

import Foundation

class TempAnswerModel: Codable {
    var answers: [AnswerModel]
    var date: Date
    var lastIndex: Int
    
    init(answers: [AnswerModel], date: Date, lastIndex: Int) {
        self.answers = answers
        self.date = date
        self.lastIndex = lastIndex
    }
}

struct AnswerModel: Codable {
    let questionId: Int
    let subQuestionId: Int
    let answer: String
}

//
//  SurveyModel.swift
//  Mimun
//
//  Created by 박성민 on 3/26/24.
//

import Foundation

// MARK: - Survey
struct SurveyData: Codable {
    let contentType: String
    let data: [SurveyModel]

    enum CodingKeys: String, CodingKey {
        case contentType = "content_type"
        case data
    }
}

// MARK: - Datum
struct SurveyModel: Codable {
    let subQuestions: [SubQuestion]
    let categoryName: String
    let categoryID: Int
    let question, categoryColor: String
    let id: Int
    let help: String?
    let subText: String?

    enum CodingKeys: String, CodingKey {
        case subQuestions = "sub_questions"
        case categoryName = "category_name"
        case categoryID = "category_id"
        case question
        case categoryColor = "category_color"
        case id
        case help
        case subText = "sub_text"
    }
}

// MARK: - SubQuestion
struct SubQuestion: Codable {
    let options: [Option]
    let type: SubQuestionType
    let subQuestionID: Int
    let text: String?
    let isOptional: Bool?

    enum CodingKeys: String, CodingKey {
        case options, type
        case subQuestionID = "sub_question_id"
        case text
        case isOptional = "is_optional"
    }
}

// MARK: - Option
struct Option: Codable {
    let id: Int?
    let text: String?
    let input: Bool?
    let placeholder: String?
    let unit: String?
    let range: RangeModel?
    let selected: Bool?
    let next_sub_question_id: Int?
}

// MARK: - Range
struct RangeModel: Codable {
    let min, max: Int
}

enum SubQuestionType: String, Codable {
    case ox
    case choice
    case numberPicker = "number_picker"
    case checkbox
    case text
    case slider
}

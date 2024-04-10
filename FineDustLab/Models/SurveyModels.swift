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
struct SurveyModel: Codable, Hashable {
    let categoryName: String
    let categoryID: Int
    let question: String
    let answer: Answer
    let id: Int
    let categoryColor: String?

    enum CodingKeys: String, CodingKey {
        case categoryName = "category_name"
        case categoryID = "category_id"
        case categoryColor = "category_color"
        case question, answer, id
    }
}

// MARK: - Answer
struct Answer: Codable, Hashable {
    let options: [AnswerOption]
    let type: AnswerOptionType
}

// MARK: - AnswerOption
struct AnswerOption: Codable, Hashable {
    let options: [OptionOption]?
    let id: Int?
    let text: String?
    let input: Bool?
    let unit: String?
    let range: RangeModel?
    let selected: Bool?
}

// MARK: - OptionOption
struct OptionOption: Codable, Hashable {
    let input: Bool
    let id: Int
    let text: String
}

// MARK: - Range
struct RangeModel: Codable, Hashable {
    let min, max: Int
}

enum AnswerOptionType: String, Codable, Hashable {
    case ox
    case choice
    case multiChoice = "multi_choice"
    case numberPicker = "number_picker"
    case checkbox
}

//
//  SetSurveyReqeustDto.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/12/24.
//

import Foundation

struct SetSurveyReqeustDto: Encodable {
    let user: User
    let surveyData: SurveyData
    
    enum CodingKeys: String, CodingKey {
        case user
        case surveyData = "survey_data"
    }
    
    struct User: Encodable {
        let schoolCode: String
        let grade: Int
        let classNum: Int
        let studentNum: Int?
        let name: String
        let userType: UserType
        
        enum CodingKeys: String, CodingKey {
            case schoolCode = "school_code"
            case grade
            case classNum = "class_num"
            case studentNum = "student_num"
            case name
            case userType = "user_type"
        }
    }
    
    struct SurveyData: Encodable {
        
        let questionId: Int
        let answers: [Answer]
        let date: String
        
        enum CodingKeys: String, CodingKey {
            case questionId = "question_id"
            case answers
            case date
        }
        
        struct Answer: Encodable {
            let subQuestionId: Int
            let subQuestionAnswer: String
            let type: SubQuestionType
            
            enum CodingKeys: String, CodingKey {
                case type
                case subQuestionId = "sub_question_id"
                case subQuestionAnswer = "sub_question_answer"
            }
        }
    }
}

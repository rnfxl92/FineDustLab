//
//  SurveyDetailViewModel.swift
//  FineDustLab
//
//  Created by 박성민 on 4/10/24.
//

import Foundation
import Combine

final class SurveyDetailViewModel {
    enum State {
        case postAnswerSuccess
        case answerUpdated
        case none
    }
    
    let currentIndex: Int
    lazy var survey = Preferences.surveyData?.data[safe: currentIndex]
    var totalCount: Int {
        Preferences.surveyData?.data.count ?? 0
    }
    var isAllAnswered: Bool {
        guard let survey else { return false }
        var count = survey.subQuestions.count
        count -= survey.subQuestions.filter { $0.isOptional ?? false }.count
        count += showOptionalDic.values.filter { $0 > 0 }.count
        
        return answerDic.keys.count >= count
    }
    var isEnd: Bool {
        currentIndex + 1 >= totalCount
    }
    var anweredQustion: [AnswerModel]? {
        guard let survey, let surveyTemp = Preferences.surveyTemp, surveyTemp.date.isToday  else {
            Preferences.surveyTemp = nil
            return nil
        }
        return surveyTemp.answers.filter {
            $0.categoryId == survey.categoryID && $0.questionId == survey.id
        }
    }
    
    private var answerDic: [Int: String] = [:]
    private(set) var showOptionalDic: [Int: Int] = [:]
    private var cancellable = Set<AnyCancellable>()
    
    @Published var state: State = .none
    
    init(currentIndex: Int) {
        self.currentIndex = currentIndex
        
        anweredQustion?.forEach { [weak self] answer in
            guard let self else { return }
            self.answerDic[answer.subQuestionId] = answer.answer
            if let nextSub = survey?
                .subQuestions
                .first(where: { $0.subQuestionID == answer.subQuestionId })?
                .options.first(where: { $0.id == Int(answer.answer) })?
                .next_sub_question_id {
                showOptionalDic[answer.subQuestionId] = nextSub
            }
        }
    }
    
    func answered(subQuestionId: Int, answer: String, showOptional: Int? = nil) {
        answerDic[subQuestionId] = answer
        
        if let showOptional {
            showOptionalDic[subQuestionId] = showOptional
        }
        state = .answerUpdated
    }
    
    func postAnswer() {
        guard
            let user = Preferences.userInfo,
            let userType = Preferences.selectedUserType,
            let survey,
            survey.subQuestions.count == answerDic.keys.count
        else { return }
        cancellable.removeAll()
        
        var temp = Preferences.surveyTemp ?? .init(answers: [], date: Date(), lastIndex: currentIndex)
        temp.lastIndex = currentIndex
        
        var answers: [SetSurveyReqeustDto.SurveyData.Answer] = []
        
        for key in answerDic.keys {
            temp.answers.removeAll {
                $0.categoryId == survey.categoryID && $0.questionId == survey.id && $0.subQuestionId == key
            }
            temp.answers.append(.init(categoryId: survey.categoryID, questionId: survey.id, subQuestionId: key, answer: answerDic[key] ?? ""))
            answers.append(
                .init(
                    subQuestionId: key,
                    subQuestionAnswer: answerDic[key] ?? "",
                    type: survey.subQuestions.first(where: { $0.subQuestionID == key })?.type ?? .choice)
            )
        }
        
        if isEnd {
            Preferences.surveyTemp = nil
        } else {
            Preferences.surveyTemp = temp
        }
        
        let endPoint = APIEndpoints.postSurveyData(
            with: .init(
                user: .init(
                    schoolCode: user.school.sdSchulCode,
                    grade: user.grade,
                    classNum: user.classNum,
                    studentNum: user.studentNum,
                    name: user.name,
                    userType: userType),
                surveyData: .init(
                    questionId: survey.id,
                    answers: answers,
                    date: Date().toString(dateFormat: .server))
            )
        )
        
        NetworkService
            .shared
            .request(endPoint)
            .replaceError(with: nil)
            .sink { [weak self] _ in
                self?.state = .postAnswerSuccess
            }
            .store(in: &cancellable)
    }
}

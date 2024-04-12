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
        return answerDic.keys.count == survey.subQuestions.count
    }
    var isEnd: Bool {
        currentIndex + 1 >= totalCount
    }
    
    private var answerDic: [Int: Any] = [:]
    private var cancellable = Set<AnyCancellable>()
    
    @Published var state: State = .none
    
    init(currentIndex: Int) {
        self.currentIndex = currentIndex
    }
    
    func answerSelected(subQuestionId: Int, optionId: Int) {
        answerDic[subQuestionId] = optionId
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
        
        var answers: [SetSurveyReqeustDto.SurveyData.Answer] = []
        
        for key in answerDic.keys {
            answers.append(
                .init(
                    subQuestionId: key,
                    subQuestionAnswer: "\(answerDic[key])",
                    type: survey.subQuestions.first(where: { $0.subQuestionID == key })?.type ?? .choice)
            )
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
                    date: Date().toString(dateFormat: .yyyyMMddHHmm))
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

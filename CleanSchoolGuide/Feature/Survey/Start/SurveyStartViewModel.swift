//
//  SelectStartViewModel.swift
//  FineDustLab
//
//  Created by 박성민 on 4/3/24.
//

import Foundation
import Combine

final class SurveyStartViewModel {
    enum State {
        case agreeUpdated(Bool)
        case schoolSelected(SchoolModel?)
        case inputUpdated
        case getUserInfo(UserInfo)
        case none
        case userDataSaved(Bool)
    }
    
    @Published var state: State = .none
    
    private var name: String?
    private var school: SchoolModel?
    private var grade: Int?
    private var `class`: Int?
    private var number: Int?
    private var isAgreed: Bool = false
    var canStart: Bool {
        name.isNotNilOrEmpty
        && !school.isNil
        && !grade.isNil
        && !`class`.isNil
        && !number.isNil
        && isAgreed
    }
    private var cancellable = Set<AnyCancellable>()
    
    func getUserInfo() {
        if let userInfo = Preferences.userInfo {
            name = userInfo.name
            school = userInfo.school
            grade = userInfo.grade
            `class` = userInfo.class
            number = userInfo.number
            
            state = .getUserInfo(userInfo)
        }
    }
    
    func agreeButtonTapped() {
        isAgreed.toggle()
        state = .agreeUpdated(isAgreed)
    }
    
    func schoolUpdated(_ school: SchoolModel) {
        self.school = school
        state = .schoolSelected(school)
    }
    
    func nameUpdate(_ name: String) {
        self.name = name
        state = .inputUpdated
    }
    
    func gradeUpdate(_ grade: Int?) {
        self.grade = grade
        state = .inputUpdated
    }
    
    func classUpdate(_ class: Int?) {
        self.`class` = `class`
        state = .inputUpdated
    }
    
    func numberUpdate(_ number: Int?) {
        self.number = number
        state = .inputUpdated
    }
    
    func saveUserData() {
        guard let name, name.isNotEmpty, let school, let grade, let `class`, let number else {
            state = .userDataSaved(false)
            return
        }
        
        Preferences.userInfo = UserInfo(name: name, school: school, grade: grade, class: `class`, number: number)
        state = .userDataSaved(true)
    }
    
    func fetchSurveyData()  {
        cancellable.removeAll()
        let endPoint = APIEndpoints.getSurveyData(with: .init(type: Preferences.selectedUserType ?? .elementary))
        
        NetworkService
            .shared
            .request(endPoint)
            .replaceError(with: nil)
            .sink { surveyData in
                if let surveyData {
                    dump(surveyData)
                    Preferences.surveyData = surveyData
                }
            }
            .store(in: &cancellable)
    }
}

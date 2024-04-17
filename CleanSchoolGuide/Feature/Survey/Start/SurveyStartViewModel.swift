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
    private var classNumber: Int?
    private var studentNumber: Int?
    private var isAgreed: Bool = false
    var canStart: Bool {
        name.isNotNilOrEmpty
        && !school.isNil
        && !grade.isNil
        && !classNumber.isNil
        && (Preferences.selectedUserType == .teacher || !studentNumber.isNil)
        && isAgreed
    }
    private var cancellable = Set<AnyCancellable>()
    
    func getUserInfo() {
        if let userInfo = Preferences.userInfo {
            name = userInfo.name
            school = userInfo.school
            grade = userInfo.grade
            classNumber = userInfo.classNum
            studentNumber = userInfo.studentNum
            
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
        self.classNumber = `class`
        state = .inputUpdated
    }
    
    func numberUpdate(_ number: Int?) {
        self.studentNumber = number
        state = .inputUpdated
    }
    
    func saveUserData() {
        guard let name, name.isNotEmpty, let school, let grade, let classNumber, let studentNumber else {
            state = .userDataSaved(false)
            return
        }
        
        Preferences.userInfo = UserInfo(name: name, school: school, grade: grade, classNum: classNumber, studentNum: studentNumber)
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
                    Preferences.surveyData = surveyData
                }
            }
            .store(in: &cancellable)
    }
}

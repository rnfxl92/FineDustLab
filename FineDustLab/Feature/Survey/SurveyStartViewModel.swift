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
        case nameUpdated
        case agreeUpdated(Bool)
        case schoolUpdated(SchoolModel?)
        case gradeUpdated(Int?)
        case classUpdate(Int?)
        case numberUpdate(Int?)
        case none
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
    
    func agreeButtonTapped() {
        isAgreed.toggle()
        state = .agreeUpdated(isAgreed)
    }
    
    func schoolUpdated(_ school: SchoolModel) {
        self.school = school
        state = .schoolUpdated(school)
    }
    
    func nameUpdate(_ name: String) {
        self.name = name
        state = .nameUpdated
    }
    
    func gradeUpdate(_ grade: Int?) {
        self.grade = grade
        state = .gradeUpdated(grade)
    }
    
    func classUpdate(_ class: Int?) {
        self.`class` = `class`
        state = .classUpdate(`class`)
    }
    
    func numberUpdate(_ number: Int?) {
        self.number = number
        state = .numberUpdate(number)
    }
    
    func saveUserData() {
        guard let name, name.isNotEmpty, let school, let grade, let `class`, let number else {
            return
        }
        
        Preferences.userInfo = UserInfo(name: name, school: school, grade: grade, class: `class`, number: number)
        
    }
}

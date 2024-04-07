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
}

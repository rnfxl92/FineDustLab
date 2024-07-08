//
//  SettingsViewModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/17/24.
//

import Foundation
import Combine

final class SettingsViewModel {
    enum Items: Int,  CaseIterable {
        case group
        case schoolInfo
        case name
        case divider
        case excelDownload
        case inquiry
//        case updateInfo
    }
    
    enum State {
        case none
        case loading
        case saveSuccess
        case saveFailed
        case downloaded(Bool)
        
        var isLoading: Bool {
            switch self {
            case .loading: return true
            default: return false
            }
        }
    }
    
    @Published var state: State = .none
    private var cancellable = Set<AnyCancellable>()
    
    private(set) var school: SchoolModel? = Preferences.userInfo?.school
    private(set) var name: String? = Preferences.userInfo?.name
    private(set) var grade: Int? = Preferences.userInfo?.grade
    private(set) var classNum: Int? = Preferences.userInfo?.classNum
    private(set) var studentNum: Int? = Preferences.userInfo?.studentNum
    
    var isCanSave: Bool {
        name.isNotNilOrEmpty
        && !school.isNil
        && !grade.isNil
        && !classNum.isNil
        && (Preferences.selectedUserType == .teacher || !studentNum.isNil)
    }
    
    func saveButtonTapped() {
        
        guard let name, name.isNotEmpty, let school, let grade, let classNum else { return state = .saveFailed }
        Preferences.userInfo = UserInfo(name: name, school: school, grade: grade, classNum: classNum, studentNum: studentNum)
        
        guard let uid = Preferences.userToken,
              Preferences.selectedUserType == .teacher else {
            state = .saveSuccess
            return
        }
        
        state = .loading
        
        cancellable.removeAll()
        let endPoint = APIEndpoints
            .postUserData(with: .init(
                userProfile: .init(
                    schoolCode: school.sdSchulCode,
                    grade: grade,
                    classNum: classNum,
                    name: name,
                    userType: .teacher,
                    schoolName: school.schulNm,
                    schoolAddress: school.orgRdnma),
                uid: uid)
            )
        NetworkService.shared.request(endPoint)
            .replaceError(with: nil)
            .sink { [weak self] _ in
                self?.state = .saveSuccess
            }
            .store(in: &cancellable)
    }
    
    func setSchool(_ school: SchoolModel) {
        self.school = school
    }
    
    func setName(_ name: String) {
        self.name = name
    }
    
    func setGrade(_ grade: Int) {
        self.grade = grade
    }
    
    func setClassNum(_ classNum: Int) {
        self.classNum = classNum
    }
    
    func setStudentNum(_ studentNum: Int) {
        self.studentNum = studentNum
    }
    
    func downloadExcel() {
        let endPoint = APIEndpoints.getSurveyAnswerByXls(with: nil)
        NetworkService.shared.download(endPoint) { [weak self] success in
            self?.state = .downloaded(success)
        }
    }
}

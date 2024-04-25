//
//  SignUpViewModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/20/24.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

final class SignUpViewModel {
    enum State {
        case nameUpdated
        case schoolUpated(SchoolModel)
        case gradeUpdated
        case classNumUpdated
        case emailUpdated
        case passwordUpdated
        case termUpdated(Bool)
        case loading
        case error(String)
        case signUpSuccessed
        case saveSuccess
        case saveFailed
        case none
        
        var isLoading: Bool {
            switch self {
            case .loading: return true
            default: return false
            }
        }
    }
    
    enum Items: Int,  CaseIterable {
        case school
        case name
        case email
        case password
        case signUpButton
    }
    
    private(set) var school: SchoolModel?
    private(set) var grade: Int?
    private(set) var classNum: Int?
    private(set) var name: String = ""
    private(set) var password: String = ""
    private(set) var passwordCheck: String = ""
    private(set) var email: String = ""
    private(set) var termsAgree: Bool = false
    private var cancellable = Set<AnyCancellable>()
    
    //    private let emailRegex = "^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9.-]+\\.)?ac\\.kr$"
        private let emailRegex: String = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    private let passwordRegex: String = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]"
    
    var isSignable: Bool {
        name.isNotEmpty
        && email.isNotEmpty
        && !grade.isNil
        && !classNum.isNil
        && email.validateRegex(with: emailRegex)
        && password.isNotEmpty
        && password.validateRegex(with: passwordRegex)
        && password == passwordCheck
        && termsAgree
    }
    
    @Published var state: State = .none
    
    func setName(_ name: String) {
        self.name = name
        state = .nameUpdated
    }
    
    func setSchool(_ school: SchoolModel) {
        self.school = school
        state = .schoolUpated(school)
    }
    
    func setGrade(_ grade: Int){
        self.grade = grade
        state = .gradeUpdated
    }
    
    func setClassNum(_ classNum: Int){
        self.classNum = classNum
        state = .classNumUpdated
    }
    
    func setEmail(_ email: String) {
        self.email = email
        state = .emailUpdated
    }
    
    func setPassword(_ password: String) {
        self.password = password
        state = .passwordUpdated
    }
    
    func setPasswordCheck(_ passwordCheck: String) {
        self.passwordCheck = passwordCheck
        state = .passwordUpdated
    }
    
    func termAgreed() {
        self.termsAgree.toggle()
        state = .termUpdated(termsAgree)
    }
    
    func requestSignUp() {
        state = .loading
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authresult, error) in
            guard let self else { return }
            if let error {
                self.state = .error(error.localizedDescription)
                return
            }
            if let user = authresult?.user, let school = self.school {
                Preferences.userToken = user.uid
                
                let endPoint = APIEndpoints
                    .postUserData(with: .init(
                        userProfile: .init(
                            schoolCode: school.sdSchulCode,
                            grade: grade ?? 0,
                            classNum: classNum ?? 0,
                            name: name,
                            userType: .teacher,
                            schoolName: school.schulNm,
                            schoolAddress: school.orgRdnma),
                        uid: user.uid)
                    )
                self.postUserData(endPoint: endPoint)
                Preferences.userInfo = .init(name: self.name, school: school, grade: grade ?? 0, classNum: classNum ?? 0, studentNum: nil)
            }
        }
    }
    
    private func postUserData(endPoint: Endpoint<EmptyData?>) {
        state = .loading
        NetworkService.shared.request(endPoint)
            .replaceError(with: nil)
            .sink { [weak self] _ in
                self?.state = .signUpSuccessed
            }
            .store(in: &cancellable)
    }
    
}

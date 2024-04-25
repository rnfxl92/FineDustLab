//
//  LoginBottomSheetViewModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/18/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Combine

final class LoginBottomSheetViewModel {
    enum State {
        case loading
        case loginSuccessed
        case loginFailed
        case none
        
        var isLoading: Bool {
            switch self {
            case .loading: return true
            default: return false
            }
        }
    }
    @Published var state: State = .none
    
    private var cancellable = Set<AnyCancellable>()
    private var ref = Database.database().reference()

    func requestLogin(email: String, password: String) {
        state = .loading
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] user, error in
            if let user = user?.user {
                self?.getUserInfo(user.uid)
            } else {
                self?.state = .loginFailed
            }
        }
    }
    
    private func getUserInfo(_ uid: String) {
        let endPoint = APIEndpoints.getUserData(with: .init(uid: uid))
        NetworkService
            .shared
            .request(endPoint)
            .handleError { [weak self] _ in
                self?.state = .loginFailed
            }
            .sink { [weak self] model in
                Preferences.userToken = uid
                Preferences.selectedUserType = .teacher
                Preferences.userInfo = model.toUserInfo()
                self?.state = .loginSuccessed
            }
            .store(in: &cancellable)
    }
    
}

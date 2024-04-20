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
    
    private var ref = Database.database().reference()

    func requestLogin(email: String, password: String) {
        state = .loading
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] user, error in
            if let user = user?.user {
                Preferences.userToken = user.uid
                self?.state = .loginSuccessed
            } else {
                self?.state = .loginFailed
            }
        }
    }
    
}

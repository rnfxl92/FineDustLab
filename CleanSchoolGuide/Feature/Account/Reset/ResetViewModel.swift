//
//  ResetViewModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/9/24.
//

import Foundation
import FirebaseAuth

final class ResetViewModel {
    enum State {
        case loading
        case sentPasswordReset(Bool)
        case none
        
        var isLoading: Bool {
            switch self {
            case .loading: return true
            default: return false
            }
        }
    }
    
    @Published var state: State = .none
    
    func resetPassward(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) {[weak self] error in
            if let errorString = error?.localizedDescription {
                self?.state = .sentPasswordReset(false)
            } else {
                self?.state = .sentPasswordReset(true)
            }
        }
    }
    
}

//
//  SelectGroupViewModel.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

final class SelectGroupViewModel {
    
    enum State {
        case loading
        case complete
        case none
        
        var isLoading: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
    }
    
    @Published var state: State = .none
    
    func setUserType(_ userType: UserType) {
        state = .loading
        Preferences.selectedUserType = userType
        state = .complete
    }
}

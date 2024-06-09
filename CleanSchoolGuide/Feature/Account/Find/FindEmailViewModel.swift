//
//  FindEmailViewModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 6/1/24.
//

import Foundation
import Combine

final class FindEmailViewModel {
    
    enum State {
        case loading
        case nameUpdated
        case schoolSelected(SchoolModel?)
        case findSuccessed(email: String)
        case findFailed
        case none
        
        var isLoading: Bool {
            switch self {
            case .loading: return true
            default: return false
            }
        }
    }
    @Published var state: State = .none
    private var name: String?
    private var school: SchoolModel?
    
    var canFind: Bool {
        name.isNotNilOrEmpty
        && !school.isNil
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    func nameUpdate(_ name: String) {
        self.name = name
        state = .nameUpdated
    }
    
    func schoolUpdated(_ school: SchoolModel) {
        self.school = school
        state = .schoolSelected(school)
    }
    
    func findEmailRequst() {
        guard let name,
              let schoolCode = school?.sdSchulCode else { return }
        
        let endPoint = APIEndpoints.findEmail(with: .init(name: name, schoolCode: schoolCode))
        
        NetworkService
            .shared
            .request(endPoint)
            .handleError { [weak self] _ in
                self?.state = .findFailed
            }
            .sink { [weak self] model in
                if let email = model.email, email.count > 2 {
                    self?.state = .findSuccessed(email: email)
                } else {
                    self?.state = .findFailed
                }
            }
            .store(in: &cancellable)
    }
}

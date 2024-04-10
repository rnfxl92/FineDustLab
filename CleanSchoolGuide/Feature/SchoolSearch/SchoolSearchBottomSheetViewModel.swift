//
//  SchoolSearchBottomSheetViewModel.swift
//  FineDustLab
//
//  Created by 박성민 on 4/6/24.
//

import Foundation
import Combine

final class SchoolSearchBottomSheetViewModel {
    
    struct Input {
        let name: AnyPublisher<String?, Never>
    }
    
    struct Output {
        let state: AnyPublisher<State, Never>
    }
    
    enum State {
        case loading
        case searched([SchoolModel])
        
    }
    private let currentStatePublisher = CurrentValueSubject<State, Never>(.searched([]))
    private var cancellable = Set<AnyCancellable>()
    func bind(_ input: Input) -> Output {
        
        input
            .name
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .flatMap{ [weak self] name -> AnyPublisher<[SchoolModel], Never> in
                guard let self, let name, name.isNotEmpty else {
                    return Just([]).eraseToAnyPublisher()
                }
                return self.search(name)
            }
            .sink { [weak self] school in
                self?.currentStatePublisher.send(.searched(school))
            }
            .store(in: &cancellable)
        
        return .init(state: currentStatePublisher.eraseToAnyPublisher())
    }
    
    func search(_ name: String) -> AnyPublisher<[SchoolModel], Never> {
        let endPoint = APIEndpoints.getSchoolInfo(with: .init(schoolName: name))
        return NetworkService
            .shared
            .request(endPoint)
            .compactMap { (wrapper: SchoolInfoWrapper) in
                return wrapper.schoolInfo.flatMap { $0.row ?? [] }
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
        
    }
    
}

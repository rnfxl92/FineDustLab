//
//  Combine+Error.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/24/24.
//

import Combine

extension Publisher {
    public func handleError(_ handle: @escaping (Failure) -> Void) -> AnyPublisher<Output, Never> {
        self.catch { error -> Empty<Output, Never> in
            handle(error)
            return Empty(completeImmediately: true, outputType: Output.self, failureType: Never.self)
        }
        .eraseToAnyPublisher()
    }
}

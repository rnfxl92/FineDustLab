//
//  Combine+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation
import Combine

extension Future where Failure == Error {
    public convenience init(asyncFunc: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let result = try await asyncFunc()
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}

extension Future where Failure == Never {
    public convenience init(asyncFunc: @escaping () async -> Output) {
        self.init { promise in
            Task {
                let result = await asyncFunc()
                promise(.success(result))
            }
        }
    }
}

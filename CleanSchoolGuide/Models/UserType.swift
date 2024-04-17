//
//  UserType.swift
//  Mimun
//
//  Created by 박성민 on 3/16/24.
//

import Foundation

enum UserType: String, Codable {
    case elementary
    case middle
    case high
    case teacher
    
    var description: String {
        switch self {
        case .elementary:
            return "초등학생"
        case .middle:
            return "중학생"
        case .high:
            return "고등학생"
        case .teacher:
            return "선생님"
        }
    }
}

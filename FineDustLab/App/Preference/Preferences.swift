//
//  Preference.swift
//  Mimun
//
//  Created by 박성민 on 3/16/24.
//

import Foundation

enum PreferencesKey: String, UserDefaultsKeyType {
    case selectedUserType
    case userInfo
    
    var value: String { rawValue }
}

public struct Preferences {
    @UserDefaultsWrapper(key: PreferencesKey.selectedUserType, defaultValue: nil)
    static var selectedUserType: UserType?
    
    @UserDefaultsWrapper(key: PreferencesKey.userInfo, defaultValue: nil)
    static var userInfo: UserInfo?
    // TODO: 유저 인포
}

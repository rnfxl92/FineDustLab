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
    case surveyCompletedDates
    case surveyData
    case userToken
    case surveyTemp
    case ultraFineData
    case fineData
    
    var value: String { rawValue }
}

public struct Preferences {
    @UserDefaultsWrapper(key: PreferencesKey.selectedUserType, defaultValue: nil)
    static var selectedUserType: UserType?
    
    @UserDefaultsWrapper(key: PreferencesKey.userInfo, defaultValue: nil)
    static var userInfo: UserInfo?
    // TODO: 유저 인포
    
    @UserDefaultsWrapper(key: PreferencesKey.surveyCompletedDates, defaultValue: [])
    static var surveyCompletedDates: [Date]
    
    @UserDefaultsWrapper(key: PreferencesKey.surveyData, defaultValue: nil)
    static var surveyData: SurveyData?
    
    @UserDefaultsWrapper(key: PreferencesKey.userToken, defaultValue: nil)
    static var userToken: String?
    
    @UserDefaultsWrapper(key: PreferencesKey.surveyTemp, defaultValue: [])
    static var surveyTemp: [Int]
 
    @UserDefaultsWrapper(key: PreferencesKey.ultraFineData, defaultValue: nil)
    static var ultraFineData: SelectedFineData?
    
    @UserDefaultsWrapper(key: PreferencesKey.fineData, defaultValue: nil)
    static var fineData: SelectedFineData?
    
    static func clearUserDefault() {
        Preferences.selectedUserType = nil
        Preferences.userInfo = nil
        Preferences.surveyCompletedDates = []
        Preferences.surveyData = nil
        Preferences.userToken = nil
        Preferences.surveyTemp = []
        Preferences.ultraFineData = nil
        Preferences.fineData = nil
    }
}

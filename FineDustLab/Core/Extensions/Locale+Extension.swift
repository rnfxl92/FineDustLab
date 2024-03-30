//
//  Locale+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

extension Locale {
    public static var currentLanguage: String {
        if #available(iOS 16, *) {
           return Locale.current.language.languageCode?.identifier ?? "ko"
        }
        return Locale.current.languageCode ?? "ko"
    }

    public static var currentRegion: String {
        if #available(iOS 16, *) {
            return Locale.current.region?.identifier ?? "KR"
        }
        return Locale.current.regionCode ?? "KR"
    }
}

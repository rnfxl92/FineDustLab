//
//  SurveyDetailViewModel.swift
//  FineDustLab
//
//  Created by 박성민 on 4/10/24.
//

import Foundation
import Combine

final class SurveyDetailViewModel {
    let currentIndex: Int
    lazy var survey = Preferences.surveyData?.data[safe: currentIndex]
    var totalCount: Int {
        Preferences.surveyData?.data.count ?? 0
    }
    
    init(currentIndex: Int) {
        self.currentIndex = currentIndex
    }
}

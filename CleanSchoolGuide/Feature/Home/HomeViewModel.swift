//
//  HomeViewModel.swift
//  FineDustLab
//
//  Created by 박성민 on 3/31/24.
//

import Foundation

final class HomeViewModel {
    var dataSource: [CardCollectionViewCell.CardUIModel] {
        let dates = Date.getWeekdaysAndNextMonday()
        var models: [CardCollectionViewCell.CardUIModel] = []
        let surveyedDates = Preferences.surveyCompletedDates
        
        dates.forEach { date in
            models.append(
                .init(
                    date: date,
                    isSuveyed: surveyedDates.first {
                        $0.isSameDay(from: date)
                    } != nil,
                    isHoliday: false)
            )
        }
        
        return models
    }
    
    
    
}

//
//  TimeInterval+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

public extension TimeInterval {
    func toString() -> String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        
        var timeString = String(format: "%02d:%02d", minutes, seconds)
        let hours = (interval / 3600)
        if hours > 0 {
            timeString = String(format: "%d:", hours) + timeString
        }
        
        return timeString
    }
    
    var date: Date {
        Date(timeIntervalSince1970: self)
    }
}

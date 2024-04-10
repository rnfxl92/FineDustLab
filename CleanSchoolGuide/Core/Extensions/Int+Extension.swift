//
//  Int+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

public extension Int {
    var years: DateComponents {
        var components = DateComponents()
        components.year = self
        return components
    }
    
    var months: DateComponents {
        var components = DateComponents()
        components.month = self
        return components
    }
    
    var weeks: DateComponents {
        var components = DateComponents()
        components.weekOfYear = self
        return components
    }
    
    var days: DateComponents {
        var components = DateComponents()
        components.day = self
        return components
    }
    
    var hours: DateComponents {
        var components = DateComponents()
        components.hour = self
        return components
    }

    var minutes: DateComponents {
        var components = DateComponents()
        components.minute = self
        return components
    }
    
    var seconds: DateComponents {
        var components = DateComponents()
        components.second = self
        return components
    }
}

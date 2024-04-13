//
//  WeatherModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/13/24.
//

import Foundation

struct WeatherModel: Codable {
    let result: String
    let temperature: Int?
    let humidity: Int?
    let id: String?
}



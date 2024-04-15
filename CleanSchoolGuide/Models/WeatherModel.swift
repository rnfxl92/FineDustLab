//
//  WeatherModel.swift
//  CleanSchoolGuide
//
//  Created by 박성민 on 4/13/24.
//

import Foundation

struct WeatherModel: Codable {
    let result: String
    let temperature: String?
    let humidity: String?
    let id: String?
    let date: String?
}



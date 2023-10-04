//
//  WeatherUtility.swift
//  
//
//  Created by 김기현 on 2023/10/04.
//

import Foundation

struct WeatherUtility {
    static func getCurrentTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let currentTimeString = dateFormatter.string(from: currentDate)
        return currentTimeString
    }

    static func getSunsetTime() -> String {
        return "18:00"
    }
    static func getSunriseTime() -> String {
        return "06:00"
    }
}

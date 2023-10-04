//
//  WeatherUtility.swift
//  Iweather
//
//  Created by t2023-m0049 on 2023/10/04.
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

    static func getWeatherCode(_ weatherID: Int) -> String {
        switch weatherID {
        case 200...232:
            return "thunderstorm"
        case 300...321:
            return "drizzle"
        case 500...531:
            return "rain"
        case 600...622:
            return "snow"
        case 701, 721, 741: 
            return "mist"
        case 800:
            return "clearSky"
        case 801...804:
            return "mist"
        default:
            return "defaultWeatherImage"

        }
    }
}













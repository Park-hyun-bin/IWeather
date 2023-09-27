//
//  WeatherManager.swift
//  Iweather
//
//  Created by 김기현 on 2023/09/26.
//

import Foundation

// MARK: - WeatherManager
struct WeatherManager: Codable {
    let temp: Double?
    let humidity: Int?
    let wind: Wind?
    let weather: [Weather?]?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
        case wind
        case weather
        case name
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

// MARK: - Weather
struct Weather: Codable {
    let main: String?
    let description: String?
    let icon: String?
}

extension WeatherManager {
    // 화씨
    var temperatureInFahrenheit: Double? {
        return (temp! * 9/5) + 32
    }
    
    // 섭씨
    var temperatureInCelsius: Double? {
        return (temp! - 32) * 5/9
    }
}

//
//  WeatherApi.swift
//  Iweather
//
//  Created by 김기현 on 2023/09/26.
//


import Foundation
import Moya

enum WeatherAPI {
    case getWeatherForCity(_ cityName: String? = nil, days: Int)
    case getWeatherForLocation(latitude: Double, longitude: Double, days: Int) // 새로운 케이스 추가
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5")!
    }
    
    var path: String {
        switch self {
        case .getWeatherForCity:
            return "/forecast"
        case .getWeatherForLocation:  // 새로 추가된 케이스에 대한 처리
            return "/forecast"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWeatherForCity:
            return .get
        case .getWeatherForLocation:  // 새로 추가된 케이스에 대한 처리
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getWeatherForCity(let days):
            let parameters: [String: Any] = [
                "q": "busan",
                "appid": "e8aeafe9abc4ec56d53a28782b1991f8",
                "units": "metric", // 온도를 섭씨로
                "lang": "kr", // 한국어로
                "cnt": 5
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getWeatherForLocation(let latitude, let longitude, let days): // 새로운 케이스에 대한 처리
            let parameters: [String: Any] = [
                "lat": latitude,
                "lon": longitude,
                "appid": "e8aeafe9abc4ec56d53a28782b1991f8",
                "units": "metric",
                "lang": "kr",
                "cnt": days
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
}

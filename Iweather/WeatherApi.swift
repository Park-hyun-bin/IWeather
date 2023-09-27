//
//  WeatherApi.swift
//  Iweather
//
//  Created by 김기현 on 2023/09/26.
//


import Foundation
import Moya

enum WeatherAPI {
    case getWeatherForCity(_ cityName: String? = nil)
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5")!
    }

    var path: String {
        switch self {
        case .getWeatherForCity:
            return "/weather"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getWeatherForCity:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getWeatherForCity(_):
            let parameters: [String: Any] = [
                "q": "busan",
                "appid": "e8aeafe9abc4ec56d53a28782b1991f8",
                "units": "metric", // 온도를 섭씨로
                "lang": "kr" // 한국어로
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

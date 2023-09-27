//
//  RecommandViewModel.swift
//  Iweather
//
//  Created by Hyunwoo Lee on 2023/09/27.
//

import Foundation
import Moya

class RecommandViewModel {
    private let weatherProvider = MoyaProvider<WeatherAPI>()

    // 현재 기온 데이터를 가져오는 함수
    func fetchWeather(completion: @escaping (WeatherManager?, Error?) -> Void) {
        weatherProvider.request(.getWeatherForCity()) { result in
            switch result {
            case .success(let response):
                do {
                    let weatherData = try response.map(WeatherManager.self)
                    completion(weatherData, nil)
                } catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    // 기온에 따라 배경 이미지 이름을 반환하는 함수
    func backgroundImageForTemperature(_ temperatureInCelsius: Double?) -> String {
        if let temperatureInCelsius = temperatureInCelsius {
            if temperatureInCelsius >= 30.0 {
                return "hot_bg_image"
            } else if temperatureInCelsius >= 20.0 {
                return "warm_bg_image"
            } else {
                return "cool_bg_image"
            }
        } else {
            // 기온 데이터가 없을 경우 기본 이미지 반환
            return "default_bg_image"
        }
    }
}


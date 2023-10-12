//
//  BackgroundUtility.swift
//  Iweather
//
//  Created by Hyunwoo Lee on 2023/10/04.
//

import Foundation
import UIKit
import Moya

class BackgroundUtility {
    static let weatherService = MoyaProvider<WeatherAPI>(plugins: [NetworkLoggerPlugin()])
    
    static func calculateSunriseAndSunsetTimes(weatherResponse: Welcome) -> (Date, Date, Date, Date, Date) {
        let currentTime = Date() + 32_400
        let sunrise = Date(timeIntervalSince1970: TimeInterval(weatherResponse.city.sunrise) + 32_400)
        let sunset = Date(timeIntervalSince1970: TimeInterval(weatherResponse.city.sunset) + 32_400)
        let sunriseStart = sunrise.addingTimeInterval(-30 * 60)
        let sunriseEnd = sunrise.addingTimeInterval(30 * 60)
        let sunsetStart = sunset.addingTimeInterval(-30 * 60)
        let sunsetEnd = sunset.addingTimeInterval(30 * 60)
        return (currentTime, sunriseStart, sunriseEnd, sunsetStart, sunsetEnd)
    }
    
    static func determinePhotoName(currentTime: Date, sunriseStart: Date, sunriseEnd: Date, sunsetStart: Date, sunsetEnd: Date) -> String {
        // 일출 진행중 사진
        if currentTime >= sunriseStart && currentTime <= sunriseEnd {
            return "sunrise"
        }
        // 일몰 진행중 사진
        if currentTime >= sunsetStart && currentTime <= sunsetEnd {
            return "sunset"
        }
        // 밤 사진
        if currentTime >= sunsetEnd || currentTime <= sunriseStart {
            return "night"
        }
        // 낮 사진
        return "day"
    }
    
    static func updateUI(with welcome: Welcome) {
        let (currentTime, sunriseStart, sunriseEnd, sunsetStart, sunsetEnd) = calculateSunriseAndSunsetTimes(weatherResponse: welcome)
        determinePhotoName(currentTime: currentTime, sunriseStart: sunriseStart, sunriseEnd: sunriseEnd, sunsetStart: sunsetStart, sunsetEnd: sunsetEnd)
        print("일출 시작 \(sunriseStart)")
        print("일출 끝  \(sunriseEnd)")
        print("일몰 시작 \(sunsetStart)")
        print("일몰 끝  \(sunsetEnd)")
        print("현재 시간 \(currentTime)")
    }
    
    static  func getWeatherData(exclude: String, completion: @escaping (Result<Welcome, Error>) -> Void) {
        print("요청중")
        weatherService.request(.getWeatherForCity("", days: 5)) { result in
            switch result {
            case let .success(response):
                do {
                    let welcome = try response.map(Welcome.self)
                    DispatchQueue.main.async {
                        self.updateUI(with: welcome)
                        completion(.success(welcome))
                    }
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

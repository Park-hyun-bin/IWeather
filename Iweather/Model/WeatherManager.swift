// MARK: - WeatherManager
struct WeatherManager: Codable {
    let main: Main // Main 구조체 포함
    let wind: Wind?
    let weather: [Weather?]?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case main // Main 구조체의 키는 main으로 예상
        case wind
        case weather
        case name
    }
}

// Main 구조체 정의
struct Main: Codable {
    let temp: Double
    let humidity: Int
//    let feelsLike: Double // 필요한 다른 프로퍼티들도 추가할 수 있음

    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
//        case feelsLike
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
        return (main.temp * 9/5) + 32
    }
    
    // 섭씨
    var temperatureInCelsius: Double? {
        return (main.temp - 32) * 5/9
    }
}

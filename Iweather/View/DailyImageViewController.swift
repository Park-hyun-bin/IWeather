
import UIKit
import Moya

class DailyImageViewController: UIViewController {
    
    private let weatherProvider = MoyaProvider<WeatherAPI>()
    
    private var dayViews: [UIView] = []
    private var highTemperatureLabels: [UILabel] = []
    private var lowTemperatureLabels: [UILabel] = []
    private var humidityLabels: [UILabel] = []
    private var weatherImageViews: [UIImageView] = []

    private let currentLocation: UILabel = {
        let label = UILabel()
        label.text = "[서울]"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "evening")
        backgroundImage.alpha = 0.7
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        view.addSubview(currentLocation)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocationUpdate(_:)), name: .didUpdateLocation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleWeatherLocationUpdate(_:)), name: .didUpdateLocationForWeather, object: nil)
        if let lastLocation = UserDefaultsManager.shared.getLastSearchedLocation() {
            currentLocation.text = "[\(lastLocation.address)]"
            updateWeatherData(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
        }
        setupDayViews()
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateDayViews()
    }
    
    func updateWeatherData(latitude: Double, longitude: Double) {
        weatherProvider.request(.getWeatherForLocation(latitude: latitude, longitude: longitude, days: 4)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let weatherData = try JSONDecoder().decode(Welcome.self, from: response.data)
                    for (index, dayWeather) in weatherData.list.prefix(4).enumerated() {
                        DispatchQueue.main.async {
                            
                            self?.highTemperatureLabels[index].text = "\(dayWeather.main.tempMax)°C"
                            self?.lowTemperatureLabels[index].text = "\(dayWeather.main.tempMin)°C"
                            self?.humidityLabels[index].text = "습도 : \(dayWeather.main.humidity)%"
                            
                            if let weather = dayWeather.weather.first {
                                let imageName = self?.imageNameForWeather(weather)
                                self?.weatherImageViews[index].image = UIImage(named: imageName ?? "defaultImage")
                                self?.dayViews[index].subviews.compactMap { $0 as? UIImageView }.first?.image = UIImage(named: imageName ?? "defaultImage")
                            }
                        }
                    }
                    
                } catch {
                    print("Error decoding weather data: \(error)")
                }
            case .failure(let error):
                print("Error fetching weather data: \(error)")
            }
        }
    }


    
    private func animateDayViews() {
        for dayView in dayViews {
            dayView.alpha = 0.0
        }
        currentLocation.alpha = 0.0
        
        
        UIView.animate(withDuration: 0.6, delay: 0.1, options: .curveEaseIn, animations: { [weak self] in
            for dayView in self?.dayViews ?? [] {
                dayView.alpha = 0.8
            }
            self?.currentLocation.alpha = 0.9
                }, completion: nil)
    }
    
    @objc func handleWeatherLocationUpdate(_ notification: Notification) {
        if let latitude = notification.userInfo?["latitude"] as? Double,
           let longitude = notification.userInfo?["longitude"] as? Double {
            
            UserDefaultsManager.shared.saveLastSearchedLocation(latitude: latitude, longitude: longitude, address: currentLocation.text ?? "")
            updateWeatherData(latitude: latitude, longitude: longitude)
        }
    }

    @objc func handleLocationUpdate(_ notification: Notification) {
        if let address = notification.userInfo?["address"] as? String {
            currentLocation.text = "[\(address)]"
            UserDefaultsManager.shared.saveLastSearchedLocation(latitude: UserDefaultsManager.shared.getLastSearchedLocation()?.latitude ?? 0.0, longitude: UserDefaultsManager.shared.getLastSearchedLocation()?.longitude ?? 0.0, address: address)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .didUpdateLocation, object: nil)
        NotificationCenter.default.removeObserver(self, name: .didUpdateLocationForWeather, object: nil)
    }


    func imageNameForWeather(_ weather: Weather) -> String {
        switch weather.main.lowercased() {
        case "clear":
            return "clear"
        case "clouds":
            return "clouds"
        case "rain":
            return "raining"
        case "mist":
            return "mist"
        case "snow":
            return "snow"
        case "thunderstorm":
            return "thunderstorm"
        case "tornado":
            return "tornado"
        default:
            return "defaultImage"
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for dayView in dayViews {
            if let backgroundView = dayView.subviews.compactMap({ $0 as? UIView }).first {
                backgroundView.layer.cornerRadius = 20
            }
        }
    }

    
    private func setupDayViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d일"
        
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "E"
        dayOfWeekFormatter.locale = Locale(identifier: "ko_KR")
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        for i in 0..<4 {
            let dayView = UIView()
            dayView.translatesAutoresizingMaskIntoConstraints = false
            
            let backgroundView = UIView()
             backgroundView.translatesAutoresizingMaskIntoConstraints = false
             backgroundView.backgroundColor = .black
             backgroundView.alpha = 0.3
            backgroundView.clipsToBounds = true

             dayView.addSubview(backgroundView)
             
            
            let date = calendar.date(byAdding: .day, value: i, to: currentDate)!
            let dateString = dateFormatter.string(from: date)
            let dayOfWeekString = dayOfWeekFormatter.string(from: date)
            

            let dayLabel = UILabel()
            dayLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            dayLabel.text = dateString
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let dayOfWeekLabel = UILabel()
            dayOfWeekLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            dayOfWeekLabel.text = dayOfWeekString
            dayOfWeekLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let weatherImageView = UIImageView()
            weatherImageViews.append(weatherImageView)
            weatherImageView.translatesAutoresizingMaskIntoConstraints = false
//            weatherImageView.image = UIImage(named: "raining")
            weatherImageView.contentMode = .scaleAspectFit
            
            let highTemperatureLabel = UILabel()
            highTemperatureLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            highTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
            highTemperatureLabel.text = "30°C" // 예시로 30도로 설정, 실제로는 API 데이터 사용
            highTemperatureLabel.textAlignment = .center
            
            
            let lowTemperatureLabel = UILabel()
            lowTemperatureLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            lowTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
            lowTemperatureLabel.text = "20°C" // 예시로 20도로 설정, 실제로는 API 데이터 사용
            lowTemperatureLabel.textAlignment = .center
            
            let humidityLabel = UILabel()
            humidityLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            humidityLabel.translatesAutoresizingMaskIntoConstraints = false
            humidityLabel.text = "습도 : 80%"
            humidityLabel.textAlignment = .center
            
            highTemperatureLabels.append(highTemperatureLabel)
            lowTemperatureLabels.append(lowTemperatureLabel)
            humidityLabels.append(humidityLabel)

            

            
            let labels = [dayLabel, dayOfWeekLabel, highTemperatureLabel, lowTemperatureLabel, humidityLabel]
            for label in labels {
                label.textColor = .white
            }
            dayView.addSubview(lowTemperatureLabel)
            dayView.addSubview(highTemperatureLabel)
            dayView.addSubview(dayLabel)
            dayView.addSubview(dayOfWeekLabel)
            dayView.addSubview(weatherImageView)
            dayView.addSubview(humidityLabel)
            
            NSLayoutConstraint.activate([
                dayLabel.centerXAnchor.constraint(equalTo: dayView.centerXAnchor),
                dayLabel.topAnchor.constraint(equalTo: dayView.topAnchor, constant: 15),
                dayOfWeekLabel.centerXAnchor.constraint(equalTo: dayView.centerXAnchor),
                dayOfWeekLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 5),
                weatherImageView.centerXAnchor.constraint(equalTo: dayView.centerXAnchor),
                weatherImageView.topAnchor.constraint(equalTo: dayOfWeekLabel.bottomAnchor, constant: 30),
                weatherImageView.widthAnchor.constraint(equalToConstant: 30),
                weatherImageView.heightAnchor.constraint(equalToConstant: 30),
                highTemperatureLabel.centerXAnchor.constraint(equalTo: dayView.centerXAnchor),
                highTemperatureLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 140),
                lowTemperatureLabel.centerXAnchor.constraint(equalTo: dayView.centerXAnchor),
                lowTemperatureLabel.topAnchor.constraint(equalTo: highTemperatureLabel.bottomAnchor, constant: 30),
                humidityLabel.centerXAnchor.constraint(equalTo: dayView.centerXAnchor),
                humidityLabel.bottomAnchor.constraint(equalTo: dayView.bottomAnchor, constant: -40),
                backgroundView.leadingAnchor.constraint(equalTo: dayView.leadingAnchor),
                 backgroundView.trailingAnchor.constraint(equalTo: dayView.trailingAnchor),
                 backgroundView.topAnchor.constraint(equalTo: dayView.topAnchor),
                 backgroundView.bottomAnchor.constraint(equalTo: dayView.bottomAnchor)
            
                
            ])
//            dayView.addSubview(weatherImageView)
//            dayView.addSubview(highTemperatureLabel)
            dayViews.append(dayView)
            view.addSubview(dayView)
        }
    }
    


    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            currentLocation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentLocation.topAnchor.constraint(equalTo: safeArea.topAnchor)
        ])
        
        let spacing: CGFloat = 5
        let dayViewWidth: CGFloat = (view.frame.width - spacing * 3) / 4
        var previousView: UIView?
        for dayView in dayViews {
            NSLayoutConstraint.activate([
                dayView.widthAnchor.constraint(equalToConstant: dayViewWidth),
                dayView.topAnchor.constraint(equalTo: currentLocation.bottomAnchor, constant: 20),
                view.bottomAnchor.constraint(equalTo: dayView.bottomAnchor, constant: 120)
            ])
            
            if let previousView = previousView {
                dayView.leadingAnchor.constraint(equalTo: previousView.trailingAnchor, constant: spacing).isActive = true
            } else {
                dayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            }
            previousView = dayView
        }
    }
}

extension Notification.Name {
    static let didUpdateLocationForWeather = Notification.Name("didUpdateLocationForWeather")
}

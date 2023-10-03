
import UIKit
import Moya

class DailyImageViewController: UIViewController {
    
    private let weatherProvider = MoyaProvider<WeatherAPI>()

    private var highTemperatureLabels: [UILabel] = []
    private var lowTemperatureLabels: [UILabel] = []
    private var humidityLabels: [UILabel] = []

    
    
    func updateWeatherData(latitude: Double, longitude: Double) {
        weatherProvider.request(.getWeatherForLocation(latitude: latitude, longitude: longitude, days: 4)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let weatherData = try JSONDecoder().decode(Welcome.self, from: response.data)
                    for (index, dayWeather) in weatherData.list.prefix(4).enumerated() {
                        DispatchQueue.main.async {
                            
                            self?.highTemperatureLabels[index].text = "\(dayWeather.main.tempMax)°"
                            self?.lowTemperatureLabels[index].text = "\(dayWeather.main.tempMin)°"
                            self?.humidityLabels[index].text = "습도 : \(dayWeather.main.humidity)%"
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

    private let currentLocation: UILabel = {
        let label = UILabel()
        label.text = "[서울]"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dayViews: [UIView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "background5")
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        view.addSubview(currentLocation)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocationUpdate(_:)), name: .didUpdateLocation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleWeatherLocationUpdate(_:)), name: .didUpdateLocationForWeather, object: nil)

        setupDayViews()
        setupLayout()
        
    }
    
    @objc func handleWeatherLocationUpdate(_ notification: Notification) {
        if let latitude = notification.userInfo?["latitude"] as? Double,
           let longitude = notification.userInfo?["longitude"] as? Double {
            updateWeatherData(latitude: latitude, longitude: longitude)
        }
    }
    @objc func handleLocationUpdate(_ notification: Notification) {
            if let address = notification.userInfo?["address"] as? String {
                currentLocation.text = "[\(address)]"
            }
        }

    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didUpdateLocation, object: nil)
    }

    
    
    
    private func setupDayViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d일"
        
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "E"
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        for i in 0..<4 {
            let dayView = UIView()
            dayView.translatesAutoresizingMaskIntoConstraints = false
            
            let weatherImageView = UIImageView()
            weatherImageView.translatesAutoresizingMaskIntoConstraints = false
            weatherImageView.image = UIImage(named: "raining")
            weatherImageView.contentMode = .scaleAspectFit
            
            let highTemperatureLabel = UILabel()
            highTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
            highTemperatureLabel.text = "30°" // 예시로 30도로 설정, 실제로는 API 데이터 사용
            highTemperatureLabel.textAlignment = .center
            
            
            let lowTemperatureLabel = UILabel()
            lowTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
            lowTemperatureLabel.text = "20°" // 예시로 20도로 설정, 실제로는 API 데이터 사용
            lowTemperatureLabel.textAlignment = .center
            
            let humidityLabel = UILabel()
            humidityLabel.translatesAutoresizingMaskIntoConstraints = false
            humidityLabel.text = "습도 : 80%"
            humidityLabel.textColor = .black
            humidityLabel.textAlignment = .center
            
            highTemperatureLabels.append(highTemperatureLabel)
            lowTemperatureLabels.append(lowTemperatureLabel)
            humidityLabels.append(humidityLabel)

            
            let date = calendar.date(byAdding: .day, value: i, to: currentDate)!
            let dateString = dateFormatter.string(from: date)
            let dayOfWeekString = dayOfWeekFormatter.string(from: date)
            
            let dayLabel = UILabel()
            dayLabel.text = dateString
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let dayOfWeekLabel = UILabel()
            dayOfWeekLabel.text = dayOfWeekString
            dayOfWeekLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let labels = [dayLabel, dayOfWeekLabel, highTemperatureLabel, lowTemperatureLabel]
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
                highTemperatureLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 100),
                lowTemperatureLabel.centerXAnchor.constraint(equalTo: dayView.centerXAnchor),
                lowTemperatureLabel.topAnchor.constraint(equalTo: highTemperatureLabel.bottomAnchor, constant: 30),
                humidityLabel.centerXAnchor.constraint(equalTo: dayView.centerXAnchor),
                humidityLabel.bottomAnchor.constraint(equalTo: dayView.bottomAnchor, constant: -40)
                
            ])
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
                dayView.topAnchor.constraint(equalTo: currentLocation.bottomAnchor, constant: 10),
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

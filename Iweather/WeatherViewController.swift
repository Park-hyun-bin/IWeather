//
//  WeatherViewController.swift
//  Iweather
//
//  Created by 김기현 on 2023/09/25.
//

import UIKit
import Moya
import SnapKit

class WeatherViewController: UIViewController {
    private let weatherService = MoyaProvider<WeatherAPI>(plugins: [NetworkLoggerPlugin()])
    
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private var isCelsius = true
    
    private let FCChangeButton: UIButton = {
          let button = UIButton()
          button.setTitle("C", for: .normal)
          button.setTitleColor(.black, for: .normal)
          button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
          return button
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        let exclude = "hourly,daily"
        
        getWeatherData(exclude: exclude)
        FCChangeButton.addTarget(self, action: #selector(FCChange), for: .touchUpInside)

        
    }
    
    private func configureUI() {
        view.addSubview(cityNameLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(humidityLabel)
        view.addSubview(windSpeedLabel)
        view.addSubview(weatherDescriptionLabel)
        view.addSubview(FCChangeButton)
        
        FCChangeButton.snp.makeConstraints {
            $0.top.equalTo(cityNameLabel.snp.top)
                $0.trailing.equalToSuperview().inset(20)
            }
        
        cityNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        temperatureLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cityNameLabel.snp.bottom).offset(20)
        }
        
        
        humidityLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(20)
        }
        
        weatherDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(humidityLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        windSpeedLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(humidityLabel.snp.bottom).offset(20)
        }
        view.backgroundColor = .white
    }
    
    private func getWeatherData(exclude: String) {
        print("요청중")
        weatherService.request(.getWeatherForCity("busan")) { result in
            switch result {
            case let .success(response):
                do {
                    let weatherData = try response.map(WeatherManager.self)
                    DispatchQueue.main.async {
                        self.updateUI(with: weatherData)
                    }
                } catch {
                    self.showError(message: "날씨 정보를 파싱하는 중 오류가 발생했습니다: \(error)")
                }
            case let .failure(error):
                self.showError(message: "날씨 정보를 가져오는 중 오류가 발생했습니다: \(error.localizedDescription)")
                print("네트워크 에러: \(error)")
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateUI(with weatherData: WeatherManager) {
        cityNameLabel.text = weatherData.name ?? "Unknown"
        let temperature = isCelsius ? weatherData.main.temp : weatherData.temperatureInFahrenheit ?? 0
        temperatureLabel.text = "날씨:\(weatherData.main.temp)°C"
        humidityLabel.text = "습도:\(weatherData.main.humidity)%"
        windSpeedLabel.text = "풍속:\(weatherData.wind?.speed ?? 0) m/s"
        weatherDescriptionLabel.text = weatherData.weather?.first??.description ?? "No data"
        print("UI 업데이트")
    }
    @objc private func FCChange() {
        isCelsius.toggle()
        FCChangeButton.setTitle(isCelsius ? "C" : "F", for: .normal)

    }
    private func showError(message: String) {
        let alertController = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}







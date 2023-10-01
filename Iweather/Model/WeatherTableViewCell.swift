import UIKit
import Foundation

class WeatherTableViewCell: UITableViewCell {
    static let identifier = "WeatherTableViewCell"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(temperatureLabel)
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        weatherImageView.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.leading.equalTo(weatherImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with weatherData: WeatherData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let date = Date(timeIntervalSince1970: TimeInterval(weatherData.date))
        let dateString = dateFormatter.string(from: date)

        dateLabel.text = dateString
        weatherImageView.image = UIImage(named: weatherData.icon)

        // 화씨에서 섭씨로 변환
        let celsiusTemperature = (weatherData.temperature) + 273.15
        temperatureLabel.text = "\(String(format: "%.1f", celsiusTemperature))°C"
    }
}

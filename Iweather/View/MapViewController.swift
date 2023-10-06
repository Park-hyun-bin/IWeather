//
//  MapViewController.swift
//  Iweather
//
//  Created by 김기현 on 2023/09/25.
//

import UIKit
import MapKit
import SnapKit
import Moya
import Kingfisher
import Gifu

class MapViewController: UIViewController {

    private let weatherService = MoyaProvider<WeatherAPI>(plugins: [NetworkLoggerPlugin()])

    var mapView: MKMapView!
    var textField: UITextField!
    var tableView: UITableView!
    var searchResults = [Welcome]()
    var searchResults2 = [Weather]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        setupMapView()
        setupTextField()
        setupTableView()
    }

    func setupBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background5")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setupMapView() {
        mapView = MKMapView()
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 10.0
        mapView.layer.masksToBounds = true
        view.addSubview(mapView)

        mapView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(300)
        }
    }

    func setupTextField() {
        textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "주소를 입력하세요."
        textField.delegate = self
        textField.layer.cornerRadius = 10.0
        view.addSubview(textField)

        textField.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
    }

    func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell instance
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        // Fetch the data for the cell
        let welcome = searchResults[indexPath.row]
        let weather = searchResults2[indexPath.row]
        
        // Set the label text
        cell.label.text = welcome.city.name
        
        // Load the GIF into iconImageView
        let gifUrlString = "https://example.com/your-gif.gif" // Replace with your GIF URL
        if let gifUrl = URL(string: gifUrlString) {
            cell.iconImageView.animate(withGIFNamed: "drizzle")
        }
        
        // Load the weather icon into iconImageView
        if let weatherIconUrl = URL(string: "https://openweathermap.org/img/w/\(weather.icon).png") {
            cell.iconImageView.kf.setImage(with: weatherIconUrl)
        }
        
        // Return the configured cell
        return cell
    }

}




extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, !text.isEmpty {
            // Search for the address and update the map
            AddressDecoder.getGeocodeAddress(query: text) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let geocode):
                    if let firstAddress = geocode.addresses.first {
                        if let latitude = Double(firstAddress.latitude), let longitude = Double(firstAddress.longitude) {
                            print("Latitude: \(latitude), Longitude: \(longitude)")
                            DispatchQueue.main.async {
                                self.mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
                            }
                            weatherService.request(.getWeatherForLocation(latitude: latitude, longitude: longitude, days: 1)) { result in
                                switch result {
                                case .success(let response):
                                    let welcomedata = try? JSONDecoder().decode(Welcome.self, from: response.data)
                                    let weatherData = try? JSONDecoder().decode(Welcome.self, from: response.data)
                                    if let firstList = weatherData?.list.first, let firstWeather = firstList.weather.first{
                                        print(weatherData)
                                        print("닐값이 안떠야함")
                                        self.searchResults.append(welcomedata!)
                                        self.searchResults2.append(firstWeather)}
                                    self.tableView.reloadData()
                                    case . failure(let error):
                                    break
                                }
                            }
                            let userInfo: [String: Any] = ["address": firstAddress.jibunAddress, "latitude": latitude, "longitude": longitude]
                            NotificationCenter.default.post(name: .didUpdateLocationForWeather, object: nil, userInfo: userInfo)
                            NotificationCenter.default.post(name: .didUpdateLocation, object: nil, userInfo: ["address": firstAddress.jibunAddress])
                        } else {
                            self.showAlert(title: "오류", message: "Invalid coordinates")
                        }
                    } else {
                        self.showAlert(title: "오류", message: "No matching location found")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(title: "오류", message: "Geocode error: \(error.localizedDescription)")
                    }
                }
            }
        }
        return true
    }
}



extension UIViewController {
    func showAlert(title: String?, message: String?, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension Notification.Name {
    static let didUpdateLocation = Notification.Name("didUpdateLocation")
}

extension MapViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteSearchResult(at: indexPath)
            completionHandler(true)
        }

        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }

    private func deleteSearchResult(at indexPath: IndexPath) {
        // Remove the item from the data source
        searchResults.remove(at: indexPath.row)

        // Update the table view
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

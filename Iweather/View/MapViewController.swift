//
//  MapViewController.swift
//  Iweather
//
//  Created by 김기현 on 2023/09/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var mapView: MKMapView!
    var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }

    func setupMapView() {
        mapView = MKMapView(frame: view.frame)
        view.addSubview(mapView)

        textField = UITextField(frame: CGRect(x: 20, y: 70, width: view.frame.width - 40, height: 40))
        textField.backgroundColor = .white
        textField.placeholder = "주소를 입력하세요."
        textField.delegate = self
        textField.becomeFirstResponder()
        textField.layer.cornerRadius = 20.0
        view.addSubview(textField)
    }
}

extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let address = textField.text, !address.isEmpty {
            AddressDecoder.getGeocodeAddress(query: address) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let geocode):
                    if let firstAddress = geocode.addresses.first {
                        if let latitude = Double(firstAddress.latitude), let longitude = Double(firstAddress.longitude) {
                            print("Latitude: \(latitude), Longitude: \(longitude)")
                            DispatchQueue.main.async {
                                self.mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
                            }
                            NotificationCenter.default.post(name: .didUpdateLocation, object: nil, userInfo: ["address": firstAddress.jibunAddress])
                        } else {
                            self.showAlert(title: "Error", message: "Invalid coordinates")
                        }
                    } else {
                        self.showAlert(title: "Error", message: "No matching location found")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: "Geocode error: \(error.localizedDescription)")
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

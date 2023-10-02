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
    var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        setupMapView()
        setupTextField()
    }

    func setupContainerView() {
        // Create a container view
        containerView = UIView(frame: CGRect(x: 20, y: 120, width: view.frame.width - 40, height: 400))
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
    }

    func setupMapView() {
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: containerView.frame.width, height: 300))
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 10.0
        mapView.layer.masksToBounds = true

        containerView.addSubview(mapView)
    }


    func setupTextField() {
        textField = UITextField(frame: CGRect(x: 0, y: 320, width: containerView.frame.width, height: 40))
        textField.backgroundColor = .white
        textField.placeholder = "주소를 입력하세요."
        textField.delegate = self
        textField.layer.cornerRadius = 10.0
        containerView.addSubview(textField)
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
                        } else {
                            self.showAlert(title: "오류", message: "Invalid coordinates")
                        }
                    } else {
                        self.showAlert(title: "오류", message: "No matching location found")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(title: "오", message: "Geocode error: \(error.localizedDescription)")
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


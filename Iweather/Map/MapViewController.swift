//
//  MapViewController.swift
//  Iweather
//
//  Created by 김기현 on 2023/09/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var mapView: MapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }

    func setupMapView() {
        mapView = MapView(frame: view.frame)
        view.addSubview(mapView)

        // Move the map to a specific location (example: Seoul, South Korea)
        let latitude = 37.5665
        let longitude = 126.9780
        mapView.moveMapToLocation(latitude: latitude, longitude: longitude)
    }
}

//extension MapViewController : UITextFieldDelegate{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let address = textField.text, !address.isEmpty {
//            AddressDecoder.getGeocodeAddress(query: address) { [weak self] result in
//                guard let self = self else {return}
//                switch result {
//                case .success(let geocode):
//                    if let firstAddress = geocode.addresses.first {
//                        let latitude = firstAddress.latitude
//                        let longitude = firstAddress.longitude
//                        print(latitude)
//                        print(longitude)
//                        DispatchQueue.main.async{ [weak self] in
//                            guard let self = self else {return }
//                            mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat:Double(latitude)!, lng:Double(longitude)!)))
//                        }
//                    } else {
//
//                        DispatchQueue.main.async{ [weak self] in
//                            guard let self = self else {return }
//                            showAlert(title: "에러", message: "주소를 찾을 수 없습니다")
//                        }
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async{ [weak self] in
//                        guard let self = self else {return }
//                        showAlert(title: "에러", message: "주소 디코딩 오류: \(error.localizedDescription)")
//                    }
//                }
//            }
//            textField.resignFirstResponder()
//        }
//        return true
//    }
//}

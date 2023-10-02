//
//  MapItem.swift
//  Iweather
//
//  Created by t2023-m0049 on 2023/09/26.
//

import UIKit
import MapKit

class MapView: MKMapView, UITextFieldDelegate {
    
    var floatingButton: UIButton!
    var textField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        mapType = .standard
        showsUserLocation = true
        
        // 텍스트 필도
        textField = UITextField(frame: CGRect(x: 20, y: 70, width: frame.width - 40, height: 40))
        textField.backgroundColor = .white
        textField.placeholder = "주소를 입력해주세요."
        textField.delegate = self
        textField.layer.cornerRadius = 20.0
        textField.becomeFirstResponder()
        addSubview(textField)
        
    }

    
    func moveMapToLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Zoom level
        let region = MKCoordinateRegion(center: location, span: span)
        setRegion(region, animated: true)
    }
}

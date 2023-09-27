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

        // Setup text field
        textField = UITextField(frame: CGRect(x: 20, y: 70, width: frame.width - 40, height: 40))
        textField.backgroundColor = .white
        textField.placeholder = "Enter location"
        textField.delegate = self
        textField.becomeFirstResponder()
        addSubview(textField)

        // Setup floating button
        let buttonSize: CGFloat = 50
        let buttonFrame = CGRect(x: frame.width - buttonSize - 20,
                                 y: frame.height - buttonSize - 100,
                                 width: buttonSize,
                                 height: buttonSize)

        floatingButton = UIButton(frame: buttonFrame)
        floatingButton.backgroundColor = .blue
        floatingButton.setTitle("Button", for: .normal)
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)

        addSubview(floatingButton)
    }

    @objc func floatingButtonTapped() {
        // Implement the action for the floating button
        print("Floating button tapped!")
    }

    func moveMapToLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Zoom level
        let region = MKCoordinateRegion(center: location, span: span)
        setRegion(region, animated: true)
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

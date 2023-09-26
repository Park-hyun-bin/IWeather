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
        textField.placeholder = "주소를 입력해라."
        textField.delegate = self// Set the delegate
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
        print("버튼 작동")
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("작동완료")
    }
}


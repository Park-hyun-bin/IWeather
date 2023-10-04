//
//  MapItem.swift
//  Iweather
//
//  Created by t2023-m0049 on 2023/09/26.
//

//import UIKit
//import MapKit
//
//class MapView: MKMapView, UITextFieldDelegate {
//
//    var floatingButton: UIButton!
//    var textField: UITextField!
//    var addressArray: [String] = []
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    private func commonInit() {
//        mapType = .standard
//        showsUserLocation = true
//
//        // 텍스트 필도
//        textField = UITextField(frame: CGRect(x: 20, y: 70, width: frame.width - 40, height: 40))
//        textField.backgroundColor = .white
//        textField.placeholder = "주소를 입력해주세요."
//        textField.delegate = self
//        textField.layer.cornerRadius = 20.0
//        textField.becomeFirstResponder()
//        addSubview(textField)
//
//    }
//
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            guard let text = textField.text else { return true }
//            let newText = (text as NSString).replacingCharacters(in: range, with: string)
//            // Update the address array whenever the text changes
//            updateAddressArray(newText)
//            return true
//        }
//
//        private func updateAddressArray(_ newText: String) {
//            // Update the array with the current text (you can add more logic if needed)
//            // For simplicity, we'll just add the text to the beginning of the array
//            addressArray.insert(newText, at: 0)
//        }
//    }

//
//  MapViewController.swift
//  Iweather
//
//  Created by 김기현 on 2023/09/25.
//

import UIKit

class MapViewController: UIViewController {

    var mapView: MapView!
    var floatingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupFloatingButton()
    }

    func setupMapView() {
        mapView = MapView(frame: view.frame)
        view.addSubview(mapView)
    }

    func setupFloatingButton() {
        let buttonSize: CGFloat = 50
        let buttonFrame = CGRect(x: view.frame.width - buttonSize - 20,
                                 y: view.frame.height - buttonSize - 100,
                                 width: buttonSize,
                                 height: buttonSize)
        
        floatingButton = UIButton(frame: buttonFrame)
        floatingButton.backgroundColor = .blue
        floatingButton.setTitle("Button", for: .normal)
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        

        view.addSubview(floatingButton)
    }

    @objc func floatingButtonTapped() {
        // Implement the action for the floating button
        print("Floating button tapped!")
    }
}

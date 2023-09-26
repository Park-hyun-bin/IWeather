//
//  MapItem.swift
//  Iweather
//
//  Created by t2023-m0049 on 2023/09/26.
//

import UIKit
import MapKit

class MapView: MKMapView {

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
    }
}


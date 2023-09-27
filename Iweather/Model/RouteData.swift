//
//  RouteData.swift
//  Iweather
//
//  Created by t2023-m0049 on 2023/09/27.
//

import Foundation
struct RouteData: Codable {
    let code: Int
    let message: String
    let currentDateTime: String
    let route: RouteInfo
}

struct RouteInfo: Codable {
    let traoptimal: [RouteDetail]
}

struct RouteDetail: Codable {
    struct Summary: Codable {
        struct Location: Codable {
            let location: [Double]
        }
        struct Goal: Codable {
            let location: [Double]
            let dir: Int
        }

        let start: Location
        let goal: Goal
        let distance: Int
        let duration: Int
        let etaServiceType: Int
        let departureTime: String
        let bbox: [[Double]]
        let tollFare: Int
        let taxiFare: Int
        let fuelPrice: Int
    }
    
    struct Guide: Codable {
        let pointIndex: Int
        let type: Int
        let instructions: String
        let distance: Int
        let duration: Int
    }

    let summary: Summary
    let path: [[Double]]
    let section: [Section]
    let guide: [Guide]
}

struct Section: Codable {
    let pointIndex: Int
    let pointCount: Int
    let distance: Int
    let name: String
    let congestion: Int
    let speed: Int
}

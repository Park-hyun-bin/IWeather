//
//  geocode.swift
//  Iweather
//
//  Created by t2023-m0049 on 2023/09/27.
//

import Foundation

struct Geocode: Codable {
    let status: String
    let meta: Meta
    let addresses: [Address]
    let errorMessage: String
}

struct Address: Codable {
    let roadAddress, jibunAddress, englishAddress: String
    let addressElements: [AddressElement]
    let longitude, latitude: String
    let distance: Int

    enum CodingKeys: String, CodingKey {
        case roadAddress, jibunAddress, englishAddress, addressElements, distance
        case longitude = "x"
        case latitude = "y"
    }
}

struct AddressElement: Codable {
    let types: [String]
    let longName, shortName, code: String
}

struct Meta: Codable {
    let totalCount, page, count: Int
}

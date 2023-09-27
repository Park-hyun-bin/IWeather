////
////  Acood.swift
////  Iweather
////
////  Created by t2023-m0049 on 2023/09/26.
////
//
//import Foundation
//
//class AddressDecoder{
//    
//    static func getGeocodeAddress(query: String,  completion: @escaping (Result<Geocode, Error>) -> Void) {
//        let baseURL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode"
//        let queryItem = URLQueryItem(name: "query", value: query)
//        let apiKeyIDItem = URLQueryItem(name: "X-NCP-APIGW-API-KEY-ID", value: "l6dksoybms")
//        let apiKeyItem = URLQueryItem(name: "X-NCP-APIGW-API-KEY", value: "qxknjVihYeuFj50eI6KJxkZvbX2bAuS4y6fybr2s")
//        
//        var urlComponents = URLComponents(string: baseURL)
//        urlComponents?.queryItems = [queryItem, apiKeyIDItem, apiKeyItem]
//        
//        guard let url = urlComponents?.url else {
//            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let geocode = try decoder.decode(Geocode.self, from: data)
//                completion(.success(geocode))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//    static func getDirectionRouteData(startCoordinate: String, goalCoordinate : String,  completion: @escaping (Result<RouteData, Error>) -> Void) {
//        let baseURL = "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?"
//        let startqueryItem = URLQueryItem(name: "start", value: startCoordinate)
//        let goalqueryItem = URLQueryItem(name: "goal", value: goalCoordinate)
//        let apiKeyIDItem = URLQueryItem(name: "X-NCP-APIGW-API-KEY-ID", value: "l6dksoybms")
//        let apiKeyItem = URLQueryItem(name: "X-NCP-APIGW-API-KEY", value: "qxknjVihYeuFj50eI6KJxkZvbX2bAuS4y6fybr2s")
//        
//        var urlComponents = URLComponents(string: baseURL)
//        urlComponents?.queryItems = [startqueryItem,goalqueryItem, apiKeyIDItem, apiKeyItem]
//        
//        guard let url = urlComponents?.url else {
//            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                let routeData = try decoder.decode(RouteData.self, from: data)
//                completion(.success(routeData))
//            } catch {
//                print(error.localizedDescription.description)
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//    
//    
//}

import Foundation

class UserDefaultsManager {

    static let shared = UserDefaultsManager()

    private init() {}  // 싱글톤패턴

    func saveLastSearchedLocation(latitude: Double, longitude: Double, address: String) {
        UserDefaults.standard.set(latitude, forKey: "lastSearchedLatitude")
        UserDefaults.standard.set(longitude, forKey: "lastSearchedLongitude")
        UserDefaults.standard.set(address, forKey: "lastSearchedAddress")
    }

    func getLastSearchedLocation() -> (latitude: Double, longitude: Double, address: String)? {
        if let latitude = UserDefaults.standard.value(forKey: "lastSearchedLatitude") as? Double,
           let longitude = UserDefaults.standard.value(forKey: "lastSearchedLongitude") as? Double,
           let address = UserDefaults.standard.value(forKey: "lastSearchedAddress") as? String {
            return (latitude, longitude, address)
        }
        return nil
    }
}

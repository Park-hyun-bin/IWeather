import UIKit

class WeeklyWeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color of the view
        view.backgroundColor = .white
        
        // Create a UILabel for the location
        let locationLabel = UILabel()
        locationLabel.text = "[지역표시]"
        locationLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        // Add the locationLabel to the view hierarchy
        view.addSubview(locationLabel)
        
        // Enable Auto Layout for the locationLabel
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create constraints for the locationLabel considering the Safe Area
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
    }
}

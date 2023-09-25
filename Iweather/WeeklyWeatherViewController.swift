import UIKit

class WeeklyWeatherViewController: UIViewController {
    
    private let currentLocation: UILabel = {
        let label = UILabel()
        label.text = "[지역표시]"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dayViews: [UIView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        view.addSubview(currentLocation)
        
        setupDayViews()
        setupLayout()

    }
    
    private func setupDayViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d일"
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        for i in 0..<4 {
            let dayView = UIView()
            dayView.backgroundColor = .gray
            dayView.translatesAutoresizingMaskIntoConstraints = false
            
            let dayLabel = UILabel()
            let date = calendar.date(byAdding: .day, value: i, to: currentDate)!
            dayLabel.text = dateFormatter.string(from: date) // 순서대로 +1일씩 증가하는 일자를 설정
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            dayView.addSubview(dayLabel)
            
            NSLayoutConstraint.activate([
                dayLabel.centerXAnchor.constraint(equalTo: dayView.centerXAnchor),
                dayLabel.centerYAnchor.constraint(equalTo: dayView.centerYAnchor)
            ])
            
            dayViews.append(dayView)
            view.addSubview(dayView)
        }
    }

    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            currentLocation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentLocation.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16)
        ])
        
        let spacing: CGFloat = 5
        let dayViewWidth: CGFloat = (view.frame.width - spacing * 3) / 4
        var previousView: UIView?
        for dayView in dayViews {
            NSLayoutConstraint.activate([
                dayView.widthAnchor.constraint(equalToConstant: dayViewWidth),
                dayView.topAnchor.constraint(equalTo: currentLocation.bottomAnchor, constant: 10), // 여기를 수정하여 10픽셀의 간격을 추가합니다.
                view.bottomAnchor.constraint(equalTo: dayView.bottomAnchor, constant: 120)
            ])
            
            if let previousView = previousView {
                dayView.leadingAnchor.constraint(equalTo: previousView.trailingAnchor, constant: spacing).isActive = true
            } else {
                dayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            }
            previousView = dayView
        }
    }



}

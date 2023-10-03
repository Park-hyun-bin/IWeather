//
//  RecommandView.swift
//  Iweather
//
//  Created by Hyunwoo Lee on 2023/09/27.
//
//

import UIKit
import SnapKit
import Moya

class RecomanndViewController: UIViewController {
 
    private let weatherService = MoyaProvider<WeatherAPI>(plugins: [NetworkLoggerPlugin()])
     
    private var backImage: UIImageView = {
        let backImage = UIImageView()
        return backImage
    }()

    private var backbtn: UIButton = {
        let backbtn = UIButton()
        backbtn.tintColor = .white
        backbtn.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
        backbtn.frame = CGRect(x: 0, y: 0, width: 21, height: 17.5)
        return backbtn
    }()
    
    private var commentContainer: UIView = {
        let commentContainer = UIView()
        commentContainer.backgroundColor = .white
        commentContainer.layer.cornerRadius = 20
        commentContainer.clipsToBounds = true
        commentContainer.alpha = 0.3
        return commentContainer
    }()
    
    private var commentLabel: UILabel = {
        let commentLabel = UILabel()
        commentLabel.textColor = .white
        commentLabel.font = UIFont.boldSystemFont(ofSize: 30)
        return commentLabel
    }()
    
    private var recoView: UIImageView = {
        let recoView = UIImageView()
        recoView.image = UIImage(named: "7")
        recoView.alpha = 0.6
        recoView.layer.cornerRadius = 20
        recoView.clipsToBounds = true
        return recoView
    }()
    
    private var textContainer: UIView = {
        let textContainer = UIView()
        textContainer.backgroundColor = .white
        textContainer.layer.cornerRadius = 20
        textContainer.clipsToBounds = true
        textContainer.alpha = 0.3
        return textContainer
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "오늘 추천 메뉴"
        label.textColor = .white
        return label
    }()
    
    private var menuLabel: UILabel = {
        let menuLabel = UILabel()
        menuLabel.font = UIFont.boldSystemFont(ofSize: 18)
        menuLabel.numberOfLines = 2
        menuLabel.textColor = .white
        return menuLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
        initConstraints()
        buttonSetup()
        
        let exclude = "hourly,daily"
        getWeatherData(exclude: exclude)
    }
}

extension RecomanndViewController {
    
    func initConstraints() {
        view.addSubview(backImage)
        view.addSubview(commentContainer)
        view.addSubview(commentLabel)
        view.addSubview(recoView)
        view.addSubview(backbtn)
        view.addSubview(textContainer)
        view.addSubview(label)
        view.addSubview(menuLabel)
        
        backImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backbtn.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
        commentContainer.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(backbtn.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        commentLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(commentContainer)
        }
        recoView.snp.makeConstraints {
            $0.top.equalTo(commentContainer.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        textContainer.snp.makeConstraints {
            $0.height.equalTo(150)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(recoView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(58)
        }
        label.snp.makeConstraints {
            $0.centerX.equalTo(textContainer.snp.centerX)
            $0.top.equalTo(textContainer.snp.top).offset(24)
        }
        menuLabel.snp.makeConstraints {
            $0.centerX.equalTo(textContainer.snp.centerX)
            $0.top.equalTo(label.snp.bottom).offset(24)
        }
    }
    
    func buttonSetup() {
        backbtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
    }
    
    @objc func backBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    private func getWeatherData(exclude: String) {
           print("요청중")
           weatherService.request(.getWeatherForCity("gangwon", days: 5)) { result in
               switch result {
               case let .success(response):
                   do {
                       let welcome = try response.map(Welcome.self)
                       DispatchQueue.main.async {
                           self.updateUI(with: welcome)
                           if let tempMax = welcome.list.first?.main.tempMax {
                                                  self.updateRecoView(tempMax: tempMax)
                           }
                        }
                   } catch {
                       self.showError(message: "날씨 정보를 파싱하는 중 오류가 발생했습니다: \(error)")
                   }
               case let .failure(error):
                   self.showError(message: "날씨 정보를 가져오는 중 오류가 발생했습니다: \(error.localizedDescription)")
                   print("네트워크 에러: \(error)")
               }
           }
       }

    private func updateUI(with welcome: Welcome) {
        print("UI 업데이트")
        //현재 시간에 임으로 9시간 추가 (UTC+9로 나타내기 위함)
        let currentTime = Date() + 32_400
        let (sunriseStart, sunriseEnd, sunsetStart, sunsetEnd) = calculateSunriseAndSunsetTimes(weatherResponse: welcome)
        determinePhotoToShow(currentTime: currentTime, sunriseStart: sunriseStart, sunriseEnd: sunriseEnd, sunsetStart: sunsetStart, sunsetEnd: sunsetEnd)
        print(sunsetEnd)
        print(sunsetStart)
        print(sunriseEnd)
        print(sunriseStart)
        print(currentTime)
    }
        func calculateSunriseAndSunsetTimes(weatherResponse: Welcome) -> (Date, Date, Date, Date) {
            
            let sunrise = Date(timeIntervalSince1970: TimeInterval(weatherResponse.city.sunrise) + 32_400)
            let sunset = Date(timeIntervalSince1970: TimeInterval(weatherResponse.city.sunset) + 32_400)
            let sunriseStart = sunrise.addingTimeInterval(-30 * 60)
            let sunriseEnd = sunrise.addingTimeInterval(30 * 60)
            let sunsetStart = sunset.addingTimeInterval(-30 * 60)
            let sunsetEnd = sunset.addingTimeInterval(30 * 60)
            return (sunriseStart, sunriseEnd, sunsetStart, sunsetEnd)
        }
    
    func determinePhotoToShow(currentTime: Date, sunriseStart: Date, sunriseEnd: Date, sunsetStart: Date, sunsetEnd: Date) {
        // 일출 진행중 사진
        if currentTime >= sunriseStart && currentTime <= sunriseEnd {
            return backImage.image = UIImage(named: "sunrise")
        }
        // 일몰 진행중 사진
        if currentTime >= sunsetStart && currentTime <= sunsetEnd {
            return backImage.image = UIImage(named: "sunset")
        }
        // 밤 사진
        if currentTime >= sunsetEnd || currentTime <= sunriseStart {
            return backImage.image = UIImage(named: "night")
        }
        // 낮 사진
        return backImage.image = UIImage(named: "day")
    }
    
    func updateRecoView(tempMax: Double) {
        var imageName = ""
        var comment = ""
        var menu1 = ""
        var menu2 = ""
        
        switch tempMax {
        case ..<3:
            imageName = "verycold"
            comment = "스키 타기"
            menu1 = "스키 타고 출출할때"
            menu2 = "따뜻한 컵라면"
        case 3..<10:
            imageName = "cold"
            comment = "스파 가기"
            menu1 = "찜질방에서 맥반석 달걀과"
            menu2 = "식혜 한잔"
        case 10..<15:
            imageName = "chilly"
            comment = "캠핑 가기"
            menu1 = "숯불에 구운 삼겹살과"
            menu2 = "맥주 한잔"
        case 15..<20:
            imageName = "cool"
            comment = "소풍 가기"
            menu1 = "돗자리 펴고 김밥과"
            menu2 = "샌드위치"
        case 20..<26:
            imageName = "warm"
            comment = "여행 가기"
            menu1 = "바닷가에서 조개구이와"
            menu2 = "소주 한잔"
        case 26..<32:
            imageName = "hot"
            comment = "물놀이 가기"
            menu1 = "계곡에서 백숙과"
            menu2 = "시원한 수박"
        default:
            imageName = "veryhot"
            comment = "집에 있기"
            menu1 = "시원하게 에어컨 틀고"
            menu2 = "냉면 한그릇"
        }
        
        recoView.image = UIImage(named: imageName)
        commentLabel.text = "\(comment) 좋은 날"
        menuLabel.text = """
                         \(menu1)
                         \(menu2) 어떠신가요?
                         """
    }
    
    private func showError(message: String) {
        let alertController = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

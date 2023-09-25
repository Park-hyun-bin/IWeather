//
//  TabBarControlelr.swift
//  Iweather
//
//  Created by 김기현 on 2023/09/25.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 탭 바 아이콘 및 타이틀 설정
        let tabs: [(root: UIViewController, icon: String, title: String)] = [
            (MainViewController(), "house", "홈"),
            (WeatherViewController(), "sun.max", "날씨"),
            (DailyImageViewController(), "calendar", "일별 이미지"),
            (MapViewController(), "map", "지도")
        ]

        // 탭 바에 뷰 컨트롤러 설정
        viewControllers = tabs.map { root, icon, title in
            let navigationController = UINavigationController(rootViewController: root)
            let tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: icon), selectedImage: UIImage(systemName: "\(icon).fill"))
            navigationController.tabBarItem = tabBarItem
            return navigationController
        }
    }
}

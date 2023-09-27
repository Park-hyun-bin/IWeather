//
//  RecommandView.swift
//  Iweather
//
//  Created by Hyunwoo Lee on 2023/09/27.
//

import UIKit
import SnapKit

class RecomanndViewController: UIViewController {
    
    // back 버튼을 없애고 가운데에 아래 방향 화살표를 넣어서 SwipeDown으로 변경 고민중
    // 기온별 옷차림
    
    
    private var backImage: UIImageView = {
        let backImage = UIImageView()
        backImage.image = UIImage(named: "4")
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
  //      commentLabel.font = UIFont.boldSystemFont(ofSize: 30)
        commentLabel.text = "스파가기 좋은날"
        commentLabel.textColor = .white
        commentLabel.font = UIFont(name: "GmarketSansBold", size: 30)
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
        label.font = UIFont(name: "GmarketSansMedium", size: 24)
        label.text = "오늘 추천 메뉴"
        label.textColor = .white
        return label
    }()
    
    private var menuLabel: UILabel = {
        let menuLabel = UILabel()
        menuLabel.font = UIFont(name: "GmarketSansMedium", size: 18)
        menuLabel.text = """
                         찜질방에서 맥반석 계란과
                         식혜 한잔 어떠신가요?
                         """
        menuLabel.numberOfLines = 3
        menuLabel.textColor = .white
        return menuLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initConstraints()
        buttonSetup()
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
        
        backImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backbtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        commentContainer.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(backbtn.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        commentLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(commentContainer)
        }
        recoView.snp.makeConstraints { make in
            make.top.equalTo(commentContainer.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        textContainer.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(recoView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(58)
        }
        label.snp.makeConstraints { make in
            make.centerX.equalTo(textContainer.snp.centerX)
            make.top.equalTo(textContainer.snp.top).offset(24)
        }
        menuLabel.snp.makeConstraints { make in
            make.centerX.equalTo(textContainer.snp.centerX)
            make.top.equalTo(label.snp.bottom).offset(24)
        }
    }
    
    func buttonSetup() {
        backbtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
    }
    
    @objc func backBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}


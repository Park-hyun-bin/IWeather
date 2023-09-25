//
//  RecommandViewController.swift
//  Iweather
//
//  Created by Hyunwoo Lee on 2023/09/25.
//

import UIKit

class RecoViewController: UIViewController {
    
    
    var backbtn: UIButton = {
        let backbtn = UIButton()
        backbtn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backbtn.frame = CGRect(x: 0, y: 0, width: 21, height: 17.5)
        return backbtn
    }()
    
    private var recoView: UIView = {
        let recoView = UIView()
        recoView.backgroundColor = .gray
        return recoView
    }()
    
    private var label1: UILabel = {
        let label1 = UILabel()
        label1.text = "산책하기 좋은날"
        label1.font = UIFont.systemFont(ofSize: 30)
        return label1
    }()
    
    private var label2: UILabel = {
        let label2 = UILabel()
        label2.text = "오늘 추천 메뉴"
        label2.font = UIFont.systemFont(ofSize: 22)
        return label2
    }()
    
    private var label3: UILabel = {
        let label3 = UILabel()
        label3.text = """
                          막걸리에 파전
                          어떠신가요?
                          """
        label3.font = UIFont.systemFont(ofSize: 16)
        label3.numberOfLines = 2
        return label3
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeRecognizer()
        setGradient(color1:UIColor.green, color2:UIColor.yellow, color3: UIColor.red)
        setup()
        recoConfigureUI()
    }
}

extension RecoViewController {
    func setup() {
        view.addSubview(recoView)
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(backbtn)
        backbtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
    }
    func recoConfigureUI() {
        recoView.translatesAutoresizingMaskIntoConstraints = false
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        backbtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //            backbtn.widthAnchor.constraint(equalToConstant: 21),
            //            backbtn.heightAnchor.constraint(equalToConstant: 17.5),
            backbtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backbtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 58),
            
            recoView.topAnchor.constraint(equalTo: backbtn.bottomAnchor, constant: 10),
            recoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300),
            recoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            recoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            label1.centerXAnchor.constraint(equalTo: recoView.centerXAnchor),
            label1.topAnchor.constraint(equalTo: recoView.topAnchor, constant: 100),
            
            label2.centerXAnchor.constraint(equalTo: recoView.centerXAnchor),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 100),
            
            label3.centerXAnchor.constraint(equalTo: recoView.centerXAnchor),
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 20)
            
        ])
    }
    
    func setGradient(color1: UIColor,color2: UIColor, color3: UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
        gradient.locations = [0.0, 0.4, 0.8, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    @objc func backBtnTapped() {
        
    }
    @objc func swipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                // 스와이프 시, 원하는 기능 구현.
                self.dismiss(animated: true, completion: nil)
            default: break
            }
        }
    }
}



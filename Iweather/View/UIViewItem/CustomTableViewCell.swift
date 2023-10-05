//
//  aaaa.swift
//  Iweather
//
//  Created by t2023-m0049 on 2023/10/05.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var iconImageView: UIImageView!
    var label: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)

        label = UILabel(frame: CGRect(x: 40, y: 0, width: contentView.frame.width - 40, height: 30))
        label.textColor = .black
        contentView.addSubview(label)
        
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


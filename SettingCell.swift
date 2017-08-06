//
//  SettingCell.swift
//  MyYouTube
//
//  Created by Elf on 17.07.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray : .white
            iconImageView.tintColor = isHighlighted ? .white : .darkGray
            nameLabel.textColor = isHighlighted ? .white : .black
        }
    }
    
    var setting: Setting? {
        didSet {
            if let newSetting = setting {
                nameLabel.text = newSetting.name.rawValue
                iconImageView.image = UIImage(named: newSetting.imageName)?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupViews() {
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0(25)]-8-[v1]|", views: iconImageView, nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(25)]", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

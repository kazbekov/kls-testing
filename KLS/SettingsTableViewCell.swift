//
//  SettingsTableViewCell.swift
//  KLS
//
//  Created by Dias Dosymbaev on 4/13/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Cartography

class SettingsTableViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.tintColor = .red
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [titleLabel, iconImageView].forEach {
            contentView.addSubview($0)
        }
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        constrain(titleLabel, contentView, iconImageView){titleLabel, contentView, iconImageView in
            titleLabel.centerY == contentView.centerY
            titleLabel.leading == iconImageView.trailing + 15
            iconImageView.leading == contentView.leading + 20
            iconImageView.centerY == contentView.centerY
        }
    }
}

extension SettingsTableViewCell {
    func setUpCellWithProperties(title: String, icon: UIImage) {
        titleLabel.text = title
        iconImageView.image = icon
    }
}



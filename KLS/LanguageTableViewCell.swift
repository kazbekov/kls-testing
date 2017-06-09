//
//  LanguageTableViewCell.swift
//  KLS
//
//  Created by Damir Kazbekov on 6/7/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//


import Foundation
import UIKit
import Cartography

class LanguageTableViewCell: UITableViewCell {
    
    lazy var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18)
    }
    
    lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        [titleLabel, iconImageView].forEach{
            contentView.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, self, iconImageView) {
            titleLabel, view, icon in
            
            icon.centerY == view.centerY
            icon.leading == view.leading + 15
            
            titleLabel.centerY == view.centerY
            titleLabel.leading == icon.trailing + 15
        }
    }
}

extension LanguageTableViewCell {
    func setUpWithTitle(title: String){
        titleLabel.text = title
    }
}

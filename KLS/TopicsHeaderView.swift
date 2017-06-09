//
//  TopicsHeaderView.swift
//  KLS
//
//  Created by Dias Dosymbaev on 4/16/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Sugar
import Cartography
//import RSKPlaceholderTextView

protocol TopicsHeaderViewDelegate {
    //    func didSaveProfile()
}

final class TopicsHeaderView: UIView {
    
    let defaults = UserDefaults.standard
    var delegate: TopicsHeaderViewDelegate?
    
    lazy var backroundImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "image-title-2")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "Математика"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20.0, weight: 0.3)
    }
    
    lazy var subtitleLabel = UILabel().then {
        $0.text = "ТЕМЫ"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 17.0, weight: 0.0)
        $0.alpha = 0.5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
        if defaults.integer(forKey: "language") == 0{
            subtitleLabel.text = "ТЕМЫ"
        } else {
            subtitleLabel.text = "ТАҚЫРЫБТАР"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        [backroundImageView, titleLabel, subtitleLabel].forEach {
            self.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(backroundImageView, self, titleLabel, subtitleLabel) { backroundImageView, view, title, subtitle in
            backroundImageView.top == view.top
            backroundImageView.width == view.width
            backroundImageView.bottom == view.bottom - 5
            backroundImageView.center == view.center
            
            title.center == backroundImageView.center
            
            subtitle.top == title.bottom + 3
            subtitle.centerX == view.centerX
        }
    }
    
}


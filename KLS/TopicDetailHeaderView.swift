//
//  TopicDetailHeaderView.swift
//  KLS
//
//  Created by Dias Dosymbaev on 4/17/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Sugar
import Cartography
//import RSKPlaceholderTextView

protocol TopicDetailHeaderViewDelegate {
    //    func didSaveProfile()
}

final class TopicDetailHeaderView: UIView {
    
    var delegate: TopicDetailHeaderViewDelegate?
    
    lazy var backroundImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "image-title-2")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "Математика"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20.0, weight: 0.3)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        [backroundImageView, titleLabel].forEach {
            self.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(backroundImageView, self, titleLabel ) { backroundImageView, view, title in
            backroundImageView.edges == view.edges
            
            title.center == backroundImageView.center
            title.width == view.width/1.5
        }
    }
    
}


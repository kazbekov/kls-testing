//
//  CollectionViewCell.swift
//  KLS
//
//  Created by Dias Dosymbaev on 4/13/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//


import UIKit
import Sugar
import Cartography
import ChameleonFramework

class CollectionViewCell: UICollectionViewCell {
    
    let defaults = UserDefaults.standard
    lazy var titleLabel: UILabel = {
        return UILabel().then {
            $0.textAlignment = .left
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 30.0, weight: 0.3)
        }
    }()
    
    private lazy var mainView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 3
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.clipsToBounds = true
    }
    
    lazy var titleImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var numberOfTopics = UILabel().then {
        $0.font = .systemFont(ofSize: 50, weight: 0.5)
    }
    
    lazy var topicsLabel = UILabel().then {
        $0.text = "тем"
        $0.font = .systemFont(ofSize: 20, weight: 0.0)
        $0.textColor = HexColor("979797")
    }
    
    lazy var playButton: UIButton = {
        return UIButton().then {
            $0.setTitle("Начать", for: .normal)
            $0.backgroundColor = HexColor("F6CA33")
            $0.layer.cornerRadius = 3
        }
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.addSubview(mainView)
        
        [titleImageView, titleLabel, playButton, numberOfTopics, topicsLabel].forEach {
            mainView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    func setupConstraints() {
        constrain(mainView,contentView, titleImageView, titleLabel, playButton) {
            $0.edges == $1.edges
            
            $2.width == $1.width
            $2.centerX == $1.centerX
            $2.top == $1.top
            $2.height == $1.height - contentView.height/2
            
            $3.center == $2.center
            
            $4.bottom == $1.bottom - 15
            $4.centerX == $1.centerX
            $4.width == $1.width - 80
            $4.height == 45
        }
        
        constrain(numberOfTopics, contentView, titleImageView) {
            $0.centerX == $1.centerX
            $0.top == $2.bottom + 40
        }
        
        constrain(topicsLabel, numberOfTopics) {
            $0.centerX == $1.centerX
            $0.top == $1.bottom
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

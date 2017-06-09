//
//  TopicTableViewCell.swift
//  KLS
//
//  Created by Dias Dosymbaev on 4/17/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Cartography
import ChameleonFramework

class TopicDetailTableViewCell: UITableViewCell {
    //MARK: - Properties
    lazy var titleLabel: UILabel = {
        return UILabel().then{
            $0.text = "TONY & GUY"
            $0.font = .systemFont(ofSize: 17, weight: 0.0)
            $0.textColor = .black
            $0.numberOfLines = 0
        }
    }()
    
    lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = #imageLiteral(resourceName: "icon-book")
    }
    
    lazy var takeQuizButton: UIButton = {
        return UIButton().then {
            $0.setTitle("Take a quiz", for: .normal)
            $0.backgroundColor = HexColor("0070D5")
            $0.layer.cornerRadius = 25
        }
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [titleLabel, iconImageView, takeQuizButton].forEach {
            contentView.addSubview($0)
        }
        
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setups
    
    func setUpViews(){
        
    }
    
    func setUpConstraints() {
        constrain(titleLabel, contentView, iconImageView, takeQuizButton){
            $2.top == $1.top + 15
            $2.centerX == $1.centerX
            
            $0.top == $2.bottom + 15
            $0.centerX == $1.centerX
            $0.width == $1.width - 20
            
            $3.top == $0.bottom + 15
            $3.width == $1.width * 0.5
            $3.centerX == $1.centerX
            $3.bottom == $1.bottom - 15
            $3.height == 50
        }
    }
}


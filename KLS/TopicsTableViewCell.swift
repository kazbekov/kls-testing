//
//  TopicsTableViewCell.swift
//  KLS
//
//  Created by Dias Dosymbaev on 4/16/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Cartography
import ChameleonFramework

class TopicsTableViewCell: UITableViewCell {
    //MARK: - Properties
    lazy var titleLabel: UILabel = {
        return UILabel().then{
            $0.text = "TONY & GUY"
            $0.font = .systemFont(ofSize: 17, weight: 0.0)
            $0.textColor = .black
            $0.numberOfLines = 0
        }
    }()
    
    lazy var numberLabel = UILabel().then {
        $0.textColor = HexColor("F2F5FA")
        $0.font = .systemFont(ofSize: 60.0, weight: 0.3)
    }
    
    lazy var bgView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 3
    }
    
    lazy var topicIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = #imageLiteral(resourceName: "equation")
        $0.clipsToBounds = true
    }
    //MARK: - Lifecycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [bgView, titleLabel, numberLabel, topicIconImageView].forEach {
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
        contentView.backgroundColor = .clear
        topicIconImageView.layer.cornerRadius = 30
    }
    
    func setUpConstraints() {
        constrain(titleLabel, contentView, bgView, numberLabel, topicIconImageView){
            $0.centerY == $1.centerY
            $0.leading == $4.trailing + 20
            $0.width == $1.width/1.4
            
            $2.center == $1.center
            $2.width == $1.width - 20
            $2.height == $1.height  - 10
            
            
            $3.trailing == $1.trailing - 10
            $3.top == $1.top + 5
            
            $4.leading == $1.leading + 20
            $4.centerY == $1.centerY
            $4.width == 60
            $4.height == 60
        }
    }
}


//
//  TopicDetailController.swift
//  KLS
//
//  Created by Dias Dosymbaev on 4/17/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Sugar
import MessageUI
import Cartography
import MXParallaxHeader
import ChameleonFramework

class TopicDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate, MXParallaxHeaderDelegate {
    
    //MARK: -Properties
    var titleText: String?
    var getArray: [String:Any]?
    let defaults = UserDefaults.standard

    private let tableHeaderHeight: CGFloat = 300
    
    private lazy var headerView: TopicDetailHeaderView = {
        return TopicDetailHeaderView(frame: CGRect(x: 0, y: 0,
                                              width: UIScreen.main.bounds.width, height: self.tableHeaderHeight)).then {
                                                _ in
        }
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView.register(TopicDetailTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = HexColor("F7F7F9")
        return tableView
    }()
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        configHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavBar()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        if let viewControllers = self.navigationController?.viewControllers {
            let previousVC: UIViewController? = viewControllers.count >= 2 ? viewControllers[viewControllers.count - 2] : nil;
            previousVC?.title = ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
        UIApplication.shared.statusBarStyle = .default
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
    }
    
    //MARK: -Setups
    
    func setUpViews() {
        self.automaticallyAdjustsScrollViewInsets = false
        setUpNavBar()
        
        [tableView].forEach{
            view.addSubview($0)
        }
    }
    func setUpNavBar(){
        title = ""
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        //        navigationController?.navigationBar.barTintColor = HexColor("DA3C65")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    func setUpConstraints() {
        constrain(tableView, view){ tableView, view in
            tableView.edges == view.edges
        }
    }
    
    func configHeaderView() {
        headerView.titleLabel.text = titleText
        tableView.parallaxHeader.view = headerView
        tableView.parallaxHeader.height = 200
        tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.delegate = self
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//        navigationController?.pushViewController(ExplanationController(), animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath as IndexPath) as! TopicDetailTableViewCell
        
        if defaults.integer(forKey: "language") == 0{
            cell.selectionStyle = .none
            cell.titleLabel.text = self.getArray?["main_text"] as? String
            cell.takeQuizButton.addTarget(self, action: #selector(showQuiz), for: .touchUpInside)
            cell.takeQuizButton.setTitle("Начать тест", for: .normal)
        } else {
            cell.selectionStyle = .none
            cell.titleLabel.text = self.getArray?["main_text"] as? String
            cell.takeQuizButton.addTarget(self, action: #selector(showQuiz), for: .touchUpInside)
            cell.takeQuizButton.setTitle("Тестілеу", for: .normal)
        }
        
        return cell
       
    }
    
    func showQuiz() {
        let vc = QuizController()
        vc.titleText = self.titleText
        vc.getTest = getArray?["test"] as? [[String:String]]
        navigationController?.pushViewController(vc, animated: true)
    }
}

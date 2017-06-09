//
//  ViewController.swift
//  KLS
//
//  Created by Dias Dosymbaev on 4/13/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import CenteredCollectionView
import ChameleonFramework
import SVProgressHUD

class HomeController: UIViewController {
    
    //MARK: - Parameters
    
    let defaults = UserDefaults.standard
    lazy var getArray = [[Any]]()
    let cellPercentWidth: CGFloat = 0.8
    var scrollToEdgeEnabled = true
    let subjectTitles = ["Математика", "Физика"]
    let subjectImages = [#imageLiteral(resourceName: "image-title-1"), #imageLiteral(resourceName: "image-title-2")]
    
    let centeredCollectionView = CenteredCollectionView().then {
        $0.register(CollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CollectionViewCell.self))
        $0.minimumLineSpacing = 20
        $0.backgroundColor = UIColor.clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "Главная"
        $0.font = .systemFont(ofSize: 17.0, weight: 0.3)
    }
    
    private lazy var settingsButton: UIButton = {
        return UIButton().then {
            $0.setImage(#imageLiteral(resourceName: "icon-settings"), for: .normal)
            $0.backgroundColor = HexColor("F6CA33")
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        }
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        SVProgressHUD.show()
        setupNavBar()
        if defaults.array(forKey: "array\(defaults.integer(forKey: "language"))") != nil{
            self.getArray = defaults.array(forKey: "array\(defaults.integer(forKey: "language"))") as! [[Any]]
            SVProgressHUD.dismiss()
            self.centeredCollectionView.reloadData()
            
        } else {
            urlRequest()
        }
        
//        self.centeredCollectionView.reloadData()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    func setupViews() {
        SVProgressHUD.setForegroundColor(HexColor("DA3C65"))
        SVProgressHUD.setBackgroundColor(.white)

        view.backgroundColor = .white //GradientColor(.topToBottom, frame: view.bounds, colors: [HexColor("234480")!, HexColor("3296DC")!])
        
        centeredCollectionView.delegate = self
        centeredCollectionView.dataSource = self
        centeredCollectionView.itemSize = CGSize(width: view.bounds.width * cellPercentWidth, height: view.bounds.height * 0.7)

        stackView.addArrangedSubview(centeredCollectionView)
        
        settingsButton.layer.cornerRadius = 22
        
        [stackView, settingsButton].forEach {
            view.addSubview($0)
        }
    }

    func setupConstraints() {
        constrain(stackView, view, settingsButton) {
            $0.height == $1.height - view.height/5
            $0.width == $1.width
            $0.center == $1.center
            
            $2.bottom == $1.bottom - 20
            $2.trailing == $1.trailing - 20
            $2.width == 44
            $2.height == 44
        }
    }
    
    func setupNavBar() {
        if defaults.integer(forKey: "language") == 0{
            title = "Главная"
        } else {
            title = "Басты бет"
        }
        //        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        //        navigationController?.navigationBar.barTintColor = HexColor("DA3C65")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    //MARK: - Actions
    
    func showSettings() {
        navigationController?.pushViewController(SettingsTableViewController(), animated: true)
    }
    
    func urlRequest(){
        SVProgressHUD.show()
        var urlString = ""
        if defaults.integer(forKey: "language") == 0{
            urlString = "http://localhost/kls/kls.php"
        } else {
            urlString = "http://localhost/kls/kls_kz.php"
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
//                SVProgressHUD.dismiss()
                print(error ?? "")
            } else {
                do {
                    self.getArray = try JSONSerialization.jsonObject(with: data!, options: []) as! [[Any]]
                    if self.defaults.integer(forKey: "language") == 0{
                        self.defaults.set(self.getArray, forKey: "array\(self.defaults.integer(forKey: "language"))")
                    } else {
                        self.defaults.set(self.getArray, forKey: "array\(self.defaults.integer(forKey: "language"))")
                    }
                    self.centeredCollectionView.reloadData()
                } catch let error as NSError {
//                    SVProgressHUD.dismiss()
                    print(error)
                }
            }}.resume()
    }
}

extension HomeController: ControlCenterViewDelegate {
    func stateChanged(scrollDirection: UICollectionViewScrollDirection) {
        centeredCollectionView.scrollDirection = scrollDirection
    }
    
    func stateChanged(scrollToEdgeEnabled: Bool) {
        self.scrollToEdgeEnabled = scrollToEdgeEnabled
    }
}

extension HomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        
        let destVC = TopicsController()
        destVC.image = cell.titleImageView.image
        destVC.titleText = cell.titleLabel.text
        destVC.getArray = self.getArray[indexPath.row] as! [[String : Any]]
        
        self.navigationController?.pushViewController(destVC, animated: true)
        
        if scrollToEdgeEnabled, let currentCenteredPage = centeredCollectionView.currentCenteredPage, currentCenteredPage != indexPath.row {
            centeredCollectionView.scrollTo(index: indexPath.row, animated: true)
        }
    }
}

extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjectTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath) as! CollectionViewCell
        
        if defaults.integer(forKey: "language") == 0 && getArray.count != 0{
            cell.topicsLabel.text = "тем"
            cell.playButton.setTitle("Начать", for: .normal)
            cell.numberOfTopics.text = "\(getArray[indexPath.row].count)"
            cell.titleLabel.text = subjectTitles[indexPath.row]
            cell.titleImageView.image = subjectImages[indexPath.row]
            
            
            cell.contentView.layer.masksToBounds = true
            
            cell.layer.cornerRadius = 5
            cell.layer.shouldRasterize = false
            cell.layer.shadowColor = HexColor("c2c2c2")?.cgColor
            cell.layer.shadowRadius = 10.0
            cell.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.layer.shadowOpacity = 0.7
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            SVProgressHUD.dismiss()
            return cell
        } else if getArray.count != 0 &&  defaults.integer(forKey: "language") == 1{
            cell.topicsLabel.text = "тақырып"
            cell.playButton.setTitle("Бастау", for: .normal)
            cell.numberOfTopics.text = "\(getArray[indexPath.row].count)"
            cell.titleLabel.text = subjectTitles[indexPath.row]
            cell.titleImageView.image = subjectImages[indexPath.row]
            
            
            cell.contentView.layer.masksToBounds = true
            
            cell.layer.cornerRadius = 5
            cell.layer.shouldRasterize = false
            cell.layer.shadowColor = HexColor("c2c2c2")?.cgColor
            cell.layer.shadowRadius = 10.0
            cell.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.layer.shadowOpacity = 0.7
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            SVProgressHUD.dismiss()
            return cell
        } else {
            cell.titleLabel.text = subjectTitles[indexPath.row]
            cell.titleImageView.image = subjectImages[indexPath.row]
            
            
            cell.contentView.layer.masksToBounds = true
            
            cell.layer.cornerRadius = 5
            cell.layer.shouldRasterize = false
            cell.layer.shadowColor = HexColor("c2c2c2")?.cgColor
            cell.layer.shadowRadius = 10.0
            cell.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.layer.shadowOpacity = 0.7
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            return cell
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Current centered index: \(String(describing: centeredCollectionView.currentCenteredPage ?? nil))")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("Current centered index: \(String(describing: centeredCollectionView.currentCenteredPage ?? nil))")
    }
}

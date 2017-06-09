//
//  SettingsController.swift
//  KLS
//
//  Created by Dias Dosymbaev on 4/13/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//


import UIKit
import Sugar
import MessageUI
import Cartography
import ChameleonFramework
import Localize_Swift

class SettingsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    //MARK: -Properties
    let titles = ["Поделиться", "Оценить", "Написать нам"]
    let kzTitles = ["Бөлісу", "Бағалау", "Бізге жазыныз"]
    let languages = ["Руский", "Қазақша"]
    let icons = [#imageLiteral(resourceName: "icon-share"), #imageLiteral(resourceName: "icon-star"), #imageLiteral(resourceName: "icon-envelope")]
    let langIcons = [#imageLiteral(resourceName: "icon-rus"),#imageLiteral(resourceName: "icon-kaz")]
    let defaults = UserDefaults.standard
    var selectedIndexPath:NSIndexPath?
    let availableLanguages = Localize.availableLanguages()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 70)
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(LanguageTableViewCell.self, forCellReuseIdentifier: "LanguageCell")
        tableView.tableFooterView = UIView()
        //        tableView.backgroundColor = .white
        return tableView
    }()
    
    //MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setUpNavBar()
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear

    }
    
    //MARK: -Setups
    
    func setUpViews() {
        
        view.addSubview(tableView)

        setUpNavBar()
    }
    func setUpNavBar(){
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        if defaults.integer(forKey: "language") == 0{
            title = "Настройки"
        } else {
            title = "Өңдеу"
        }
        
        navigationController?.navigationBar.barTintColor = HexColor("0070D5")
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setUpConstraints() {
        constrain(tableView, view){ tableView, view in
            tableView.edges == view.edges
        }
    }
    //MARK: Actions
    
    func showShareView() {
        let text = "This is some text that I want to share."
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewController
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func setLanguage(language: Int){
        UserDefaults.standard.set(language, forKey: "language")
        UserDefaults.standard.synchronize()
        tableView.reloadData()
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        switch indexPath.section {
        case 0:
            self.selectedIndexPath = indexPath as NSIndexPath?
            switch indexPath.row {
            case 0:
                setLanguage(language: 0)
            case 1:
                setLanguage(language: 1)
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                showShareView()
            case 1:
                return
            case 2:
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            default:
                return
            }
        default:
            print(123)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return languages.count
        case 1:
            return titles.count
        default:
            return 0
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
             let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath as IndexPath) as! LanguageTableViewCell
                cell.titleLabel.text = languages[indexPath.row]
                cell.iconImageView.image = langIcons[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath as IndexPath) as! SettingsTableViewCell
            if defaults.integer(forKey: "language") == 0{
                cell.setUpCellWithProperties(title: titles[indexPath.row], icon: icons[indexPath.row])
            } else {
                cell.setUpCellWithProperties(title: kzTitles[indexPath.row], icon: icons[indexPath.row])
            }
            
            cell.accessoryType = .disclosureIndicator
            cell.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
            cell.layoutMargins = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        switch section {
    //        case SettingsSection.Plan.rawValue: return SectionHeaderView(title: "ПЛАН")
    //        case SettingsSection.Mode.rawValue: return SectionHeaderView(title: "СМЕНА РЕЖИМА")
    //        case SettingsSection.Notificaions.rawValue: return SectionHeaderView(title: "УВЕДОМЛЕНИЯ")
    //        case SettingsSection.Account.rawValue: return SectionHeaderView(title: "АККАУНТ")
    //        default: return SectionHeaderView()
    //        }
    //}
}

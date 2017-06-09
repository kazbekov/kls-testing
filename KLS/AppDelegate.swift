//
//  AppDelegate.swift
//  KLS
//
//  Created by Dias Dosymbaev on 4/13/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import UIKit
import SVProgressHUD
import ChameleonFramework
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        loadMainPages()
        setUpViews()
        
        return true
    }


}

extension AppDelegate {
    func loadMainPages() {
        if window == nil { window = UIWindow(frame: UIScreen.main.bounds) }

        self.window?.rootViewController = UINavigationController(rootViewController: HomeController())
        self.window?.makeKeyAndVisible()
    }
    
    func setUpViews(){
        SVProgressHUD.setForegroundColor(HexColor("DA3C65"))
        SVProgressHUD.setBackgroundColor(.white)
    }
}


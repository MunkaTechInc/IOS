//
//  MainTabbarVC.swift
//  Munka
//
//  Created by Amit on 13/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MainTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = UIColor.hexStringToUIColor(hex: "#7E8290")
        self.tabBar.tintColor = UIColor(red: 20/255.0, green: 76/255.0, blue: 222 / 255.0, alpha: 1)//UIColor.hexStringToUIColor(hex: "#02061A")
        // Do any additional setup after loading the view.
        
        UINavigationBar.appearance().barTintColor =  UIColor(red: 20/255.0, green: 76/255.0, blue: 222 / 255.0, alpha: 1) //UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
}

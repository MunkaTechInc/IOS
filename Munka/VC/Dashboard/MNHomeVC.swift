//
//  MNHomeVC.swift
//  Munka
//
//  Created by Amit on 25/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNHomeVC: UIViewController {
    weak var currentViewController: UIViewController?
     @IBOutlet weak var containerView: UIView!
    
   // @IBOutlet weak var viewTop:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if MyDefaults().swiftUserData["user_type"] as!  String == "Individual" {
            
          self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "MNIndividualHomeVC")
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChild(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
            
          /*  self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "MNProfessinalHomeVc")
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChild(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)*/
        }else{
            
          /*  self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "MNIndividualHomeVC")
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChild(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)*/
            
            self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "MNProfessinalHomeVc")
              self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
              self.addChild(self.currentViewController!)
              self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        }
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
    }
    
    @IBAction func actionOnNotification(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("HomeNotification"), object: nil)
    }
}


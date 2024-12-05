//
//  MNCalenderVC.swift
//  Munka
//
//  Created by Amit on 20/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNCalenderVC: UIViewController {
    weak var currentViewController: UIViewController?
    @IBOutlet weak var containerView: UIView!
      override func viewDidLoad() {
            super.viewDidLoad()
        
    if MyDefaults().swiftUserData["user_type"] as!  String == "Individual" {
        
        self.currentViewController = storyBoard.Individual.instantiateViewController(withIdentifier: "MNIndividualCalenderVC")
                self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.addChild(self.currentViewController!)
                self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
            }else{
                self.currentViewController = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNFreelancerCalenderVC")
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
            let vc = storyBoard.Main.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
                   vc.hidesBottomBarWhenPushed = true
                   self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }



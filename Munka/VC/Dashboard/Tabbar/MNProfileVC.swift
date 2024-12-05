//
//  MNProfileVC.swift
//  Munka
//
//  Created by Amit on 13/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNProfileVC: UIViewController {
    weak var currentViewController: UIViewController?
     @IBOutlet weak var containerView: UIView!
    
   // @IBOutlet weak var viewTop:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // viewTop.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 32)
        // Do any additional setup after loading the view.
//        if #available(iOS 13.0, *) {
//            self.isModalInPresentation = false
//        } else {
//            // Fallback on earlier versions
//        }
       
        if MyDefaults().swiftUserData["user_type"] as!  String == "Individual" {
            self.currentViewController = storyBoard.Individual.instantiateViewController(withIdentifier: "MNIndividualProflleVC")
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChild(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        }else{
            self.currentViewController = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNFreelancerProflleVC")
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
    @IBAction func actionOnNotification(_ sender: Any) {
    
        NotificationCenter.default.post(name: Notification.Name("ProfileNotification"), object: nil)
        }
}


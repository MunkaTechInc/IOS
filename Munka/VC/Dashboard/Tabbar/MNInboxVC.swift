//
//  MNInboxVC.swift
//  Munka
//
//  Created by Amit on 18/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

//class MNInboxVC: UIViewController {
//    weak var currentViewController: UIViewController?
//    @IBOutlet weak var containerView: UIView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    if MyDefaults().swiftUserData["user_type"] as!  String == "Individual" {
//        self.currentViewController = storyBoard.Individual.instantiateViewController(withIdentifier: "MNIndividualInboxVC")
//        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
//        self.addChild(self.currentViewController!)
//        self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
//    }else{
//        self.currentViewController = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNFreelancerInboxVC")
//        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
//        self.addChild(self.currentViewController!)
//        self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
//    }
//
//    }
//    func addSubview(subView:UIView, toView parentView:UIView) {
//        parentView.addSubview(subView)
//        var viewBindingsDict = [String: AnyObject]()
//        viewBindingsDict["subView"] = subView
//        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
//        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
//    }
//    @IBAction func btnArchive(_ sender: Any) {
////        let vc = storyBoard.Main.instantiateViewController(withIdentifier: "ArchiveChatListVC") as! ArchiveChatListVC
////                    self.navigationController?.pushViewController(vc, animated: true)
//    NotificationCenter.default.post(name: Notification.Name("archiveFromIndividualInbox"), object: nil)
//    }
//}

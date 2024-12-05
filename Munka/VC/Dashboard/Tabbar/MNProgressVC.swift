//
//  MNProgressVC.swift
//  Munka
//
//  Created by Amit on 05/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNProgressVC: UIViewController {
    weak var currentViewController: UIViewController?
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   if MyDefaults().swiftUserData["user_type"] as!  String == "Individual" {
       let storyboard = UIStoryboard(name: "Individual", bundle: nil)
    
    self.currentViewController = storyboard.instantiateViewController(withIdentifier: "MNIndividualProgressVC")
       self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
       self.addChild(self.currentViewController!)
       self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
   }else{
        let storyboard = UIStoryboard(name: "Freelauncer", bundle: nil)
    self.currentViewController = storyboard.instantiateViewController(withIdentifier: "MNFreelauncerProgressVC")
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
        @IBAction func btnNotification(_ sender: Any) {
    //        let vc = storyBoard.Main.instantiateViewController(withIdentifier: "ArchiveChatListVC") as! ArchiveChatListVC
    //                    self.navigationController?.pushViewController(vc, animated: true)
        NotificationCenter.default.post(name: Notification.Name("progressNotification"), object: nil)
       
    }
}

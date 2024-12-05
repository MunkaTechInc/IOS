//
//  MNIndividualInboxVC.swift
//  Munka
//
//  Created by Amit on 18/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit


 class MNIndividualInboxVC:UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var tblViewChatList: UITableView!
    @IBOutlet var viewNoInternet: UIView!
    @IBOutlet var viewNoDataFound: UIView!
    @IBOutlet var btnArchiveList: UIButton!
    //MARK:- Properties
    var arrChatList = [[String:Any]]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       NotificationCenter.default.addObserver(
       self,
       selector: #selector(self.batteryLevelChanged),
       name: NSNotification.Name(rawValue: "archiveFromIndividualInbox"),
       object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = false
        self.arrChatList = [[String:Any]]()
        callChatListAPIToGetAllUserList() // Call user List
    }
    @objc private func batteryLevelChanged(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        let vc = storyBoard.Individual.instantiateViewController(withIdentifier: "ArchiveChatListVC") as! ArchiveChatListVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:- Actions
    //Go To Archive List
    @IBAction func btnArchiveList(_ sender: Any) {
        let vc = storyBoard.Individual.instantiateViewController(withIdentifier: "ArchiveChatListVC") as! ArchiveChatListVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  ArchiveChatListVC.swift
//  Munka
//
//  Created by Puneet Sharma on 13/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class ArchiveChatListVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var tblViewArchivedList: UITableView!
    @IBOutlet var viewNoInternet: UIView!
    @IBOutlet var viewNoDataFound: UIView!
    @IBOutlet var btnArchiveList: UIButton!
    
    //MARK:- Properties
    var arrArchivedList = [[String:Any]]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callArchiveAPIToGetAllArchiveUserList() // Call Archived List
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    //MARL:- Action
    
}

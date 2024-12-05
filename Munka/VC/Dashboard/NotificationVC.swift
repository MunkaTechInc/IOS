//
//  NotificationVC.swift
//  Munka
//
//  Created by Amit on 19/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
class NotificationVC: UIViewController {
        @IBOutlet weak var viewNoInternetConnection:UIView!
        @IBOutlet weak var viewNoDateFound:UIView!
        @IBOutlet weak var tblView:UITableView!
        var offersList = [ModelNewNotificationList]()
   var pageNumber: Int = 1
   var isTotalCountReached : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register the Loading Cell XIB for pagination
        tblView.isHidden = true
        self.tblView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
        // Do any additional setup after loading the view.
       
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated) // No need for se
        offersList = [ModelNewNotificationList]()
        if  isConnectedToInternet() {
                self.callServiceNotificationHistoryAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
     @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func callServiceNotificationHistoryAPI() {
      

//        ShowHud()
ShowHud(view: self.view)
       //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "page":"1",
                                      ]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNNotificationAPI , parameter: parameter) { (response) in
             debugPrint(response)
            self.isApiCalled  = false
           // HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelNotificationList.init(fromDictionary: response as! [String : Any])
               // self.offersList = response.notificationList
                  //  self.tblView.isHidden = false
                 //  self.tblView.reloadData()
           
             if response.notificationList.count == 0 {
                          self.isTotalCountReached = true
                     }
                     self.offersList += response.notificationList
                        if self.offersList.count == 0
                             {
                                 self.isTotalCountReached = true
                                 self.viewNoDateFound.isHidden = false
                                 self.tblView.isHidden = true
                             }else{
                                 if self.offersList.count % 10 != 0
                                 {
                                     self.isTotalCountReached = true
                                 }
                                 self.pageNumber = self.pageNumber + 1
                                 self.viewNoDateFound.isHidden = true
                                 self.tblView.isHidden = false
                                 self.tblView.reloadData()
                             }
             }else if status == "4"
             {
                self.autoLogout(title: ALERTMESSAGE, message: message)
                }else{
                             if self.offersList.count == 0
                             {
                                 self.viewNoDateFound.isHidden = false
                                 self.tblView.isHidden = true
                             }
                              self.isTotalCountReached = true
                              self.tblView.reloadData()
                              self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }}else {
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
        }
                
            }
        }
    var isApiCalled: Bool = false

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let endScrolling: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height + 1
        if endScrolling >= scrollView.contentSize.height && !self.isTotalCountReached
        {
            if !self.isApiCalled {
                self.isApiCalled = true
                self.callServiceNotificationHistoryAPI()
            }
        }
    }
    }

         
// MARK: - extension
extension NotificationVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isTotalCountReached {
            return self.offersList.count
        } else {
            return self.offersList.count + 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.offersList.count
        {
            return 44
        }
        else{
            return 112
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : NotificationTableViewCell!
       if indexPath.row == self.offersList.count {
           let cell : UITableViewCell = self.tblView.dequeueReusableCell(withIdentifier: "LoadingCell")!
           let activityIndicator : UIActivityIndicatorView = (cell.contentView.viewWithTag(100) as? UIActivityIndicatorView)!
           activityIndicator.startAnimating()
           return cell
       }else if self.offersList.count > 0
       {
        
        cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as? NotificationTableViewCell
       cell.lblDate.text! = self.offersList[indexPath.row].creationDatetime.convertDateFormaterFoeOnlyDate1(self.offersList[indexPath.row].creationDatetime)
        cell.lblJobStatus.text! = self.offersList[indexPath.row].notificationTitle
        let string = self.offersList[indexPath.row].notificationDescription
        
        let str = string?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        //cell.lblDescriptions.text! = str ?? "NA"
        
        //let myStringArr = str?.components(separatedBy: "<br>")
     //  print(myStringArr)
      let title = str?.components(separatedBy: "Job Title")
       
        cell.lblDescriptions.text! = (title?[0] ?? "NA")
        if title?.count ?? 0 > 1 {
            cell.lblJobtitle.text! = "Job Title " + (title?[1] ?? "NA")
        }
        
      //  print(str)
        }
        return cell
    }
    @objc func clickOnRedeem(sender: UIButton){
     //   self.callServiceRedeempointAPI(tagValue:sender.tag)
    }
    @objc func clickOnTermsConditions(sender: UIButton){
       // self.callServiceTermsConditionsAPI(tagValue:sender.tag)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let details = self.storyboard?.instantiateViewController(withIdentifier: "MNPostDetailVC") as! MNPostDetailVC
//         self.navigationController?.pushViewController(details, animated: true)
    }
    
}

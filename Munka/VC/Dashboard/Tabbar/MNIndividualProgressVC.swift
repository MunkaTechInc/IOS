//
//  MNIndividualProgressVC.swift
//  Munka
//
//  Created by Amit on 05/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNIndividualProgressVC: UIViewController,GetJobStartIndividual {
      
      @IBOutlet weak var viewNoInternet:UIView!
      @IBOutlet weak var viewNoDataFound:UIView!
      @IBOutlet weak var tblView:UITableView!
      var pageNumber: Int = 1
      var isTotalCountReached : Bool = false
      var searchJob : Bool = false
      @IBOutlet weak var searchBar: UISearchBar!
    // var contractlist = [ModelFreelauncerProgressDetail]()
        var jobList = [ModelIndividualProgressDetail]()
       // var filterJoblist = [ModelIndividualProgressDetail]()
    
    //var filterDetails = [ModelDetail]()
         override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblView.isHidden = true
         // Do any additional setup after loading the view.
         
        //Register the Loading Cell XIB for pagination
        self.tblView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.clickOnProgressNotification),
                name: NSNotification.Name(rawValue: "progressNotification"),
                object: nil)
        //    self.searchBar.searchTextField.textColor = .black
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.black
            }
           UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    @objc private func clickOnProgressNotification(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        let vc = storyBoard.Main.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        jobList = [ModelIndividualProgressDetail]()
        if  isConnectedToInternet() {
                 self.pageNumber = 1
                 self.isTotalCountReached = false
            self.callServiceForIndivualProgressAPI(searchString: "")
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    func callServiceForIndivualProgressAPI(searchString:String) {
          
           //ShowHud()
        ShowHud(view: self.view)
           //print(MyDefaults().UserId!)
            let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                          "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                          "user_type":MyDefaults().swiftUserData["user_type"] as! String,
                                          "page":pageNumber,
                                          "list_type":"In_Progess_Completed",
                                          "keyword":searchString
                                          ]
             debugPrint(parameter)
             HTTPService.callForPostApi(url:MNIndividualProgressJobListAPI , parameter: parameter) { (response) in
                 debugPrint(response)
             // HideHud()
                HideHud(view: self.view)
            self.isApiCalled = false
                if response.count != nil{
              let status = response["status"] as! String
              let message = response["msg"] as! String
                 if status == "1"
                 {
                    let response = ModelIndividualProgressJoblist.init(fromDictionary: response as! [String : Any])
                   
                    if response.details.count == 0 {
                         self.isTotalCountReached = true
                    }
                    self.jobList += response.details
                        // self.lblTotalAmount.text = "$ " + response.walletAmount
                        if self.jobList.count == 0
                                 {
                                     self.isTotalCountReached = true
                                     self.viewNoDataFound.isHidden = false
                                     self.tblView.isHidden = true
                                 }else{
                                     if self.jobList.count % 10 != 0
                                     {
                                         self.isTotalCountReached = true
                                     }
                        
                            self.pageNumber = self.pageNumber + 1
                                     self.viewNoDataFound.isHidden = true
                                     self.tblView.isHidden = false
                                     self.tblView.reloadData()
                                 }
                    } else if status == "4"
                    {
                        self.autoLogout(title: ALERTMESSAGE, message: message)
                 }
                 else {
                    if self.jobList.count == 0
                    {
                        self.viewNoDataFound.isHidden = false
                        self.tblView.isHidden = true
                    }
                     self.isTotalCountReached = true
                     self.tblView.reloadData()
                    }}else{
                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
        }
       // searchBar.resignFirstResponder()
}
        // MARK: - UIScrollView Delegate and DataSource
           var isApiCalled: Bool = false
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
           {
               let endScrolling: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height + 1
               if endScrolling >= scrollView.contentSize.height && !self.isTotalCountReached
               {
                   if !self.isApiCalled {
                       self.isApiCalled = true
                    self.callServiceForIndivualProgressAPI(searchString: "")
                   }
               }
           }
    }

// MARK: - extension
extension MNIndividualProgressVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    if self.isTotalCountReached {
        return self.jobList.count
    } else {
        return self.jobList.count + 1
    }
    
    }
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         if indexPath.row == self.jobList.count {
            let cell : UITableViewCell = self.tblView.dequeueReusableCell(withIdentifier: "LoadingCell")!
            let activityIndicator : UIActivityIndicatorView = (cell.contentView.viewWithTag(100) as? UIActivityIndicatorView)!
                      activityIndicator.startAnimating()
            return cell
                }else{
              
            if self.jobList.count > 0{
                var cell : IndividualProgressTableViewCell!
                        cell = tableView.dequeueReusableCell(withIdentifier: "IndividualProgressTableViewCell", for: indexPath) as? IndividualProgressTableViewCell
                        cell?.imgView.sd_setImage(with: URL(string:img_BASE_URL + self.jobList[indexPath.row].freelancerProfilePic), placeholderImage:#imageLiteral(resourceName: "phl_square_profile"))
                    
                         cell?.lblJobTitle.text = self.jobList[indexPath.row].jobTitle
                         cell?.lblName.text = self.jobList[indexPath.row].jobWorkedBy
                        cell?.lblDescriptions.text = self.jobList[indexPath.row].jobDescription

                        
                         cell.btnCancel.tag = indexPath.row
                          cell.btnCancel.addTarget(self, action: #selector(clickOnCancel(sender:)), for: .touchUpInside)
                         cell.btnStart.tag = indexPath.row + 1000
                         cell.btnStart.addTarget(self, action: #selector(clickOnStart(sender:)), for: .touchUpInside)
                         if self.jobList[indexPath.row].status == "New" {
                            
                         } else if self.jobList[indexPath.row].status == "Completed"{
                                 cell.btnCancel.isHidden = true
                                 cell.btnStart.isHidden = true
                                 cell.lblStatus.text! = "Completed"
                                 cell.lblStatus.textColor = UIColor.hexStringToUIColor(hex: "#18A25D")
                         } else if self.jobList[indexPath.row].status == "Canceled"{
                                
                         }
                         else if self.jobList[indexPath.row].status == "In Process"{
                                 cell.btnCancel.isHidden = true
                                 cell.btnStart.isHidden = true
                                 cell.lblStatus.text! = self.jobList[indexPath.row].status
                                 cell.lblStatus.textColor = UIColor.hexStringToUIColor(hex: "#13C1B3")
                         }
                         else if self.jobList[indexPath.row].status == "Pending"{
                                 cell.btnCancel.isHidden = false
                                 cell.btnStart.isHidden = false
                             cell.lblStatus.text! = "Not Started"
                            cell.lblStatus.textColor = UIColor.hexStringToUIColor(hex: "#E5983E")
                         }
                   return cell
                }
            }
            return UITableViewCell()
    }
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = storyBoard.Individual.instantiateViewController(withIdentifier: "MNProgressDetailindividualVC") as! MNProgressDetailindividualVC
            details.JobId = self.jobList[indexPath.row].id
            details.ContractId = self.jobList[indexPath.row].contractId
            print(self.jobList[indexPath.row].contractId!)
       
       
        self.navigationController?.pushViewController(details, animated: true)
     }
    
   @objc func clickOnCancel(sender : UIButton){
    self.alertcancelJob(tag: sender.tag, message:"Are you sure want to cancel this job?", jobStatus: "Before_Start_Cancel", wantToPay: "")
        }
    @objc func clickOnStart(sender : UIButton){
        self.alertcancelJob(tag: sender.tag - 1000, message: "Are you sure want to Start this job?", jobStatus: "Start", wantToPay: "")
    }
    func alertcancelJob(tag: Int, message:String,jobStatus:String,wantToPay:String){
        let alertController = UIAlertController(title: ALERTMESSAGE, message: message, preferredStyle: .alert)

           // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
               UIAlertAction in
               NSLog("OK Pressed")
            self.jobCancelled(tagValue: tag, jobStatus: jobStatus, wantToPay: wantToPay)
           }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
               UIAlertAction in
               NSLog("Cancel Pressed")
           }

           // Add the actions
           alertController.addAction(okAction)
           alertController.addAction(cancelAction)

           // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    func jobCancelled(tagValue:Int,jobStatus:String,wantToPay:String) {
        if  isConnectedToInternet() {
            self.callServiceforStartAndCanceljob(tag: tagValue, jobStatus: jobStatus, wantToPay: wantToPay)
              } else {
                  self.showErrorPopup(message: internetConnetionError, title: alert)
          }
    }
    func callServiceforStartAndCanceljob(tag:Int,jobStatus:String,wantToPay:String) {
      

//        ShowHud()
ShowHud(view: self.view)
       //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken!,
                                      "job_id":self.jobList[tag].id ?? "",
                                      "message":"1",
                                      ]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNSendJobOTPAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let popup : MNIndividualJobStartOTPVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNIndividualJobStartOTPVC") as! MNIndividualJobStartOTPVC
                    popup.delagate = self
                    popup.JobId = self.jobList[tag].id!
                    popup.contractId = self.jobList[tag].contractId!
                    popup.reasaonJob = jobStatus
                    popup.wantToPay = wantToPay
                self.presentOnRoot(with: popup)
             } else if status == "4"
             {
                self.autoLogout(title: ALERTMESSAGE, message: message)
             }
             else
             {
                 self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }}else
            {
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
            
         }
    }
    func delegateIndividualJobStart(strOTP:String,jobId:String,wntToPay:String,lateComingStatus:String, jobStatus:String) {

      //  ShowHud()
ShowHud(view: self.view)
        //print(MyDefaults().UserId!)
         
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                       "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                       "contract_id":jobId,
                                       "job_status":jobStatus,
                                       "job_otp":strOTP,
                                       "want_to_pay":wntToPay,
                                       "late_coming_status":lateComingStatus
                                       ]
          debugPrint(parameter)
          HTTPService.callForPostApi(url:MNStartEndJobAPI , parameter: parameter) { (response) in
              debugPrint(response)

        //   HideHud()
HideHud(view: self.view)
           
            if response.count != nil {
            let status = response["status"] as! String
              let message = response["msg"] as! String
              if status == "1"
              {
                 
                self.jobList = [ModelIndividualProgressDetail]()
                self.pageNumber = 1
                 self.isTotalCountReached = false
                 self.callServiceForIndivualProgressAPI(searchString:"")
                 self.showErrorPopup(message: message, title: ALERTMESSAGE)
              } else if status == "4"
              {
                self.autoLogout(title: ALERTMESSAGE, message: message)
              }
              else
              {
                  self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }}else
            {
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
             
          }
         self.dismiss(animated: true, completion: nil)
    }
}
extension MNIndividualProgressVC: UISearchBarDelegate{
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    jobList = [ModelIndividualProgressDetail]()
    searchJob = true
    
    self.pageNumber = 1
    self.isTotalCountReached = false
   // self.callServiceForIndivualProgressAPI(searchString: searchBar.text!)
    //searchBar.resignFirstResponder()
}
func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
   // tblView.reloadData()
}
func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    // called when cancel button pressed
    searchBar.text = ""
    searchBar.resignFirstResponder()
    searchBar.showsCancelButton = false
    searchJob = false
    self.tblView?.isHidden = false
    self.pageNumber = 1
    self.isTotalCountReached = false
    self.callServiceForIndivualProgressAPI(searchString:"")
    self.view.endEditing(true)
   // self.tblView?.reloadData()
}
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
   jobList = [ModelIndividualProgressDetail]()
    searchJob = true
    searchBar.resignFirstResponder()
    self.pageNumber = 1
    self.isTotalCountReached = false
    self.callServiceForIndivualProgressAPI(searchString: searchBar.text!)
}
    
}

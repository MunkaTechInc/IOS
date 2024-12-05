//
//  MNFreelauncerProgressVC.swift
//  Munka
//
//  Created by Amit on 05/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNFreelauncerProgressVC: UIViewController,GetcancelJobFreelancer {
    @IBOutlet weak var viewNoInternet:UIView!
    @IBOutlet weak var viewNoDataFound:UIView!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pageNumber: Int = 1
    var isTotalCountReached : Bool = false
    var searchJob : Bool = false
   // var userType = ""
     var contractlist = [ModelFreelauncerProgressDetail]()
   // var filterContractlist = [ModelFreelauncerProgressDetail]()
    // var contractlistPager = [ModelFreelauncerProgressDetail]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.isHidden = true
        // Do any additional setup after loading the view.
        
       //Register the Loading Cell XIB for pagination
       self.tblView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
       print(MyDefaults().swiftUserData["user_type"] as! String)
      NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.clickOnProgressNotification),
      name: NSNotification.Name(rawValue: "progressNotification"),
      object: nil)
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
        contractlist = [ModelFreelauncerProgressDetail]()
        if  isConnectedToInternet() {
                 self.pageNumber = 1
                 self.isTotalCountReached = false
            self.callServiceForProgressAPI(searchString: "")
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    
    func callServiceForProgressAPI(searchString:String) {
      
       // ShowHud()
ShowHud(view: self.view)
       //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken!,
                                      "user_type":MyDefaults().swiftUserData["user_type"] as! String,
                                      "page":pageNumber,
                                      "keyword":searchString,
                                      "list_type":"In_Progess_Completed"
                                      ]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNContractlistAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
        HideHud(view: self.view)
        self.isApiCalled = false
            if response.count != nil{
          let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelFreelauncerProgress.init(fromDictionary: response as! [String : Any])
                if response.details.count == 0 {
                     self.isTotalCountReached = true
                }
                        self.contractlist += response.details
                        if self.contractlist.count == 0
                        {
                            self.isTotalCountReached = true
                            self.viewNoDataFound.isHidden = false
                            self.tblView.isHidden = true
                        }else{
                            if self.contractlist.count % 10 != 0
                            {
                                self.isTotalCountReached = true
                            }
                            self.pageNumber = self.pageNumber + 1
                            self.viewNoDataFound.isHidden = true
                            self.tblView.isHidden = false
                            self.tblView.reloadData()
                        }
                
        }  else  if status == "4"{
                self.autoLogout(title: ALERTMESSAGE, message: message)
             }
                else {
                if self.contractlist.count == 0
                {
                    self.viewNoDataFound.isHidden = false
                    self.tblView.isHidden = true
                }
                 self.isTotalCountReached = true
                 self.tblView.reloadData()
                //self.showErrorPopup(message: message, title: alert)
                } }else{
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
         }
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
                self.callServiceForProgressAPI(searchString: "")
               }
           }
       }
}
// MARK: - extension
extension MNFreelauncerProgressVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isTotalCountReached {
            return self.contractlist.count
        } else {
            return self.contractlist.count + 1
        }
        
        
    }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row == self.contractlist.count
            {
                return 44
            }
            else{
                return 148
                        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        if indexPath.row == self.contractlist.count {
            let cell : UITableViewCell = self.tblView.dequeueReusableCell(withIdentifier: "LoadingCell")!
            let activityIndicator : UIActivityIndicatorView = (cell.contentView.viewWithTag(100) as? UIActivityIndicatorView)!
            activityIndicator.startAnimating()
            return cell
        }else{
            var cell : FreelauncerProgressTVC!
            cell = tableView.dequeueReusableCell(withIdentifier: "FreelauncerProgressTVC", for: indexPath) as? FreelauncerProgressTVC
            cell?.img.sd_setImage(with: URL(string:img_BASE_URL + self.contractlist[indexPath.row].profilePic), placeholderImage:#imageLiteral(resourceName: "phl_square_profile"))
            
            cell?.lblJobTitle.text = self.contractlist[indexPath.row].jobTitle
            cell?.lblTitle.text = self.contractlist[indexPath.row].jobPostedBy
           // let startDate = self.convertDateFormater(self.contractlist[indexPath.row].jobStartDate)
            let startDate =  Global.convertDateFormat(self.contractlist[indexPath.row].jobStartDate, sourceFormate: "yyyy-MM-dd", targetFormate: "MMM dd, yyyy")
            
            let startTime = self.convertTimeFormater(self.contractlist[indexPath.row].jobStartTime)
            cell?.lblStartDate.text = startDate + " " + startTime
            
           // let startDate = self.convertDateFormater(self.contractlist[indexPath.row].jobEndDate)
            let endDate =  Global.convertDateFormat(self.contractlist[indexPath.row].jobEndDate, sourceFormate: "yyyy-MM-dd", targetFormate: "MMM dd, yyyy")
            let endTime = self.convertTimeFormater(self.contractlist[indexPath.row].jobEndTime)
            cell?.lblEndDate.text = endDate + " " + endTime
            let member = self.convertDateFormaterForAll(self.contractlist[indexPath.row].created)
            let menberDate = member[0]
            let menberTime = member[1]
            
            cell?.lblPostedDate.text = "Member since "  + menberDate + " " + menberTime
            
            if  self.contractlist[indexPath.row].jobType == "Fixed" {
                cell?.lblHour.text = self.contractlist[indexPath.row].timeDuration + " " + "Days"
            }else{
                cell?.lblHour.text = self.contractlist[indexPath.row].timeDuration + " " + "hr"
            }
            cell.btnCancel.tag = indexPath.row
            cell.btnCancel.addTarget(self, action: #selector(clickOnCancel(sender:)), for: .touchUpInside)
           
                cell.btnCancel.isHidden = true
             if self.contractlist[indexPath.row].status == "Pending" {
                cell.btnCancel.isHidden = true
                cell.lblstatus.text = "Pending"
                cell.lblstatus.textColor = UIColor.hexStringToUIColor(hex: "#E5983E")
            }else if self.contractlist[indexPath.row].status == "Canceled"{
                cell.btnCancel.isHidden = true
                cell.lblstatus.text = "Canceled"
                cell.lblstatus.textColor = UIColor.hexStringToUIColor(hex: "#E53E3E")
            }else if self.contractlist[indexPath.row].status == "Accepted"{
                cell.btnCancel.isHidden = true
                cell.lblstatus.text = "Not Started"
                cell.lblstatus.textColor = UIColor.hexStringToUIColor(hex: "#E5983E")
            }else if self.contractlist[indexPath.row].status == "Rejected"{
                cell.btnCancel.isHidden = true
                cell.lblstatus.text = "Rejected"
                cell.lblstatus.textColor = UIColor.hexStringToUIColor(hex: "#E53E3E")
            }
            if self.contractlist[indexPath.row].jobStatus == "In_Process" {
            cell.btnCancel.isHidden = false
            cell.lblstatus.text = "Started"
            cell.lblstatus.textColor = UIColor.hexStringToUIColor(hex: "#18A25D")
            }
           else if self.contractlist[indexPath.row].jobStatus == "Completed" {
            cell.btnCancel.isHidden = true
            cell.lblstatus.text = "Completed"
            cell.lblstatus.textColor = UIColor.hexStringToUIColor(hex: "#18A25D")
            }
          else  if self.contractlist[indexPath.row].jobStatus == "Canceled" {
            cell.btnCancel.isHidden = true
            cell.lblstatus.text = "Canceled"
            cell.lblstatus.textColor = UIColor.hexStringToUIColor(hex: "#E53E3E")
            }
            if self.contractlist[indexPath.row].workedby == "0" || self.contractlist[indexPath.row].workedby == "" {
                cell.btnCancel.isHidden = true
                
            }else{
                //cell.btnCancel.isHidden = false
//                if self.contractlist[indexPath.row].jobStatus == "Completed" {
//                cell.btnCancel.isHidden = true
//                cell.lblstatus.text = "Completed"
//                cell.lblstatus.textColor = UIColor.hexStringToUIColor(hex: "#18A25D")
//                }else{
//                    cell.btnCancel.isHidden = false
//                }
            }

                return cell
            }}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = self.storyboard?.instantiateViewController(withIdentifier: "MNFreelauncerProgressdetailVC") as! MNFreelauncerProgressdetailVC
        details.JobId = self.contractlist[indexPath.row].jobId
        details.ContractId = self.contractlist[indexPath.row].id
       self.navigationController?.pushViewController(details, animated: true)
     
  }
    
    @objc func clickOnCancel(sender : UIButton){
            self.alertcancelJob(tag: sender.tag)
        }
    func alertcancelJob(tag: Int){
        let alertController = UIAlertController(title: ALERTMESSAGE, message: "are you sure want to cancel this job.", preferredStyle: .alert)

           // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
               UIAlertAction in
               NSLog("OK Pressed")
            self.jobCancelled(tagValue: tag)
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
    func jobCancelled(tagValue:Int) {
            if self.contractlist[tagValue].status == "Accepted" {
       if self.contractlist[tagValue].jobStatus == "Pending" {
          if  isConnectedToInternet() {
            self.callServiceforCancelotpjob(tag: tagValue, strin: "Before_Start_Cancel", wantToPay: "")
            } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
       } else if self.contractlist[tagValue].jobStatus == "In_Process"{
          if  isConnectedToInternet() {
            self.callServiceforCancelotpjob(tag: tagValue, strin: "After_Start_Cancel", wantToPay: "Yes")
            } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
      }
    }
  }
//    func dele {
//       // self.callServiceforCanceljob(tag: tagValue)
//    }
    func delegateCancelJob(strOTP:String,ContractId:String,reasaonJob:String,wntToPay:String) {
       // let otp = txt1Str + txt2Str + txt3Str + txt4Str
        self.callServiceCancel(contarctId: ContractId, strOtp: strOTP, jobStatus: reasaonJob, wantToPay: wntToPay)
    }
    func callServiceforCancelotpjob(tag:Int,strin:String,wantToPay:String) {
          

           // ShowHud()
ShowHud(view: self.view)
           //print(MyDefaults().UserId!)
            let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                          "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                          "job_id":self.contractlist[tag].jobId ?? "",
                                          "message":"1",
                                          ]
             debugPrint(parameter)
             HTTPService.callForPostApi(url:MNSendJobOTPAPI , parameter: parameter) { (response) in
                 debugPrint(response)

            //  HideHud()
                HideHud(view: self.view)
                if response.count != nil {
                let status = response["status"] as! String
                 let message = response["msg"] as! String
                 if status == "1"
                 {
                    let popup : FreelancercanceJobPopUp = storyBoard.PopUp.instantiateViewController(withIdentifier: "FreelancercanceJobPopUp") as! FreelancercanceJobPopUp
                        popup.delagate = self
                        popup.ContractId = self.contractlist[tag].id!
                        popup.reasaonJob = strin
                        popup.wantToPay = wantToPay
                        popup.jobId = self.contractlist[tag].jobId
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
    func callServiceCancel(contarctId:String,strOtp:String,jobStatus:String,wantToPay:String) {

      //  ShowHud()
ShowHud(view: self.view)
       //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "contract_id":contarctId,
                                      "job_status":jobStatus,
                                      "job_otp":strOtp,
                                      "want_to_pay":wantToPay
                                      ]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNStartEndJobAPI , parameter: parameter) { (response) in
             debugPrint(response)

        //  HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                
                self.pageNumber = 1
                 self.isTotalCountReached = false
                 self.contractlist = [ModelFreelauncerProgressDetail]()
                self.callServiceForProgressAPI(searchString: "")
               
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
    
    
    func convertDateFormater(_ strdate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
    func convertDateFormaterForAll(_ strdate: String) -> [String]
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let strDate = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "hh:mm a"
        let strTime = dateFormatter.string(from: date!)
        return [strDate,strTime]
    }
    func convertTimeFormater(_ dateAsString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "hh:mm a"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
    }
}
extension MNFreelauncerProgressVC: UIScrollViewDelegate {

func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
               if scrollView == self.tblView{

                    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
                    {
                        if !isTotalCountReached{
                            if  isConnectedToInternet() {
                            self.callServiceForProgressAPI(searchString: "")
                            } else {
                                self.showErrorPopup(message: internetConnetionError, title: alert)
                        }
                        
                        }
                    }
    }
   }
  }
extension MNFreelauncerProgressVC: UISearchBarDelegate{
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    contractlist = [ModelFreelauncerProgressDetail]()
    searchJob = true
   /// searchBar.resignFirstResponder()
    self.pageNumber = 1
    self.isTotalCountReached = true
   // self.callServiceForProgressAPI(searchString: searchBar.text!)
  //  self.tblView?.reloadData()
}
func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
    tblView.reloadData()
}
func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    // called when cancel button pressed
    searchBar.text = ""
    searchBar.resignFirstResponder()
    searchBar.showsCancelButton = false
    contractlist = [ModelFreelauncerProgressDetail]()
    self.tblView?.isHidden = false
    self.pageNumber = 1
    self.isTotalCountReached = false
    self.callServiceForProgressAPI(searchString: "")
    self.view.endEditing(true)
    self.tblView?.reloadData()
}
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    contractlist = [ModelFreelauncerProgressDetail]()
    searchJob = true
    searchBar.resignFirstResponder()
    self.pageNumber = 1
    self.isTotalCountReached = true
    self.callServiceForProgressAPI(searchString: searchBar.text!)
    self.tblView?.reloadData()
}
}

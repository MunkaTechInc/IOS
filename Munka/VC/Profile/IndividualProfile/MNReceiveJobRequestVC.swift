//
//  MNReceiveJobRequestVC.swift
//  Munka
//
//  Created by Amit on 02/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNReceiveJobRequestVC: UIViewController,GetUserAction,GetUserDeny,GetUserHier,GetUseContractInfo {
   
    
    
    @IBOutlet weak var viewNoInternet:UIView!
     @IBOutlet weak var viewNoDataFound:UIView!
     @IBOutlet weak var tblView:UITableView!
    var requestList = [ModelRequestList]()
    var jobId = ""
    var applyId = ""
    
    
   // var appliedBy = [ModelAppliedBy]()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        viewNoInternet.isHidden = true
        viewNoDataFound.isHidden = true
        tblView.isHidden = true
        if  isConnectedToInternet() {
            self.callServiceForJobReceivedRequestAPI()
            } else {
               viewNoInternet.isHidden = false
               self.view.bringSubviewToFront(viewNoInternet)
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    func callServiceForJobReceivedRequestAPI() {

//        ShowHud()
        ShowHud(view: self.view)

        print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "page":"1",
                                      "limit":""]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNJobRequestListAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
HideHud(view: self.view)
          
            if response.count != nil{
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelReceivedJobRequest.init(fromDictionary: response as! [String : Any])
                self.requestList = response.requestList
                self.tblView.isHidden = false
                 self.dismiss(animated: true, completion: nil)
                self.tblView.reloadData()
            }else if status == "4"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)
             }
             else
             {
                self.viewNoDataFound.isHidden = false
                self.view.bringSubviewToFront(self.viewNoDataFound)
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }
                
            }
            else{
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
            
         }
    }
    func delegateForRefreshAPI(){
        if  isConnectedToInternet() {
            self.callServiceForJobReceivedRequestAPI()
            } else {
               viewNoInternet.isHidden = false
               self.view.bringSubviewToFront(viewNoInternet)
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
   @IBAction func actionOnBack(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
   }
    
}
// MARK: - extension
extension MNReceiveJobRequestVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ReceivedJobRequestTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedJobRequestTableViewCell", for: indexPath) as? ReceivedJobRequestTableViewCell
         cell?.delagate = self
         cell?.lblName.text = self.requestList[indexPath.row].jobTitle
       
        if  self.requestList[indexPath.row].jobType == "Fixed" {
            cell?.lblJobType.text = "Fixed - " + "$" + self.requestList[indexPath.row].budgetAmount  
            cell?.lblHours.text = self.requestList[indexPath.row].timeDuration + " " + "Days"
        }else{
            cell?.lblJobType.text = "Hourly - " + "$" + self.requestList[indexPath.row].budgetAmount  + "/hr."
            cell?.lblHours.text = self.requestList[indexPath.row].timeDuration + " " + "hr."
        }
        cell?.lblPostedDate.text = "Posted " + self.convertDateFormater(self.requestList[indexPath.row].created)
        let apply = self.requestList[indexPath.row].appliedBy![0]
        cell?.reloadDataCollectionView(applyJob:[apply])
        cell?.intTblIndexNumber = indexPath.row
        cell?.intDenyNumber = indexPath.row + 1000
        cell?.intGetProfile = indexPath.row + 10000
        cell?.btnJobDetails.tag = indexPath.row
        cell?.btnJobDetails.addTarget(self, action: #selector(clickOnTitle(sender:)), for: .touchUpInside)
        return cell!
    }
    @objc func clickOnDelete(sender : UIButton){
        print(sender.tag)
       // self.alertforDeleteCategory(tagValue: sender.tag)
    }
    @objc func clickOnTitle(sender : UIButton){
        print(sender.tag)
        let details = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNPostDetailFreelauncerVC") as! MNPostDetailFreelauncerVC
        details.strJobId = self.requestList[sender.tag].jobId
        self.navigationController?.pushViewController(details, animated: true)
    }
    func delegateForOnProfile(tag:Int){
       let viewProfile = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNFreelancerViewProfileVC") as! MNFreelancerViewProfileVC
        viewProfile.isFreelauncer = true
        viewProfile.userIdFreelauncer = self.requestList[tag].appliedBy[0].appliedBy
        Constant.isFreelancer = "individual"
        self.navigationController?.pushViewController(viewProfile, animated: true)
    }
    func delegateForActionOnReceiveJob(tag: Int, isHire: Bool){
        if isHire == true {
            if self.requestList[tag].appliedBy[0].status! == "Pending" {
                
                jobId = self.requestList[tag].appliedBy[0].jobId
                applyId = self.requestList[tag].appliedBy[0].appliedBy
                 self.alertViewForHierUser(tag: tag)
           
            } else if self.requestList[tag].appliedBy[0].status! == "Rejected" {
            
            } else if self.requestList[tag].appliedBy[0].status! == "Accepted" {
                jobId = self.requestList[tag].appliedBy[0].jobId
                applyId = self.requestList[tag].appliedBy[0].appliedBy
                self.acceptview(int: tag)
        }
            }else{
            let popup : DenyPopUpVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "DenyPopUpVC") as! DenyPopUpVC
                popup.delagate = self
                popup.applyedBy = self.requestList[tag].appliedBy[0].appliedBy
                popup.jobId = self.requestList[tag].appliedBy[0].jobId
                self.presentOnRoot(with: popup)
                }
       }
    func delegateForContarctInfo() {
        let myJob = self.storyboard?.instantiateViewController(withIdentifier: "MNContractInfoVC") as! MNContractInfoVC
            myJob.jobId = jobId
            myJob.applyid = applyId
        self.navigationController?.pushViewController(myJob, animated: true)
    }
    func delegateForMovetochat(intTag: Int){
//        let myJob = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNIndividualInboxVC") as! MNIndividualInboxVC
////            myJob.jobId = jobId
////            myJob.applyid = applyId
//        myJob.hidesBottomBarWhenPushed = true
//        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.pushViewController(myJob, animated: true)
   
    
    
    let dictUser = self.requestList[intTag]
     print(dictUser)
     let vc = storyBoard.Individual.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
    // let strImageUrl = dictUser["profile_pic"] as? String ?? ""
        vc.sender_id = MyDefaults().UserId
        vc.receiver_Id = self.requestList[intTag].appliedBy[0].appliedBy
     //vc.receiver_Id = self.requestList[intTag]
        vc.job_Id = self.requestList[intTag].jobId
//     if let aud = self.requestList[intTag] {
//     vc.room_id = String(aud)
//     }

     vc.strTitle = self.requestList[intTag].jobTitle
     vc.strImgeUrl =  img_BASE_URL + self.requestList[intTag].appliedBy[0].profilePic
   
        
        print(vc.sender_id)
        print(vc.receiver_Id)
        print(vc.job_Id)
        print(MyDefaults().UserId)
        
        vc.hidesBottomBarWhenPushed = true
     self.navigationController?.pushViewController(vc, animated: true)
    
    }
    func delegateForUserDeny() {
        self.navigationController?.popViewController(animated: true)
    }
    func acceptview(int:Int)  {
        let popup : AcceptedpopUpVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "AcceptedpopUpVC") as! AcceptedpopUpVC
        popup.delagate = self
        popup.indexValue = int
        self.presentOnRoot(with: popup)
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let details = self.storyboard?.instantiateViewController(withIdentifier: "MNPostDetailVC") as! MNPostDetailVC
//         self.navigationController?.pushViewController(details, animated: true)
    }
    func alertViewForHierUser(tag: Int){
        let alertController = UIAlertController(title: ALERTMESSAGE, message: "Do you want to hier .", preferredStyle: .alert)

           // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
               UIAlertAction in
               NSLog("OK Pressed")
            self.hierJob(tag: tag)
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
    func hierJob(tag: Int)  {

        self.callServiceForHierAPI(tag: tag)
    }
    func callServiceForHierAPI(tag: Int) {
             

             //  ShowHud()
ShowHud(view: self.view)
              print(MyDefaults().UserId ?? "")
               let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                             "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                             "applied_by":self.requestList[tag].appliedBy[0].appliedBy ?? "",
                                             "job_id":self.requestList[tag].appliedBy[0].jobId ?? "",
                                             "states":"Accepted"]
                debugPrint(parameter)
                HTTPService.callForPostApi(url:MNJobRequestActionAPI , parameter: parameter) { (response) in

               //  HideHud()
HideHud(view: self.view)
                    if response.count != nil{
                    let status = response["status"] as! String
                    let message = response["msg"] as! String
                    if status == "1"
                    {
                        let popup : HierPopUpVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "HierPopUpVC") as! HierPopUpVC
                        popup.delagate = self
                        self.presentOnRoot(with: popup)
                    } else if status == "1"
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
    func delegateForUserHier(){
        let myJob = self.storyboard?.instantiateViewController(withIdentifier: "MNContractInfoVC") as! MNContractInfoVC
            myJob.jobId = jobId
            myJob.applyid = applyId
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.pushViewController(myJob, animated: true)
    
    }
    func convertDateFormater(_ strdate: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
}

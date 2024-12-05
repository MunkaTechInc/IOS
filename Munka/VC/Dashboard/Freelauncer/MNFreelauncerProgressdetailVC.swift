//
//  MNFreelauncerProgressdetailVC.swift
//  Munka
//
//  Created by Amit on 09/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNFreelauncerProgressdetailVC: UIViewController {
    @IBOutlet weak var lblPostedDate: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
  //  @IBOutlet weak var lblJobCategory: UILabel!
   // @IBOutlet weak var lblAssignTo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCreatedDate: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewLeaveAreview: UIView!
    @IBOutlet weak var viewLeaveAreviewHeight: NSLayoutConstraint!
   // @IBOutlet weak var viewJobDetailHeight: NSLayoutConstraint!
   // @IBOutlet weak var viewJobDetail: UIView!
    @IBOutlet weak var btnPaymentInfo: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    var isExpandView : Bool = false
    var isCheckDataContent : Bool = false
    var jobDetails : ModelJobDetail!
    var JobId = ""
    var ContractId = ""
   
    var hourlyJobTime = [ModelHourlyJobTime]()
    var isHourlyAvailableDate : Bool = false
    var arrayForSection =  [[String:Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //  viewBottom.roundCorners([.topLeft, .bottomRight], radius: 10)
        // Do any additional setup after loading the view.
  
       // self.viewBottom.roundCornersBottomSide(corners: ([.topLeft, .topRight]), radius: 10)
        tblView.isHidden = true
        if  isConnectedToInternet() {
           self.callServiceForJobDetailsAPI()
       } else {
           self.showErrorPopup(message: internetConnetionError, title: alert)
   }
}
    func callServiceForJobDetailsAPI() {
      

       // ShowHud()
ShowHud(view: self.view)
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "job_id":JobId]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNPJobDetailsAPI , parameter: parameter) { (response) in
             debugPrint(response)

        //  HideHud()
            HideHud(view: self.view)

            if response.count != nil{
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelJobDetails.init(fromDictionary: response as! [String : Any])
                    self.jobDetails = response.details
                if response.details.hourlyJobTime.count > 0 {
                    self.isHourlyAvailableDate = false
                    self.hourlyJobTime = response.details.hourlyJobTime
                    var dictionary =  [String:Any]()
                    dictionary["status"] = "data"
                    self.arrayForSection.append(dictionary)
                    
                    var dictionary1 =  [String:Any]()
                    dictionary1["viewdetails"] = "data"
                    self.arrayForSection.append(dictionary1)
                    self.isCheckDataContent = true
                    var dictionary2 =  [String:Any]()
                    dictionary2["viewdetails"] = "data"
                    self.arrayForSection.append(dictionary2)
                } else{
                     var dictionary =  [String:Any]()
                     dictionary["status"] = "data"
                    self.isCheckDataContent = false
                     self.arrayForSection.append(dictionary)
                    }
                self.tblView.isHidden = false
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
                self.setupUI()
                   
             } else if status == "4"{
                self.autoLogout(title: message, message: ALERTMESSAGE)
             }
             else
             {
                 self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}else{
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
            
         }
    }
    func setupUI() {
        let postedDate = self.convertDateFormaterFoeOnlyDate(self.jobDetails.created)
        lblPostedDate.text! =   "Posted On" + " " + postedDate
        lblJobTitle.text! =   self.jobDetails.jobTitle
       // lblJobCategory.text! =   self.jobDetails.serviceCategory
        lblName.text! =   self.jobDetails.jobPostedBy
        let joinDate   = self.convertDateFormaterForAll(self.jobDetails.joiningDate)    
        
        lblCreatedDate.text! =  "Since Member "  + joinDate[0]
//
        self.imgProfile.sd_setImage(with: URL(string:img_BASE_URL + self.jobDetails.profilePic!), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))

        if self.jobDetails.status == "Completed" {
            if self.jobDetails.isReview == "0" {
                viewLeaveAreviewHeight.constant = 72
                viewLeaveAreview.isHidden = false
                self.btnPaymentInfo.isEnabled = true
                self.btnPaymentInfo.setTitleColor(.white, for: .normal)
            }else{
                viewLeaveAreviewHeight.constant = 0
                viewLeaveAreview.isHidden = true
                }
        }else{
            viewLeaveAreviewHeight.constant = 0
            viewLeaveAreview.isHidden = true
            self.btnPaymentInfo.isEnabled = false
            self.btnPaymentInfo.setTitleColor(UIColor.hexStringToUIColor(hex: "#B1B1B1"), for: .normal)
        }
        
       
        
//        if self.jobDetails.status  == "New"{
//            self.btnPaymentInfo.isEnabled = false
//            self.btnPaymentInfo.setTitleColor(UIColor.hexStringToUIColor(hex: "#B1B1B1"), for: .normal)
//        }else{
//            self.btnPaymentInfo.isEnabled = true
//            self.btnPaymentInfo.setTitleColor(.white, for: .normal)
//        }
        self.viewBottom.roundCornersBottomSide(corners: [.topLeft,.topRight], radius: 8)
        btnChat.roundedButtonOnlyRight()
        btnPaymentInfo.roundedButtonOnlyLeft()
    }
    @IBAction func actionOnBack(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
       }
    @IBAction func actionOnDropdown(_ sender: UIButton) {

      
        if !isExpandView {
//            view.layoutIfNeeded() // force any pending operations to finish
//            UIView.animate(withDuration: 0.3, animations: { () -> Void in
//               // self.viewJobDetailHeight.constant = 0
//                self.viewLeaveAreviewHeight.constant = 0
//                self.viewLeaveAreview.isHidden = true
//                self.view.layoutIfNeeded()
//                UIView.animate(withDuration: 0.25, animations: {
//                    //self.btnDropDown.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//
//                })
//               self.isExpandView = true
//            })
            self.isExpandView = true
            
            self.arrayForSection.removeAll()
            tblView.reloadData()
        }else{
//            view.layoutIfNeeded() // force any pending operations to finish
//                UIView.animate(withDuration: 0.3, animations: { () -> Void in
//               // self.viewJobDetailHeight.constant = 161
//                self.viewLeaveAreviewHeight.constant = 72
//                self.viewLeaveAreview.isHidden = false
//                self.view.layoutIfNeeded()
//                UIView.animate(withDuration: 0.25, animations: {
//                   // self.btnDropDown.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
//                })
//
//                self.isExpandView = false
//            })
            if isCheckDataContent == true {
                var dictionary =  [String:Any]()
                dictionary["status"] = "data"
                self.arrayForSection.append(dictionary)
                
                var dictionary1 =  [String:Any]()
                dictionary1["viewdetails"] = "data"
                self.arrayForSection.append(dictionary1)
                self.isCheckDataContent = true
                var dictionary2 =  [String:Any]()
                dictionary2["viewdetails"] = "data"
                self.arrayForSection.append(dictionary2)
            }else{
                var dictionary =  [String:Any]()
                 dictionary["status"] = "data"
                self.isCheckDataContent = false
                 self.arrayForSection.append(dictionary)
            }
            tblView.reloadData()
            self.isExpandView = false
        }
    
    }
    @IBAction func actionOnViewProfile(_ sender: UIButton) {
      let details = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNViewProfileVC") as! MNViewProfileVC
       details.isFreelauncer = false
        Constant.isIndividual = "freelancer"
        details.userIdFreelauncer = self.jobDetails.postedBy
      self.navigationController?.pushViewController(details, animated: true)
    }
    @IBAction func actionOnLeaveDetail(_ sender: UIButton) {
        let details = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNLeaveAFeedbackPopUpVC") as! MNLeaveAFeedbackPopUpVC
            // details.isFreelauncer = true
            details.profileImage = self.jobDetails.profilePic
        //popup.name = self.jobDetails.jobPostedBy
        details.jobId = self.jobDetails.id
        details.postedBy = self.jobDetails.postedBy
        self.navigationController?.pushViewController(details, animated: true)
           
}
    @IBAction func actionOnPayment(_ sender: UIButton) {
    let details = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNFreelauncerPaymentVC") as! MNFreelauncerPaymentVC
            // details.isFreelauncer = true
        details.JobId = self.jobDetails.id
        details.jobPostedBy = self.jobDetails.postedBy
        self.navigationController?.pushViewController(details, animated: true)
           
    }
    @IBAction func actionOnContractInfo(_ sender: UIButton) {
    
        let details = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNFreelauncerContractInfoVC") as! MNFreelauncerContractInfoVC
        // details.isFreelauncer = true
         details.jobId = self.jobDetails.id
         details.contractId   =  ContractId
         details.postedBy   =  self.jobDetails.postedBy
    self.navigationController?.pushViewController(details, animated: true)
    }
    @IBAction func actionOnChat(_ sender: UIButton) {
      // let myJob = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNIndividualInboxVC") as! MNIndividualInboxVC
      
         let vc = storyBoard.Individual.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            // let strImageUrl = dictUser["profile_pic"] as? String ?? ""

        //vc.sender_id = self.jobDetails.
             //vc.receiver_Id = self.requestList[intTag]
        vc.job_Id = self.jobDetails.jobId
        //     if let aud = self.requestList[intTag] {
        //     vc.room_id = String(aud)
        //     }

          //   vc.strTitle = dictUser["user_name"] as? String ?? "" self.requestList[intTag]
           //  vc.strImgeUrl =  img_BASE_URL + strImageUrl
            
        
        
            vc.sender_id = MyDefaults().UserId
            vc.receiver_Id =  self.jobDetails.postedBy
        //vc.receiver_Id = self.requestList[intTag]
          vc.strTitle = self.jobDetails.jobTitle
                vc.strImgeUrl =  img_BASE_URL + self.jobDetails.profilePic
        vc.hidesBottomBarWhenPushed = true
             self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        myJob.hidesBottomBarWhenPushed = true
//            self.dismiss(animated: true, completion: nil)
//            self.navigationController?.pushViewController(myJob, animated: true)
    }
    func convertDateFormater(_ strdate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
   func convertDateFormaterFoeOnlyDate(_ strdate: String) -> String{
           
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
extension MNFreelauncerProgressdetailVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayForSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.objIndividual.count
       if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        }
       else if section == 2 {
        if self.isHourlyAvailableDate == true{
             return hourlyJobTime.count
        }else{
         return 0
         }
    }
    return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 164
        } else if indexPath.section == 1
        {
            return 41.5
        }
        else if indexPath.section == 2
        {
            return 44
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       var cell : PostDetailTableViewCell?
        if indexPath.section == 0 {
            var cell : FreelancerProgressdetailTableViewCell?
             cell = tableView.dequeueReusableCell(withIdentifier: "FreelancerProgressdetailTableViewCell", for: indexPath) as? FreelancerProgressdetailTableViewCell
            let startdate = self.convertDateFormater(self.jobDetails.jobStartDate)
            let enddate = self.convertDateFormater(self.jobDetails.jobEndDate)
            
            let startTime = self.convertTimeFormater(self.jobDetails.jobStartTime)
            let endTime = self.convertTimeFormater(self.jobDetails.jobEndTime)
            
            cell?.lblStartDate.text! = startdate + " " + startTime
            cell?.lblEndDate.text! =   enddate + " " + endTime
            if self.jobDetails.jobType  == "Fixed"{
                cell?.lblDays.text = self.jobDetails.timeDuration + " Days"
                cell?.lblFix.text = self.jobDetails.jobType!
                cell?.lblPrice.text = "$" + self.jobDetails.budgetAmount
                }else{
                    cell?.lblDays.text = self.jobDetails.timeDuration + " Hours"
                    cell?.lblFix.text = self.jobDetails.jobType!
                    cell?.lblPrice.text = "$" + self.jobDetails.budgetAmount + "/hr."
                }
            
            
            return cell!
        }  else if indexPath.section == 1 {
            var cell : ViewdetailsTableViewCell?
             cell = tableView.dequeueReusableCell(withIdentifier: "ViewdetailsTableViewCell", for: indexPath) as? ViewdetailsTableViewCell
            return cell!
        } else if indexPath.section == 2 {
            
             cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell", for: indexPath) as? PostDetailTableViewCell
             let start = self.convertDateFormater(hourlyJobTime[indexPath.row].date) + " " + hourlyJobTime[indexPath.row].startTime + " "
            // cell?.lblDates.text   = dict["dates"] as? String
             let end = self.convertDateFormater(hourlyJobTime[indexPath.row].date) + " " + hourlyJobTime[indexPath.row].endTime + " "
             let startDate = self.convertMMMDDYYYYTOYYYYMMDDWithTime(start)
             let endDate = self.convertMMMDDYYYYTOYYYYMMDDWithTime(end)

             let sDate = self.convertDateFormater24format(startDate)
             let eDate = self.convertDateFormater24format(endDate)
             cell?.lblDates.text = sDate[0] + " " + sDate[1] + " " + " to" + " " + eDate[1]
             
        }
        return cell!
    }
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if isHourlyAvailableDate == true {
                isHourlyAvailableDate = false
           }else{
                isHourlyAvailableDate = true
           }
           tblView.reloadData()
       }
    func GetAmOrPM(strTime:String) -> String {
       // let dateAsString = "6:35 PM"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
         let date = dateFormatter.date(from: strTime)
        let dateString = dateFormatter.string(from: date!)
        return dateString
    }
    
}

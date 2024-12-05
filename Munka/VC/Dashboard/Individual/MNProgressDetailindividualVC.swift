//
//  MNProgressDetailindividualVC.swift
//  Munka
//
//  Created by Amit on 13/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNProgressDetailindividualVC: UIViewController,GetJobCompleted,GetJobStartIndividual,getCancelJobFromIndividual {
    @IBOutlet weak var lblposteddate: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet weak var lblSinceMember: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewJobCompleted: UIView!
    @IBOutlet weak var viewReviews: UIView!
    @IBOutlet weak var viewPayment: UIView!
    @IBOutlet weak var viewJobCompletedHight: NSLayoutConstraint!
    @IBOutlet weak var viewReviewsHight: NSLayoutConstraint!
    @IBOutlet weak var viewPaymentHight: NSLayoutConstraint!
    @IBOutlet weak var btnPayment: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnContractInfo: UIButton!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var viewStatus: UIView!
    
//    @IBOutlet weak var viewDurationHight: NSLayoutConstraint!
    @IBOutlet weak var viewStatusHight: NSLayoutConstraint!
//    @IBOutlet weak var viewDuration: UIView!
    @IBOutlet weak var tblView: UITableView!
   // @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewFooter: UIView!
    
    @IBOutlet weak var viewHourly: UIView!
    @IBOutlet weak var viewHourlyStart: UIView!
    @IBOutlet weak var viewHourlyStartHight: NSLayoutConstraint!
    @IBOutlet weak var viewHourlyCompleted: UIView!
    @IBOutlet weak var viewHourlyCompletedHight: NSLayoutConstraint!
    @IBOutlet weak var viewHourlyJobStatus: UIView!
    @IBOutlet weak var viewHourlyJobStatusHight: NSLayoutConstraint!
    @IBOutlet weak var viewHourlyReview: UIView!
    @IBOutlet weak var viewHourlyReviewHight: NSLayoutConstraint!
    @IBOutlet weak var btnHourlyStartWidth: NSLayoutConstraint!
    @IBOutlet weak var btnCompltedHourly: UIButton!
    @IBOutlet weak var btnCancelHourly: UIButton!
    
    @IBOutlet weak var viewHourPaymentDetails: UIView!
    @IBOutlet weak var viewHourlyPaymentDetailsHight: NSLayoutConstraint!
    
    
    //MARK:- Properties
    var JobId = ""
    var ContractId = ""
    var details : ModelProgressDetail!
    var hourlyJobTime = [ModelHourlyTime]()
    var isExpandView : Bool = false
    var isHourlyAvailableDate : Bool = false
    var arrayForSection =  [[String:Any]]()
    var isCheckDataContent : Bool = false
    var todayDate = ""
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(JobId)
        print("ContractId: \(ContractId)")
        self.tblView.isHidden = true
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        todayDate = formatter.string(from: date)
        // Do any additional setup after loading the view.
        if  isConnectedToInternet() {
                  self.callServiceForIndiJobDetailsAPI()
              } else {
                  self.showErrorPopup(message: internetConnetionError, title: alert)
          }
      //  self.viewBottom.roundCornersBottomSide(corners: [.topLeft,.topRight], radius: 8)
        btnMessage.roundedButtonOnlyRight()
           btnPayment.roundedButtonOnlyLeft()
        self.tblView.sectionFooterHeight = UITableView.automaticDimension
        self.tblView.estimatedSectionFooterHeight = 25
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tblView.layoutIfNeeded()
        viewFooter.layoutIfNeeded()
        viewFooter.sizeToFit()
    }
//    override func updateViewConstraints() {
//        tableHeightConstraint.constant = tableView.contentSize.height
//        super.updateViewConstraints()
//    }
    func callServiceForIndiJobDetailsAPI() {
      

      //  ShowHud()
ShowHud(view: self.view)
       print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "job_id":JobId,
                                      "contract_id":ContractId,
                                      "today_date":todayDate]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNIndividualProgressDetailJobListAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
HideHud(view: self.view)
            if response.count != nil{
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelIndiProgressDetail.init(fromDictionary: response as! [String : Any])
                    self.details = response.details
//                    self.setUI()
                self.tblView.isHidden = false
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
                    self.tblView.delegate = self
                    self.tblView.dataSource = self
                    self.tblView.reloadData()
                    self.setupUI()
                    } else if status == "4"
                    {
                        self.autoLogout(title: ALERTMESSAGE, message: message)
             }
             else
             {
               //  self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }} else{
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
    
    func setupUI()  {
        self.imgProfile.sd_setImage(with: URL(string:img_BASE_URL + self.details.profilePic!), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
        self.lblposteddate.text = "Posted " +  self.details.created.convertDateFormater(self.details.created)
        self.lblJobTitle.text = self.details.jobTitle
        self.lblCategory.text = self.details.serviceCategory
        self.lblCategory.sizeToFit()
        self.lblName.text = self.details.jobWorkedBy
        self.lblSinceMember.text = "Member since " + self.details.joiningDate.convertDateFormaterFoeOnlyDate1(self.details.joiningDate)
          
        if self.details.jobType == "Fixed" {
           
            if self.details.jobStatus == "Pending" {
                viewJobCompletedHight.constant = 0
                 viewJobCompleted.isHidden = true
                 viewReviewsHight.constant = 0
                 viewReviews.isHidden = true
                 viewPaymentHight.constant = 0
                 viewPayment.isHidden = true
                 self.btnPayment.isEnabled = false
                viewStatusHight.constant = 64
                viewStatus.isHidden = false
                
                 self.viewFooter.frame.size.height = 64
                 self.tblView.reloadData()
             self.btnPayment.setTitleColor(UIColor.hexStringToUIColor(hex: "#B1B1B1"), for: .normal)
                // self.tableViewHeightConstraint.constant = 720
             
             } else if self.details.jobStatus == "Completed" {
                    if self.details.isReview == "1" {
                     viewPaymentHight.constant = 72
                     viewPayment.isHidden = false
                     viewJobCompletedHight.constant = 0
                     viewJobCompleted.isHidden = true
                     viewReviewsHight.constant = 0
                     viewStatus.isHidden = true
                     viewStatusHight.constant = 0
                     viewReviews.isHidden = true
                     self.viewFooter.frame.size.height = 98
                     self.tblView.reloadData()
                // lblStatus.isHidden = true
                     self.btnPayment.isEnabled = true
                     self.btnPayment.setTitleColor(UIColor.white, for: .normal)
             }else{
                   
                     //lblStatus.isHidden = true
                     viewStatusHight.constant = 0
                     viewStatus.isHidden = true
                     viewPaymentHight.constant = 0
                     viewPayment.isHidden = true
                     viewJobCompletedHight.constant = 0
                     viewJobCompleted.isHidden = true
                     viewReviewsHight.constant = 106
                     self.viewFooter.frame.size.height = 110
                     self.tblView.reloadData()
                     viewReviews.isHidden = false
                 }
        }
            else{
                 viewJobCompletedHight.constant = 98
                 viewJobCompleted.isHidden = false
                 viewReviewsHight.constant = 0
                 viewReviews.isHidden = true
                 viewPaymentHight.constant = 0
                 viewPayment.isHidden = true
                viewStatusHight.constant = 0
                viewStatus.isHidden = true
                 self.viewFooter.frame.size.height = 98
                 self.tblView.reloadData()
                 //lblStatus.isHidden = false
                 self.btnPayment.isEnabled = false
                 self.btnPayment.setTitleColor(UIColor.hexStringToUIColor(hex: "#B1B1B1"), for: .normal)
             }
        }
        else{
            
            if self.details.jobStatus == "Pending"  {
                //self.viewHourly.isHidden = false
                    self.viewHourlyStart.isHidden = true
                    self.viewHourlyStartHight.constant = 0
                    self.viewHourlyReview.isHidden = true
                    self.viewHourlyReviewHight.constant = 0
                    self.viewHourlyCompleted.isHidden = true
                    self.viewHourlyCompletedHight.constant = 0
                    self.viewHourlyCompleted.isHidden = true
                    self.viewHourlyPaymentDetailsHight.constant = 0
                    self.viewHourlyJobStatus.isHidden = false
                    self.viewHourlyJobStatusHight.constant = 64
                    self.viewFooter.frame.size.height = 120
                    self.btnPayment.isEnabled = false
                    self.btnPayment.setTitleColor(UIColor.hexStringToUIColor(hex: "#B1B1B1"), for: .normal)
                    self.tblView.reloadData()
                   
            } else if self.details.jobStatus == "In_Process"  {
               // self.viewHourly.isHidden = false
                    print("In_Process")
                 if self.details.todayStatus == "Pending"{
                    print("Pending")
                    self.viewHourlyStart.isHidden = false
                    self.viewHourlyStartHight.constant = 116
                    self.viewHourlyCompleted.isHidden = true
                    self.viewHourlyCompletedHight.constant = 0
                    self.btnPayment.isEnabled = false
                    self.btnPayment.setTitleColor(UIColor.hexStringToUIColor(hex: "#B1B1B1"), for: .normal)
                    self.viewFooter.frame.size.height = 190
                    self.tblView.reloadData()
                    }
                 else if self.details.todayStatus == "In_Process"{
                   
                    if self.details.jobEndDate == todayDate {
                        self.viewHourlyStart.isHidden = true
                        self.viewHourlyStartHight.constant = 0
                        self.viewHourlyCompleted.isHidden = false
                        self.viewHourlyCompletedHight.constant = 116
                        self.viewFooter.frame.size.height = 190
                        self.btnPayment.isEnabled = false
                        self.btnPayment.setTitleColor(UIColor.hexStringToUIColor(hex: "#B1B1B1"), for: .normal)
                        self.tblView.reloadData()
                        // self.btnStartHourly.setTitle("Complet", for: .normal)
                    }else{
                        self.viewHourlyStart.isHidden = true
                        self.viewHourlyStartHight.constant = 0
                        self.viewHourlyCompleted.isHidden = false
                        self.viewHourlyCompletedHight.constant = 116
                        self.viewFooter.frame.size.height = 190
                        self.btnPayment.isEnabled = false
                        self.btnPayment.setTitleColor(UIColor.hexStringToUIColor(hex: "#B1B1B1"), for: .normal)
                        self.btnCompltedHourly.setTitle("END", for: .normal)
                        self.btnCompltedHourly.backgroundColor = UIColor.hexStringToUIColor(hex: "E6983F")
                        self.tblView.reloadData()
                    }
                }  else if self.details.todayStatus == "Completed"{
                    self.viewHourlyStart.isHidden = true
                    self.viewHourlyStartHight.constant = 0
                    self.viewHourlyCompleted.isHidden = false
                    self.viewHourlyCompletedHight.constant = 116
                    self.viewFooter.frame.size.height = 190
                    self.btnPayment.isEnabled = false
                    self.btnPayment.setTitleColor(UIColor.hexStringToUIColor(hex: "#B1B1B1"), for: .normal)
                    //self.btnCompltedHourly.setTitle("END", for: .normal)
                   // self.btnCompltedHourly.backgroundColor = UIColor.hexStringToUIColor(hex: "E6983F")
                    self.tblView.reloadData()
                }
                else if self.details.todayStatus == ""{
                    self.viewHourlyStart.isHidden = false
                    self.viewHourlyStartHight.constant = 116
                    self.viewHourlyCompleted.isHidden = true
                    self.viewHourlyCompletedHight.constant = 0
                    self.btnHourlyStartWidth.constant = 0
                    self.viewFooter.frame.size.height = 190
                    self.btnPayment.isEnabled = true
                    self.btnPayment.setTitleColor(UIColor.hexStringToUIColor(hex: "#B1B1B1"), for: .normal)
                    //self.btnCompltedHourly.setTitle("END", for: .normal)
                   // self.btnCompltedHourly.backgroundColor = UIColor.hexStringToUIColor(hex: "E6983F")
                    self.tblView.reloadData()
                }
                
            }
                 else if self.details.jobStatus == "Completed"  {
//                    self.viewHourlyStart.isHidden = true
//                    self.viewHourlyStartHight.constant = 0
//                    self.viewHourlyCompleted.isHidden = true
//                    self.viewHourlyCompletedHight.constant = 0
//                    self.viewHourlyJobStatus.isHidden = true
//                    self.viewHourlyJobStatusHight.constant = 0
//                    self.viewHourlyReview.isHidden = false
//                    self.viewHourlyReviewHight.constant = 106
//                //self.btnPayment.isEnabled = false
//                        //self.btnPayment.setTitleColor(UIColor.hexStringToUIColor(hex: "#B1B1B1"), for: .normal)
//                self.viewFooter.frame.size.height = 190
//                self.tblView.reloadData()
                
            if self.details.isReview == "1" {
                      self.viewHourlyStart.isHidden = true
                      self.viewHourlyStartHight.constant = 0
                      
                      self.viewHourlyCompleted.isHidden = true
                      self.viewHourlyCompletedHight.constant = 0
                     self.viewHourlyReview.isHidden = true
                     self.viewHourlyReviewHight.constant = 0
                self.viewHourlyJobStatus.isHidden = true
                self.viewHourlyJobStatusHight.constant = 0
                     
                self.viewHourPaymentDetails.isHidden = false
                      self.viewHourlyPaymentDetailsHight.constant = 116
                
                      self.tblView.reloadData()
                  }else{
                      self.viewHourlyStart.isHidden = true
                      self.viewHourlyStartHight.constant = 0
                      self.viewHourlyCompleted.isHidden = false
                      self.viewHourlyCompletedHight.constant = 116
                      self.viewFooter.frame.size.height = 190
                      self.btnPayment.isEnabled = false
                      self.btnPayment.setTitleColor(UIColor.hexStringToUIColor(hex: "#B1B1B1"), for: .normal)
                      self.tblView.reloadData()
                  }
              }
            self.viewHourly.frame.size.height = self.viewFooter.frame.size.height
            self.viewHourly.frame.size.width = self.viewFooter.frame.size.width
            self.viewFooter.frame.size.height = 120
            self.viewFooter.addSubview(self.viewHourly)
            self.tblView.reloadData()
        }
        viewFooter.layoutIfNeeded()
        tblView.tableFooterView?.layoutIfNeeded()
    }
    @IBAction func actionOnStartHourly(_ sender: UIButton) {
        
    self.callServiceforEndjob(jobStatus: "Start", wantToPay: "")
    }
    
    @IBAction func actionOnCompletedHourly(_ sender: UIButton) {
       
        if self.btnCompltedHourly.currentTitle == "END" {
            print("END")
            print(self.btnCompltedHourly.currentTitle!)
            let popup : MNJobCompletedPopUpVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNJobCompletedPopUpVC") as! MNJobCompletedPopUpVC
                popup.delagate = self
                popup.JobId = JobId
                popup.jobStatus = "End"
                popup.ContractId = ContractId
            self.presentOnRoot(with: popup)
        }else{
            let popup : MNJobCompletedPopUpVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNJobCompletedPopUpVC") as! MNJobCompletedPopUpVC
                   popup.delagate = self
                   popup.JobId = self.details.jobId
                   popup.jobStatus = "End"
                   popup.ContractId = ContractId
                   self.presentOnRoot(with: popup)
     
           // self.callServiceforEndjob(jobStatus: "Start", wantToPay: "")
        }
    }
    @IBAction func actionOnCancelHourly(_ sender: UIButton) {
       let popup : MNCancelJobInindividualPopUpVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNCancelJobInindividualPopUpVC") as! MNCancelJobInindividualPopUpVC
       popup.delagate = self
       popup.jobId = self.details.jobId
       popup.ContractId = ContractId
       popup.jobStatus = "After_Start_Cancel"
       self.presentOnRoot(with: popup)
    }
    @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOnProfile(_ sender: UIButton) {
    let details = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNFreelancerViewProfileVC") as! MNFreelancerViewProfileVC
//        details.jobId = self.details.id
//        details.contractId   =  ContractId
        details.isFreelauncer = true
        details.userIdFreelauncer   =  self.details.appliedBy
        Constant.isFreelancer = "individual"
    self.navigationController?.pushViewController(details, animated: true)
    
    }
       @IBAction func actionOnDropdown(_ sender: UIButton) {
        if !isExpandView {
                self.isExpandView = true
                self.arrayForSection.removeAll()
                tblView.reloadData()
            }else{
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
    func delegetJobCompleted(JobId: String, JobStatus: String, wantToPay: String, ContractID: String) {
        self.JobCompleted(jobId: JobId, jobStatus: JobStatus, ContractId: ContractID, wantToPay: wantToPay)
    }
    @IBAction func actionOnJobCompleted(_ sender: UIButton) {
    let popup : MNJobCompletedPopUpVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNJobCompletedPopUpVC") as! MNJobCompletedPopUpVC
        popup.delagate = self
        popup.JobId = self.details.jobId
        popup.jobStatus = "End"
        popup.ContractId = ContractId
        self.presentOnRoot(with: popup)
    }
    @IBAction func actionOnJobCancel(_ sender: UIButton) {
     let popup : MNCancelJobInindividualPopUpVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNCancelJobInindividualPopUpVC") as! MNCancelJobInindividualPopUpVC
     popup.delagate = self
     popup.jobId = self.details.jobId
     popup.ContractId = ContractId
     popup.jobStatus = "After_Start_Cancel"
     self.presentOnRoot(with: popup)
    }
    @IBAction func actionOnPayment(_ sender: UIButton) {
       let details = storyBoard.Individual.instantiateViewController(withIdentifier: "MNIndividualPaymentVC") as! MNIndividualPaymentVC
             details.jobid = self.details.jobId
       self.navigationController?.pushViewController(details, animated: true)
    }
    @IBAction func actionOnPaymentDetails(_ sender: UIButton) {
       let details = storyBoard.Individual.instantiateViewController(withIdentifier: "MNIndividualPaymentVC") as! MNIndividualPaymentVC
            details.jobid = self.details.jobId
      self.navigationController?.pushViewController(details, animated: true)
    }
    @IBAction func actionOnContractInfo(_ sender: UIButton) {
    let details = storyBoard.Individual.instantiateViewController(withIdentifier: "MNIndividualContractInfoVC") as! MNIndividualContractInfoVC
        details.jobId = self.details.jobId
        details.contractId   =  ContractId
        details.postedBy   =  self.details.postedBy
        self.navigationController?.pushViewController(details, animated: true)
    }
    @IBAction func actionOnReview(_ sender: UIButton) {
    let details = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNArriveindividualPopVC") as! MNArriveindividualPopVC
        details.jobId = self.details.jobId
       //details.contractId   =  ContractId
        details.postedBy   =  self.details.appliedBy
        details.profileImage   =  self.details.profilePic
        details.name   =  self.details.jobWorkedBy
       
        details.name   =  self.details.jobWorkedBy
        
        
        
        self.navigationController?.pushViewController(details, animated: true)
    }
    @IBAction func actionOnMessage(_ sender: UIButton) {
//        let myJob = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNIndividualInboxVC") as! MNIndividualInboxVC
//            myJob.hidesBottomBarWhenPushed = true
//            self.dismiss(animated: true, completion: nil)
//            self.navigationController?.pushViewController(myJob, animated: true)
    
    
    
    
    let vc = storyBoard.Individual.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            
            vc.job_Id = self.details.jobId
        print(vc.job_Id)
            vc.sender_id = MyDefaults().UserId
            vc.receiver_Id = self.details.appliedBy
        //vc.receiver_Id = self.requestList[intTag]
        
        
        vc.strTitle = self.details.jobTitle
        vc.strImgeUrl =  img_BASE_URL + self.details.profilePic
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
}
    func JobCompleted(jobId:String,jobStatus:String,ContractId:String,wantToPay:String) {
        

      //  ShowHud()
ShowHud(view: self.view)
        //print(MyDefaults().UserId!)
         let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                       "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                       "job_id":jobId,
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
                     popup.contractId = ContractId
                     popup.JobId = jobId
                
                     popup.reasaonJob = jobStatus
                     popup.wantToPay = wantToPay
                     popup.isIndividualOtp = false
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
    func delegateIndividualJobStart(strOTP: String, jobId: String, wntToPay: String, lateComingStatus: String, jobStatus: String) {
        

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

          // HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
              let message = response["msg"] as! String
              if status == "1"
              {
                
                //self.showErrorPopup(message: message, title: ALERTMESSAGE)
                self.alertView(messgae: message, title: ALERTMESSAGE)
              
              }else if status == "4"
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
    
    func delegateCancelJobForindividual(jobStatus: String, jobId: String, ContractId: String, wantToPay: String) {
        self.JobCompleted(jobId: jobId, jobStatus: jobStatus, ContractId: ContractId, wantToPay: wantToPay)
    }
    func alertView(messgae:String,title:String)  {
        let alertController = UIAlertController(title: title, message: messgae, preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.funPopView()
        }
       
        alertController.addAction(okAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
     func funPopView(){
    self.navigationController?.backToViewController(viewController: MNProgressVC.self)
    }
}
 extension MNProgressDetailindividualVC: UITableViewDataSource,UITableViewDelegate{
     // MARK: - Delegate method for table view
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
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
             return 162
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
            let startdate = self.convertDateFormater(self.details.jobStartDate)
           // let enddate = self.convertDateFormater(self.details.jobEndDate)
            let enddate =  Global.convertDateFormat(self.details.jobEndDate, sourceFormate: "yyyy-MM-dd", targetFormate: "MMM dd, yyyy")
            
             let startTime = self.convertTimeFormater(self.details.jobStartTime)
             let endTime = self.convertTimeFormater(self.details.jobEndTime)

             cell?.lblStartDate.text! = startdate + " " + startTime
             cell?.lblEndDate.text! =   enddate + " " + endTime
             if self.details.jobType  == "Fixed"{
                 cell?.lblDays.text = self.details.timeDuration + " Days"
             let strJobType = "\(self.details.jobType!)"
                       
                 cell?.lblFix.text = strJobType
                 cell?.lblPrice.text = "$" + self.details.budgetAmount
                 }else{
                     cell?.lblDays.text = self.details.timeDuration + " Hours"
                     cell?.lblFix.text = self.details.jobType!
                     cell?.lblPrice.text = "$" + self.details.budgetAmount + "/hr."
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
     func convertTimeFormater(_ dateAsString: String) -> String
     {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "HH:mm:ss"
         let date = dateFormatter.date(from: dateAsString)
         dateFormatter.dateFormat = "hh:mm a"
         let Date12 = dateFormatter.string(from: date!)
         return Date12
     }
    func convertDateFormater(_ strdate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
    func callServiceforEndjob(jobStatus:String,wantToPay:String) {
      

      //  ShowHud()
ShowHud(view: self.view)
       //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "job_id":JobId,
                                      "message":"1",
                                      ]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNSendJobOTPAPI , parameter: parameter) { (response) in
             debugPrint(response)

      //    HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let popup : MNIndividualJobStartOTPVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNIndividualJobStartOTPVC") as! MNIndividualJobStartOTPVC
                    popup.delagate = self
                    popup.JobId = self.JobId
                    popup.contractId = self.ContractId
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
 }

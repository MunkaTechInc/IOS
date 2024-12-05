//
//  MNFreelauncerContractInfoVC.swift
//  Munka
//
//  Created by Amit on 09/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNFreelauncerContractInfoVC: UIViewController {
     @IBOutlet weak var lblPostedJob:UILabel!
     @IBOutlet weak var lblDays:UILabel!
     @IBOutlet weak var lblFixed:UILabel!
     @IBOutlet weak var lblPrice:UILabel!
     @IBOutlet weak var lblStartDate:UILabel!
     @IBOutlet weak var lblEndDate:UILabel!
     @IBOutlet weak var lblJobDescriptions:UILabel!
     @IBOutlet weak var txtViewJobDescriptions:UITextView!
     @IBOutlet weak var viewAccept:UIView!
     @IBOutlet weak var viewAcceptHeight:NSLayoutConstraint!
     @IBOutlet weak var btnTools:UIButton!
     @IBOutlet weak var btnNone:UIButton!
     @IBOutlet weak var btnMaterial:UIButton!
     @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var viewLocation:UIView!
    @IBOutlet weak var viewLocationHight:NSLayoutConstraint!
    @IBOutlet weak var lblAddress:UILabel!
     var jobDetails : ModelContactDetail!
     var hourlyJobTime = [ModelContractHourlyJobTime]()
     var arrayForSection =  [[String:Any]]()
    
     var jobId = ""
     var contractId = ""
    var postedBy = ""
    var materialStatus = ""
    var isAcceptContract : Bool = true
    var isHourlyAvailableDate : Bool = false
    
     var type = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if  isConnectedToInternet() {
                self.callServiceForContactInfoAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        txtViewJobDescriptions.text = "Description…"
        txtViewJobDescriptions.resignFirstResponder()
        txtViewJobDescriptions.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
       //  Do any additional setup after loading the view.
        btnNone.isSelected = true
        materialStatus = "None"
    }
    @IBAction func actionOnMetarials(_ sender: UIButton) {
        if btnMaterial.isSelected {
            btnMaterial.isSelected = true
            btnTools.isSelected = false
            btnNone.isSelected = false
            
        }else {
            btnMaterial.isSelected = true
            btnTools.isSelected = false
            btnNone.isSelected = false
            materialStatus = "Materials"
        }
    }
    @IBAction func actionOnTools(_ sender: UIButton) {
        if btnTools.isSelected {
           btnTools.isSelected = true
            btnMaterial.isSelected = false
            btnNone.isSelected = false
        }else {
           btnTools.isSelected = true
            btnMaterial.isSelected = false
            btnNone.isSelected = false
            materialStatus = "Tools"
            
        }
    }
    @IBAction func actionOnNone(_ sender: UIButton) {
        if btnNone.isSelected {
            btnNone.isSelected = true
            btnMaterial.isSelected = false
            btnTools.isSelected = false
        }else {
            btnNone.isSelected = true
            btnMaterial.isSelected = false
            btnTools.isSelected = false
            materialStatus = "None"
            
        }
    }
    @IBAction func actionOnAccept(_ sender: UIButton) {
         isAcceptContract =  true
        self.alertAcceptJob()
    }
    @IBAction func actionOnCancel(_ sender: UIButton) {
         isAcceptContract =  false
       // self.alertAcceptJob()
        let popup : PopUpCancelJobpopUp = storyBoard.PopUp.instantiateViewController(withIdentifier: "PopUpCancelJobpopUp") as! PopUpCancelJobpopUp
            popup.delagate = self
            popup.postedBy = postedBy
            popup.jobId = jobId
            popup.contractId = contractId
            self.presentOnRoot(with: popup)
            }
    @IBAction func actionOnBack(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOnPrinter(_ sender: UIButton) {
      // self.navigationController?.popViewController(animated: true)
        let details = storyBoard.Main.instantiateViewController(withIdentifier: "MNPrinterVC") as! MNPrinterVC
        details.contractId = contractId
        self.navigationController?.pushViewController(details, animated: true)
    }
    @IBAction func actionOnHourly(_ sender: UIButton) {
        if isHourlyAvailableDate == true {
             isHourlyAvailableDate = false
        }else{
             isHourlyAvailableDate = true
        }
        tblView.reloadData()
    }
    func callServiceForContactInfoAPI() {
      

        //ShowHud()
        ShowHud(view: self.view)
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "job_id":jobId,
                                     "contract_id":contractId,
                                    "user_type":MyDefaults().swiftUserData["user_type"] as! String]
         debugPrint(parameter)
         
        HTTPService.callForPostApi(url:MNContractDetailAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
            HideHud(view: self.view)

            if response.count != nil{
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelContractdetail.init(fromDictionary: response as! [String : Any])
                    self.jobDetails = response.details

                if response.details.contractHourlyJobTime.count > 0 {
                    self.isHourlyAvailableDate = false
                    self.hourlyJobTime = response.details.contractHourlyJobTime
                    var dictionary =  [String:Any]()
                    dictionary["status"] = "data"
                    self.arrayForSection.append(dictionary)
                    var dictionary1 =  [String:Any]()
                    dictionary1["viewdetails"] = "data"
                    self.arrayForSection.append(dictionary1)
                }else{
//                    var dictionary =  [String:Any]()
//                    dictionary["status"] = "data"
//                    self.arrayForSection.append(dictionary)
                }
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
                self.setupUI()
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
    }
        func setupUI() {
            
                let startdate = self.convertDateFormater(self.jobDetails.jobStartDate)
                let enddate = self.convertDateFormater(self.jobDetails.jobEndDate)

                let startTime = self.convertTimeFormater(self.jobDetails.jobStartTime)
                let endTime = self.convertTimeFormater(self.jobDetails.jobEndTime)

                lblStartDate.text! = startdate + " " + startTime
                lblEndDate.text! =   enddate + " " + endTime
            lblJobDescriptions.lineBreakMode = NSLineBreakMode.byWordWrapping
                lblJobDescriptions.numberOfLines = 3
            lblJobDescriptions.text = self.jobDetails.jobDescription
                if self.jobDetails.jobType  == "Fixed"{
                    lblDays.text = self.jobDetails.timeDuration + " Days"
                    lblFixed.text = self.jobDetails.jobType!
                    lblPrice.text = "$" + self.jobDetails.budgetAmount

                }else{
                    lblDays.text = self.jobDetails.timeDuration + " hr"
                    lblFixed.text = self.jobDetails.jobType!
                    lblPrice.text = "$" + self.jobDetails.budgetAmount
                }
            if self.jobDetails.status == "Pending" {
                viewAcceptHeight.constant = 60
                viewAccept.isHidden = false
            } else if self.jobDetails.status == "Accepted" {
                viewAcceptHeight.constant = 0
                 viewAccept.isHidden = true
            } else if self.jobDetails.status == "Rejected" {
                viewAcceptHeight.constant = 0
                viewAccept.isHidden = true
            }
            if self.jobDetails.status == "Accepted" || self.jobDetails.status == "Rejected"  {
               // view.isUserInteractionEnabled = false
                btnNone.isEnabled = false
                btnTools.isEnabled = false
                btnMaterial.isEnabled = false
                txtViewJobDescriptions.isEditable = false
            
            }
           
            if self.jobDetails.materialDescription.isEmpty {
                 txtViewJobDescriptions.text = "Description…"
            }else{
               
                txtViewJobDescriptions.text = self.jobDetails.materialDescription
            }
            
            
            if self.jobDetails.sendMaterial == "Materials" {
                btnNone.isSelected = false
                btnMaterial.isSelected = true
                btnMaterial.isEnabled = true
                btnTools.isSelected = false

            } else if self.jobDetails.sendMaterial == "Tools" {
                btnNone.isSelected = false
                btnMaterial.isSelected = false
                btnTools.isSelected = true
                btnTools.isEnabled = true

            } else if self.jobDetails.sendMaterial == "None" {
                btnNone.isEnabled = true
                btnNone.isSelected = true
                btnMaterial.isSelected = false
                btnTools.isSelected = false
            }else if self.jobDetails.sendMaterial == "" {
                btnNone.isEnabled = true
                btnNone.isSelected = true
                btnMaterial.isSelected = false
                btnTools.isSelected = false
            }
            if self.jobDetails.isPrivate == "1" {
                self.viewLocation.isHidden = true
                self.viewLocationHight.constant = 0
            }else{
                self.viewLocation.isHidden = false
                self.viewLocationHight.constant = 58
                self.lblAddress.text = self.jobDetails.jobLocation
            }
          }
    func alertAcceptJob(){
        let alertController = UIAlertController(title: ALERTMESSAGE, message: "are you sure want to accept this job.", preferredStyle: .alert)

           // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
               UIAlertAction in
               NSLog("OK Pressed")
            self.jobAccept()
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
    func jobAccept() {
        if  isConnectedToInternet() {
            self.callServiceforAccept()
              } else {
                  self.showErrorPopup(message: internetConnetionError, title: alert)
          }
    }
        func callServiceforAccept() {

//            ShowHud()
ShowHud(view: self.view)
            print(MyDefaults().UserId ?? "")
            let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                          "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                          "job_id":jobId,
                                         "contract_id":contractId,
                                        "user_type":MyDefaults().swiftUserData["user_type"] as! String,
                                        "status":"Accepted",
                                        "posted_by":postedBy,
                                        "send_material":materialStatus,
                                        "material_description":txtViewJobDescriptions.text!]
             debugPrint(parameter)
             HTTPService.callForPostApi(url:MNContractActionAPI , parameter: parameter) { (response) in
                 debugPrint(response)

            //  HideHud()
HideHud(view: self.view)
                if response.count != nil{
                let status = response["status"] as! String
                 let message = response["msg"] as! String
                 if status == "1"
                 {
//                    self.navigationController?.popViewController(animated: true)
//                 self.showErrorPopup(message: message, title: ALERTMESSAGE)
                    self.alertViewForBacktoController(title: ALERTMESSAGE, message: message)
                    
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
    func convertTimeFormater(_ dateAsString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "hh:mm a"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
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
}
    
extension MNFreelauncerContractInfoVC:UITextViewDelegate,UITextFieldDelegate,GetCancelJob{
   
    func delegateForCancelJob() {
        self.navigationController?.backToViewController(viewController: MNProgressVC.self)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.hexStringToUIColor(hex: "B1B1B1") {
        textView.text = nil
        textView.textColor = UIColor.hexStringToUIColor(hex: "7E8290")
    }
}
func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
        textView.text = "Description…"
        textView.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
    }
}
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 150
    }
    
}

    extension MNFreelauncerContractInfoVC: UITableViewDataSource,UITableViewDelegate{
        // MARK: - Delegate method for table view
        func numberOfSections(in tableView: UITableView) -> Int {
            return self.arrayForSection.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //return self.objIndividual.count
           if section == 0 {
                return 1
            }
           else  {
            if self.isHourlyAvailableDate == true{
                 return hourlyJobTime.count
            }else{
             return 0
             }
        }
        
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.section == 0
            {
                return 41.5
            } else
            {
                return 44
            }
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0 {
                var cell : ViewdetailsTableViewCell?
                 cell = tableView.dequeueReusableCell(withIdentifier: "ViewdetailsTableViewCell", for: indexPath) as? ViewdetailsTableViewCell
                return cell!
            }else{
                var cell : PostDetailTableViewCell?
                cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell", for: indexPath) as? PostDetailTableViewCell
                let start = self.convertDateFormater(hourlyJobTime[indexPath.row].date) + " " + hourlyJobTime[indexPath.row].startTime + " "
                let end = self.convertDateFormater(hourlyJobTime[indexPath.row].date) + " " + hourlyJobTime[indexPath.row].endTime + " "
                let startDate = self.convertMMMDDYYYYTOYYYYMMDDWithTime(start)
                let endDate = self.convertMMMDDYYYYTOYYYYMMDDWithTime(end)
                let sDate = self.convertDateFormater24format(startDate)
                let eDate = self.convertDateFormater24format(endDate)
                cell?.lblDates.text = sDate[0] + " " + sDate[1] + " " + " to" + " " + eDate[1]
                return cell!
            }
           
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

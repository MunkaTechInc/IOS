//
//  MNIndividualContractInfoVC.swift
//  Munka
//
//  Created by Amit on 14/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
let placeHolderText = "Description..."
class MNIndividualContractInfoVC: UIViewController {
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
    @IBOutlet weak var viewAddress:UIView!
    @IBOutlet weak var lblAddress:UILabel!
    
    
    //@IBOutlet weak var viewAddressHeight:NSLayoutConstraint!
    
    @IBOutlet weak var btnTools:UIButton!
    @IBOutlet weak var btnNone:UIButton!
    @IBOutlet weak var btnMaterial:UIButton!
    
     var jobDetails : ModelContactDetail!
     var jobId = ""
     var contractId = ""
     var postedBy = ""
     var materialStatus = ""
     var isAcceptContract : Bool = true
     var type = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if  isConnectedToInternet() {
                self.callServiceForContactInfoAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
            txtViewJobDescriptions.text = placeHolderText
            txtViewJobDescriptions.becomeFirstResponder()
            txtViewJobDescriptions.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
        // Do any additional setup after loading the view.
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
        self.alertAcceptJob()
    }
    @IBAction func actionOnBack(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
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

        //  HideHud()
            HideHud(view: self.view)

            if response.count != nil{
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelContractdetail.init(fromDictionary: response as! [String : Any])
                    self.jobDetails = response.details
                    self.setupUI()
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
        func setupUI() {
            
//                let startdate = self.convertDateFormater(self.jobDetails.jobStartDate)
//                let enddate = self.convertDateFormater(self.jobDetails.jobEndDate)
let startdate =  Global.convertDateFormat(self.jobDetails.jobStartDate, sourceFormate: "yyyy-MM-dd", targetFormate: "MMM dd, yyyy")
            let enddate =  Global.convertDateFormat(self.jobDetails.jobEndDate, sourceFormate: "yyyy-MM-dd", targetFormate: "MMM dd, yyyy")
                lblAddress.text! = self.jobDetails.jobLocation
            
            let startTime = self.convertTimeFormater(self.jobDetails.jobStartTime)
                let endTime = self.convertTimeFormater(self.jobDetails.jobEndTime)

                lblStartDate.text! = startdate + " " + startTime
                lblEndDate.text! =   enddate + " " + endTime
                lblJobDescriptions.text = self.jobDetails.jobDescription
                if self.jobDetails.jobType  == "Fixed"{
                    lblDays.text = self.jobDetails.timeDuration + " Days"
                    let strJobType = "\(self.jobDetails.jobType!)"
                    //lblDuration.text = "   "+strJobType+"   "
                    lblFixed.text = strJobType
                    lblPrice.text = "$" + self.jobDetails.budgetAmount

                }else{

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
                view.isUserInteractionEnabled = false
                txtViewJobDescriptions.resignFirstResponder()
                txtViewJobDescriptions.textColor = UIColor.black
            }
            txtViewJobDescriptions.text = self.jobDetails.materialDescription
            
            if self.jobDetails.sendMaterial == "Materials" {
                btnNone.isSelected = false
                btnMaterial.isSelected = true
                btnTools.isSelected = false

            } else if self.jobDetails.sendMaterial == "Tools" {
                btnNone.isSelected = false
                btnMaterial.isSelected = false
                btnTools.isSelected = true

            } else if self.jobDetails.sendMaterial == "None" {
                btnNone.isSelected = true
                btnMaterial.isSelected = false
                btnTools.isSelected = false

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

            //ShowHud()
ShowHud(view: self.view)
            if isAcceptContract ==  true {
                 type = "Accepted"
            }else{
                type = "Rejected"
            }
            
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
                    self.navigationController?.popViewController(animated: true)
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
    
extension MNIndividualContractInfoVC:UITextViewDelegate,UITextFieldDelegate{
func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.hexStringToUIColor(hex: "B1B1B1") {
        textView.text = nil
        textView.textColor = UIColor.hexStringToUIColor(hex: "7E8290")
    }
}
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.txtViewJobDescriptions.textColor = .black
        if(self.txtViewJobDescriptions.text == placeHolderText) {
            self.txtViewJobDescriptions.text = ""
        }

        return true
    }
func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
        textView.text = placeHolderText
        textView.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
    }
}
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 150
    }
}

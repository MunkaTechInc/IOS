//
//  MNFreelancerMackClaimVC.swift
//  Munka
//
//  Created by Amit on 10/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNFreelancerMackClaimVC: UIViewController,GetSelectReason {
   
    @IBOutlet weak var txtField: UITextField!
       @IBOutlet weak var txtView: UITextView!
    var reasonId = ""
    var jobId = ""
    var reason = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView.text = "Description…"
        txtView.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
        // Do any additional setup after loading the view.
    }
    @IBAction func actionOnSubmit(_ sender: UIButton) {
      if !isClaimalidation() {
        if  isConnectedToInternet() {
            self.callServiceFormakeclaimAPI()
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
}
    @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func delegateCancelReasonType(Model: ModelReasonDetail) {
        reasonId = Model.id
        txtField.text = Model.name
    }
       func isClaimalidation() -> Bool {
           guard let email = txtField.text , email != ""
               else {showAlert(title: ALERTMESSAGE, message: "Please enter reason.")
                   return true}
           guard let password = txtView.text , password != ""
                      else {showAlert(title: ALERTMESSAGE, message: "Please enter message.")
                          return true}
          
           return false
       }
    @IBAction func actionOnDropDown(_ sender: UIButton) {
        let popup : SelectReasonVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "SelectReasonVC") as! SelectReasonVC
         popup.delagate = self
        //popup.isClickOnSignUp = false
        self.presentOnRoot(with: popup)
}
    
    func callServiceFormakeclaimAPI() {
      

      //  ShowHud()
        ShowHud(view: self.view)
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "job_id":jobId,
                                      "claim_reason_id":reasonId,
                                      "message":txtView.text!]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNAddClaimAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
//                let response = ModelJobDetails.init(fromDictionary: response as! [String : Any])
//                    self.jobDetails = response.details
//                    self.setupUI()
               self.showErrorPopup(message: message, title: ALERTMESSAGE)
                self.navigationController?.popViewController(animated: true)
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
extension MNFreelancerMackClaimVC:UITextViewDelegate,UITextFieldDelegate{
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

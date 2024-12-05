//
//  FreelancercanceJobPopUp.swift
//  Munka
//
//  Created by Amit on 11/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
protocol GetcancelJobFreelancer {
    
    func delegateCancelJob(strOTP:String,ContractId:String,reasaonJob:String,wntToPay:String)
}
class FreelancercanceJobPopUp: UIViewController,UITextFieldDelegate {
    var delagate: GetcancelJobFreelancer!
    @IBOutlet weak var viewOtp:UIView!
    @IBOutlet weak var txt1:UITextField!
    @IBOutlet weak var txt2:UITextField!
    @IBOutlet weak var txt3:UITextField!
    @IBOutlet weak var txt4:UITextField!
    var ContractId = ""
    var reasaonJob = ""
    var wantToPay  = ""
    var jobId  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.viewOtp.roundCornersBottomSide(corners: ([.topLeft, .topRight]), radius: 10)
            self.txt1.addBottomBorder()
          self.txt2.addBottomBorder()
          self.txt3.addBottomBorder()
          self.txt4.addBottomBorder()
        // CGcolorString
          txt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
          txt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
          txt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
          txt4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionOnResendOtp(_ sender: UIButton) {
        ShowHud(view: self.view)
   // ShowHud()
    //print(MyDefaults().UserId!)
     let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                   "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                   "job_id":jobId]
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
    @IBAction func actionOnSubmit(_ sender: UIButton) {
        var Otp =  txt1.text! + txt2.text! + txt3.text! + txt4.text!
        if !isMobileValidation() {
            if  isConnectedToInternet() {
                if self.delagate != nil {
               // self.dismiss(animated: true, completion: nil)
                    self.delagate.delegateCancelJob(strOTP: Otp, ContractId: ContractId, reasaonJob: reasaonJob, wntToPay: wantToPay)
                }
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text
        if text?.utf16.count == 1
        {
            switch textField{
            case txt1:
                 self.txt2.becomeFirstResponder()
            case txt2:
                self.txt3.becomeFirstResponder()
            case txt3:
                self.txt4.becomeFirstResponder()
            case txt4:
                self.txt4.resignFirstResponder()
          
            default:
                break
            }
        }
        else
        {

            
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func isMobileValidation() -> Bool {
        guard let txt1 = txt1.text , txt1 != ""
            else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP varification code")
                return true}
        guard let txt2 = txt2.text , txt2 != ""
                   else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP varification code")
                       return true}
        guard let txt3 = txt3.text , txt3 != ""
                   else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP varification code")
                       return true}
        guard let txt4 = txt4.text , txt4 != ""
                   else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP varification code")
                       return true}
        return false
    }
}

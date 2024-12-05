//
//  MNAccountVarificationVC.swift
//  Munka
//
//  Created by Amit on 12/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNAccountVarificationVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var txtMobile1: UITextField!
    @IBOutlet weak var txtMobile2: UITextField!
    @IBOutlet weak var txtMobile3: UITextField!
    @IBOutlet weak var txtMobile4: UITextField!
   
    @IBOutlet weak var txteMail1: UITextField!
    @IBOutlet weak var txteMail2: UITextField!
    @IBOutlet weak var txteMail3: UITextField!
    @IBOutlet weak var txteMail4: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMobile1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtMobile2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtMobile3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtMobile4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        txteMail1.addTarget(self, action: #selector(textFieldDidChangeEmail(_:)), for: .editingChanged)
        txteMail2.addTarget(self, action: #selector(textFieldDidChangeEmail(_:)), for: .editingChanged)
        txteMail3.addTarget(self, action: #selector(textFieldDidChangeEmail(_:)), for: .editingChanged)
        txteMail4.addTarget(self, action: #selector(textFieldDidChangeEmail(_:)), for: .editingChanged)
        }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
            let text = textField.text
            if text?.utf16.count == 1
            {
                switch textField{
                case txtMobile1:
                     self.txtMobile2.becomeFirstResponder()
                case txtMobile2:
                    self.txtMobile3.becomeFirstResponder()
                case txtMobile3:
                    self.txtMobile4.becomeFirstResponder()
                case txtMobile4:
                    self.txtMobile4.resignFirstResponder()
              
                default:
                    break
                }
            }
            else
            {

                
            }
        }
    @objc func textFieldDidChangeEmail(_ textField: UITextField) {
        let text = textField.text
        if text?.utf16.count == 1
        {
            switch textField.tag{
            case 101:
                 self.txteMail2.becomeFirstResponder()
            case 102:
                self.txteMail3.becomeFirstResponder()
            case 103:
                self.txteMail4.becomeFirstResponder()
            case 104:
                self.txteMail4.resignFirstResponder()
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
    @IBAction func actionOnEmailVarification(_ sender: UIButton) {
    if !isMobileValidation() {
        if  isConnectedToInternet() {
            for textField in self.view.subviews where textField is UITextField {
                textField.resignFirstResponder()
            }
               // callServiceMobileVerification()
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    }
    @IBAction func actionOnMobileVarification(_ sender: UIButton) {
    if !isEmailValidation() {
        if  isConnectedToInternet() {
            for textField in self.view.subviews where textField is UITextField {
                textField.resignFirstResponder()
            }
              // callServiceEmailVerification()
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    }
    func isMobileValidation() -> Bool {
        guard let txt1 = txtMobile1.text , txt1 != ""
            else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP varification code")
                return true}
        guard let txt2 = txtMobile2.text , txt2 != ""
                   else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP varification code")
                       return true}
        guard let txt3 = txtMobile3.text , txt3 != ""
                   else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP varification code")
                       return true}
        guard let txt4 = txtMobile1.text , txt4 != ""
                   else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP varification code")
                       return true}
        return false
    }
    func isEmailValidation() -> Bool {
        guard let txtMob1 = txtMobile1.text , txtMob1 != ""
            else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP varification code")
                return true}
        guard let txtMob2 = txtMobile2.text , txtMob2 != ""
                   else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP varification code")
                       return true}
        guard let txtMob3 = txtMobile3.text , txtMob3 != ""
                   else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP varification code")
                       return true}
        guard let txtMob4 = txtMobile1.text , txtMob4 != ""
                   else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP varification code")
                       return true}
        return false
    }
    @IBAction func actionOnResendOtpFromMobile(_ sender: UIButton) {
       // callServiceForResendOTPFromMobile()
    }
    @IBAction func actionOnResendOtpFromEmail(_ sender: UIButton) {
        callServiceForResendOTPFromEmail()
    }
//    func callServiceForResendOTPFromMobile() {
//        let parameter: [String: Any] = [
//                                            "email":MyDefaults().UserId!,
//                                            "type":"",
//                                            "verification_code":""]
//               debugPrint(parameter)
//               HTTPService.callForPostApi(url:MNResendOtpAPI , parameter: parameter) { (response) in
//                   debugPrint(response)
//                   let status = response["status"] as! String
//                   let message = response["msg"] as! String
//
//
//               }
//           }
    
    func callServiceForResendOTPFromEmail() {
        
    }
}

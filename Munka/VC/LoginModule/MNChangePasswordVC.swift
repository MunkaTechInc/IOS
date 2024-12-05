//
//  MNChangePasswordVC.swift
//  Munka
//
//  Created by Amit on 14/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNChangePasswordVC: UIViewController {
    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var imgRight: UIImageView!
    @IBOutlet weak var imgRightconstarints: NSLayoutConstraint!
    @IBOutlet weak var lblUserMail: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgRight.isHidden = true
           self.imgRightconstarints.constant = 0
        // Do any additional setup after loading the view.
        lblUserMail.text! = MyDefaults().UserEmail!
        txtPassword.addTarget(self, action: #selector(MNChangePasswordVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let emailPred = NSPredicate(format:"SELF MATCHES %@", regexPassword)
        //return emailPred.evaluate(with: passwordStr)
        
        if  emailPred.evaluate(with: textField.text!){
            imgRightconstarints.constant = 25
            imgRight.isHidden = false
        }else{
            imgRightconstarints.constant = 0
            imgRight.isHidden = true
        }
    }
    @IBAction func actionOnBack(_ sender: UIButton) {
             self.navigationController?.popViewController(animated: true)
          }
    func isForgotValidation() -> Bool {
        guard let email = txtOTP.text , email != ""
            else {showAlert(title: ALERTMESSAGE, message: "Please enter OTP.")
                return true}
        
       guard let password = txtPassword.text , password != ""
                         else {showAlert(title: ALERTMESSAGE, message: "Please enter password.")
                                        return true}
        guard let _ = txtPassword.text ,isValidatePasswordLength(password: txtPassword.text!) else {showAlert(title: ALERTMESSAGE, message: "Please enter confirm password")
               return true}
        guard let passwordlenght = txtPassword.text , passwordlenght != "" ,isValidPassword(emailStr: txtPassword.text!) else {showAlert(title: ALERTMESSAGE, message: "Use at least one numeric,alphabetic character and one symbol for password.")
                          return true}
        
        
        guard let confirmPassword = txtConfirmPassword.text , confirmPassword != ""
                         else {showAlert(title: ALERTMESSAGE, message: "Please enter confirm password.")
                                        return true}
        guard let _ = txtConfirmPassword.text ,isValidatePasswordLength(password: txtConfirmPassword.text!) else {showAlert(title: ALERTMESSAGE, message: "Please enter confirm password")
               return true}
        guard let _ = txtConfirmPassword.text , passwordlenght != "" ,isValidPassword(emailStr: txtConfirmPassword.text!) else {showAlert(title: ALERTMESSAGE, message: "Use at least one numeric,alphabetic character and one symbol for password.")
                          return true}
        
        guard let _ = txtConfirmPassword.text ,PasswordMatch() else {showAlert(title: ALERTMESSAGE, message: "Please enter confirm password")
        return true}
       return false
    }
        func PasswordMatch() -> Bool {
            if txtPassword.text! == txtConfirmPassword.text!{
                return true
            }
            else{ showAlert(title: ALERTMESSAGE, message: "Password did not match")  }
            return false
        }
    @IBAction func actionOnResetPassword(_ sender: UIButton) {
       if !isForgotValidation() {
           if  isConnectedToInternet() {
            if self.txtPassword.text! ==  self.txtConfirmPassword.text! {
                callResetPasswordAPI()
            }else{
                showAlert(title: ALERTMESSAGE, message: "Password did not match")
            }
               
            
           } else {
               self.showErrorPopup(message: internetConnetionError, title: alert)
           }
       }
    }
    @IBAction func actionOnResend(_ sender: UIButton) {
        self.callResendOTPAPI()
    }
    func callResetPasswordAPI() {

  //  ShowHud()
ShowHud(view: self.view)
     //let otpCode = txt1.text! + txt2.text! + txt3.text! + txt4.text!
        let parameter: [String: Any] = ["email":MyDefaults().UserEmail!,
                                        "reset_token":txtOTP.text!,
                                        "new_password":txtPassword.text!]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNResetPasswordAPI , parameter: parameter) { (response) in
            debugPrint(response)

        // HideHud()
HideHud(view: self.view)
            if response.count != nil{
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                self.ShowalertWhenPopUpviewController(title:ALERTMESSAGE , message:message)
            }else if status == "4"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)
                
            }
            else
            {
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }}
            else
                {
                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
        }
    }
    
    func callResendOTPAPI() {
        ShowHud(view: self.view)

    //ShowHud()

     //let otpCode = txt1.text! + txt2.text! + txt3.text! + txt4.text!
        let parameter: [String: Any] = ["email":MyDefaults().UserEmail!]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNForgotPasswordAPI , parameter: parameter) { (response) in
            debugPrint(response)

        // HideHud()
            HideHud(view: self.view)
            if response.count != nil{
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }else if status == "1"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)
            } else
            {
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}
            else
            {
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
            
        }
    }
}
extension MNChangePasswordVC: UITextFieldDelegate {
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        if txtPassword == textField {
            guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 12
    }
        if txtConfirmPassword == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 12
        }
        if txtOTP == textField {
            guard let textFieldText = textField.text,
           let rangeOfTextToReplace = Range(range, in: textFieldText) else {
               return false
       }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 4
   }else{
        return true
    }
    }
    
}

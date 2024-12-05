//
//  MNProfilePasswordVC.swift
//  Munka
//
//  Created by Amit on 22/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNProfilePasswordVC: UIViewController {
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var imgRightconstarints: NSLayoutConstraint!
    @IBOutlet weak var imgright: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgRightconstarints.constant = 0
        imgright.isHidden = true
        txtNewPassword.addTarget(self, action: #selector(MNProfilePasswordVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
      let emailPred = NSPredicate(format:"SELF MATCHES %@", regexPassword)
      //return emailPred.evaluate(with: passwordStr)
          
        if  emailPred.evaluate(with: textField.text!){
              imgRightconstarints.constant = 25
              imgright.isHidden = false
          }else{
              imgRightconstarints.constant = 0
              imgright.isHidden = true
          }
    }
//    func checkMaxLength(textField: UITextField!, maxLength: Int) {
//        print(textField.text!.count)
//        if  textField.text!.count > 6 {
//
//        }else{
//            showAlert(title: "Alert", message: "Password should minimum 6 digit.")
//        }
//        //return
//    }
    @IBAction func actionOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOnSubmit(_ sender: Any) {
        if !isValidateForChangePassword() {
            if  isConnectedToInternet() {
                for textField in self.view.subviews where textField is UITextField {
                    textField.resignFirstResponder()
                }
                    self.callServiceForChangePassword()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    func callServiceForChangePassword() {

             //   ShowHud()
ShowHud(view: self.view)
                let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                                "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                                "current_password":txtCurrentPassword.text!,
                                               "new_password":txtNewPassword.text!]
                 debugPrint(parameter)
                 HTTPService.callForPostApi(url:MNGProfileChangePasswordAPI , parameter: parameter) { (response) in
                     debugPrint(response)

                //  HideHud()
HideHud(view: self.view)
                    if response.count != nil{
                    let status = response["status"] as! String
                     let message = response["msg"] as! String
                     if status == "1"
                     {
                        self.navigationController?.popViewController(animated: true)
                     }else if status == "4"
                     {
                        self.autoLogout(title: ALERTMESSAGE, message: message)
                     }
                        else{
                         self.showErrorPopup(message: message, title: ALERTMESSAGE)
                        }}else{
                            self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                        }
                    
                 }
    }
}
extension MNProfilePasswordVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if txtCurrentPassword == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 12
        }
        if txtNewPassword == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            
           
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
//            if self.isValidPass(passwordStr: self.txtNewPassword.text!){
//                           imgRightconstarints.constant = 25
//                            imgright.isHidden = false
//                       }else{
//                           imgRightconstarints.constant = 0
//                            imgright.isHidden = true
//                       }
           
            self.checkRegexValidation(text: txtNewPassword.text!)
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
       
        else{
            return true
        }
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if MyDefaults().swifSavePassword == txtNewPassword.text {
//
//        }else{
//            showAlert(title: "Alert", message: "Current password and ")
//        }
//    }
    
   func isValidateForChangePassword() -> Bool {
    guard let currentPassword = txtCurrentPassword.text , currentPassword != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter current password.")
            return true}
    guard let newPassword = txtNewPassword.text , newPassword != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter new password.")
            return true}
   
        guard let _ = txtNewPassword.text ,isValidatePasswordLength(password: txtNewPassword.text!) else {showAlert(title: ALERTMESSAGE, message: "")
                      return true}
        guard let confirmPassword = txtConfirmPassword.text, confirmPassword != "" else {
        showAlert(title: ALERTMESSAGE, message: "Please enter confirm password.")
        return true}
        guard let _ = txtConfirmPassword.text ,isValidatePasswordLength(password: txtConfirmPassword.text!) else {showAlert(title: ALERTMESSAGE, message: "")
                             return true}
    guard PasswordMatch() == true else {
        showAlert(title: ALERTMESSAGE, message: "Please enter confirm password.")
        return true}
       
        return false
    }
    func PasswordMatch() -> Bool {
        if txtNewPassword.text! == txtConfirmPassword.text!{
            return true
        }
        else{ showAlert(title: ALERTMESSAGE, message: "Password did not match.")  }
        return false
    }
    func isValidPass(passwordStr:String) -> Bool {
        //let emailRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{6,8}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", regexPassword)
        return emailPred.evaluate(with: passwordStr)
    }
    func checkRegexValidation(text:String) {
//    if self.isValidPass(passwordStr: self.txtNewPassword.text!){
//                                   imgRightconstarints.constant = 25
//                                    imgright.isHidden = false
//                               }else{
//                                   imgRightconstarints.constant = 0
//                                    imgright.isHidden = true
//                               }
//    }
    let emailPred = NSPredicate(format:"SELF MATCHES %@", regexPassword)
    //return emailPred.evaluate(with: passwordStr)
        
        if  emailPred.evaluate(with: text){
            imgRightconstarints.constant = 25
            imgright.isHidden = false
        }else{
            imgRightconstarints.constant = 0
            imgright.isHidden = true
        }
}
}


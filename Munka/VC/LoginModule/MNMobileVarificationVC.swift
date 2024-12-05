//
//  MNMobileVarificationVC.swift
//  Munka
//
//  Created by Amit on 12/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNMobileVarificationVC: UIViewController,UITextFieldDelegate {
       @IBOutlet weak var txt1: UITextField!
       @IBOutlet weak var txt2: UITextField!
       @IBOutlet weak var txt3: UITextField!
       @IBOutlet weak var txt4: UITextField!
       @IBOutlet weak var lblMobileNumber: UILabel!
       @IBOutlet weak var txtNewMobile: UITextField!
       @IBOutlet weak var btnMobileNumber: UIButton!
    
    var mobileButtonTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileButtonTitle = "Change Mobile Number"
        self.txt1.addBottomBorder()
        self.txt2.addBottomBorder()
        self.txt3.addBottomBorder()
        self.txt4.addBottomBorder()
        txtNewMobile.backgroundColor = .clear
      // CGcolorString
        txt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txt4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
        
        if MyDefaults().swifSignUpMobileNumber?.isEmpty ?? true {
            print("str is nil or empty")
        }else{
            
            let c_Code =  MyDefaults().swifCountryCode ?? "+1"
            let mobile =  MyDefaults().swifSignUpMobileNumber ?? ""
             print("mobile : \(mobile), ccode: \(c_Code)")
            lblMobileNumber.text = "\(c_Code)"
            txtNewMobile.text = mobile
//            lblMobileNumber.text = "+ 1 " + MyDefaults().swifSignUpMobileNumber!
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtNewMobile == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 10
        }else{
            return true
        }
    }
    
    @IBAction func actionOnResentOTP(_ sender: UIButton) {
            if  isConnectedToInternet() {
                callResendOTPAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOnVerify(_ sender: UIButton) {
    if !isMobileValidation() {
        if  isConnectedToInternet() {
            for textField in self.view.subviews where textField is UITextField {
                textField.resignFirstResponder()
            }
                callServiceForResendOTPFromMobile()
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    }
    
    @IBAction func actionChangeMobileNumber(_ sender: UIButton) {
        if !checkMobileValidation() {
            if btnMobileNumber.titleLabel?.text == "Change Mobile Number"{
                txtNewMobile.isEnabled = true
                txtNewMobile.text = ""
                txtNewMobile.becomeFirstResponder()
                btnMobileNumber.setTitle("Save", for: .normal)
            }else if btnMobileNumber.titleLabel?.text == "Save"{
                
                callChangeMobileAPI()
            }
        }
        
    }
    
    func isMobileValidation() -> Bool {
        guard let txt1 = txt1.text , txt1 != ""
            else {showAlert(title:ALERTMESSAGE, message: "Please enter OTP varification code")
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
    
    func checkMobileValidation() -> Bool {
        guard let mobileNumber = txtNewMobile.text, mobileNumber != "",isValidateMobileNumberLength(password: txtNewMobile.text) else {
           // showAlert(title: ALERTMESSAGE, message: "Please enter mobile number.")
            //self.txtMobileNumberHight.constant = 40
//            txtNewMobile.showError(message: "Please enter mobile number.")
            return true
        }
        return false
    }
    
    func callServiceForResendOTPFromMobile() {

      // ShowHud()
        ShowHud(view: self.view)

        let otpCode = txt1.text! + txt2.text! + txt3.text! + txt4.text!
        let parameter: [String: Any] = ["email":MyDefaults().UserEmail!,
                                        "type":"Mobile",
                                        "verification_code":otpCode]
           debugPrint(parameter)
           HTTPService.callForPostApi(url:MNAccountVarificationAPI , parameter: parameter) { (response) in
               debugPrint(response)

          //  HideHud()
            HideHud(view: self.view)

            if response.count != nil{
            let status = response["status"] as! String
               let message = response["msg"] as! String
               if status == "1"
               {
                self.pushAccountVarification()
                 self.showErrorPopup(message: message, title: ALERTMESSAGE)
               } else if status == "4"
               {
                self.autoLogout(title: ALERTMESSAGE, message: message)
               }
               else
               {
                   self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }} else
            {
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
               
           }
       }
    func callResendOTPAPI() {

//    ShowHud()
ShowHud(view: self.view)
     //let otpCode = txt1.text! + txt2.text! + txt3.text! + txt4.text!
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
            "type":"Mobile"]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNResendOtpAPI , parameter: parameter) { (response) in
            debugPrint(response)

         //HideHud()
HideHud(view: self.view)
            if response.count != nil{
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                
                //self.navigationController?.popToRootViewController(animated: true)
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }else if status == "4"{
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
    
    func callChangeMobileAPI() {
        //  ShowHud()
        ShowHud(view: self.view)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "","mobile":txtNewMobile.text ?? "","type":"Mobile"]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNChangeMobileorEmailAPI , parameter: parameter) { (response) in
            debugPrint(response)
            //  HideHud()
            HideHud(view: self.view)
            if response.count != nil{
                print(response)
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    self.txtNewMobile.isEnabled = false
        //            txtNewMobile.text = ""
                    self.txtNewMobile.resignFirstResponder()
                    self.btnMobileNumber.setTitle("Change Mobile Number", for: .normal)
                    self.showAlert(title: "Munka", message: message)
                }else if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else if status == "2"
                {
                    //self.autoLogout(title: ALERTMESSAGE, message: message)
                }else if status == "0"
                {
                    //   self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                
                
            }else
            {
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
            
        }
    }
    
    func pushAccountVarification() {
        let email = self.storyboard?.instantiateViewController(withIdentifier: "MNEmailVerificationVC") as! MNEmailVerificationVC
        self.navigationController?.pushViewController(email, animated: true)
    }
}
//
//extension MNMobileVarificationVC: UITextFieldDelegate{
//    
//
//    
//}
//


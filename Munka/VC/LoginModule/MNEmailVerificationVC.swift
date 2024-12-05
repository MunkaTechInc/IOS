//
//  MNEmailVerificationVC.swift
//  Munka
//
//  Created by Amit on 13/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import Stripe

class MNEmailVerificationVC: UIViewController,UITextFieldDelegate {
       @IBOutlet weak var txt1: UITextField!
       @IBOutlet weak var txt2: UITextField!
       @IBOutlet weak var txt3: UITextField!
       @IBOutlet weak var txt4: UITextField!
       @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnEmail: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
//        lblEmail.text = MyDefaults().UserEmail!
        txtEmail.text = MyDefaults().UserEmail!
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
        if txtEmail == textField {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 40
        }else{
            return true
        }
    }
    
    @IBAction func actionOnResentOTP(_ sender: UIButton) {
        self.callResendOTPAPI()
    }
    @IBAction func actionOnback(_ sender: UIButton) {
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
        if !checkEmailValidation() {
            if btnEmail.titleLabel?.text == "Change Email Address"{
                txtEmail.isEnabled = true
                txtEmail.text = ""
                txtEmail.becomeFirstResponder()
                btnEmail.setTitle("Save", for: .normal)
            }else if btnEmail.titleLabel?.text == "Save"{
                
                callChangeEmailAPI()
            }
        }
        
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
    
    func checkEmailValidation() -> Bool {
        guard let userEmail = txtEmail.text , userEmail != ""  ,isValidEmail(email: txtEmail.text) else {
            
//            txtEmail.showError(message: "Please enter valid email.")
            //showAlert(title: ALERTMESSAGE, message: "Please enter valid email")
            return true}
        return false
    }
    
    func callServiceForResendOTPFromMobile() {

     // ShowHud()
        ShowHud(view: self.view)
        let otpCode = txt1.text! + txt2.text! + txt3.text! + txt4.text!
        let parameter: [String: Any] = ["email":MyDefaults().UserEmail!,
                                        "type":"Email",
                                        "verification_code":otpCode]
           debugPrint(parameter)
           HTTPService.callForPostApi(url:MNAccountVarificationAPI , parameter: parameter) { (response) in
               debugPrint(response)

           // HideHud()
            HideHud(view: self.view)

            if response.count != nil {
            let status = response["status"] as! String
               let message = response["msg"] as! String
               if status == "1"
                {
                   let responseData = response["details"] as! [String: Any]
                   MyDefaults().UserId = responseData["user_id"] as? String
                   MyDefaults().UDeviceToken = responseData["mobile_auth_token"] as? String
                   
                   MyDefaults().swiftUserData = responseData as NSDictionary
                   MyDefaults().LoginStatus = "1"
                   UserDefaults.standard.set(true, forKey: "isLogIn")
                   UserDefaults.standard.synchronize()
                   
                   self.createStripeCustomer(message: message)
                   
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
    
    func callResendOTPAPI() {
        
        //    ShowHud()
        ShowHud(view: self.view)
        //let otpCode = txt1.text! + txt2.text! + txt3.text! + txt4.text!
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "type":"Email"]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNResendOtpAPI , parameter: parameter) { (response) in
            debugPrint(response)
            
            //  HideHud()
            HideHud(view: self.view)
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1" && message == "Email verification OTP resent on your registered email address."
                {
                    
                    //self.navigationController?.popToRootViewController(animated: true)
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }else if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }else
                {
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}else
            {
                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
            
        }
    }
    
    func callChangeEmailAPI() {
        //  ShowHud()
        ShowHud(view: self.view)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "","email":txtEmail.text ?? "","type":"Email"]
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
                    self.txtEmail.isEnabled = false
        //            txtNewMobile.text = ""
                    self.txtEmail.resignFirstResponder()
                    self.btnEmail.setTitle("Change Email Address", for: .normal)
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
    
    func createStripeCustomer(message: String){
        let fistName = MyDefaults().swiftUserData["first_name"] as? String
        let lastName = MyDefaults().swiftUserData["last_name"] as? String
        let fullname = "\(fistName!)" + " " + "\(lastName!)"
        let name = fullname.replacingOccurrences(of: " ", with: "%20")
        let fullEmail = MyDefaults().UserEmail!
        let email = fullEmail.replacingOccurrences(of: "@", with: "%40")
        
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "description=\(name)&email=\(email)"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api.stripe.com/v1/customers")!,timeoutInterval: Double.infinity)
//        request.addValue("Bearer sk_test_51HCXi0AWuQkXhibTKF0FM6mGjonhmQyMuLzR14N5R6DVazbTpkq7a2D6TY9BcAnlx3ZaqBFeSoWIDBi4rTaDoT5Q00v781QCpe", forHTTPHeaderField: "Authorization")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("__stripe_orig_props=%7B%22referrer%22%3A%22%22%2C%22landing%22%3A%22https%3A%2F%2Fstripe.com%2Fdocs%2Fapi%2Fpayment_methods%22%7D", forHTTPHeaderField: "Cookie")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            if (error != nil) {
                print(error)
            } else {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                    print(json)
                    if let id = json!["id"] as? String{
                        print("createStripeCustomer api customer id :", id)
                        MyDefaults().StripeCustomerId = id
                        DispatchQueue.main.async {
                            self.callServiceForSaveStripeCustomerId(stripeCustomerId: id)
                        }
                    }
                }
                catch {
                    self.showAlert(title: "", message: "\(error.localizedDescription)")
                    print(error)
                }
            }
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    
    func callServiceForSaveStripeCustomerId(stripeCustomerId: String) {
        
        ShowHud(view: self.view)
        print(MyDefaults().UserId ?? "")
        
        let parameter: [String: Any] = ["userId":MyDefaults().UserId ?? "",
                                        "stripeCustomerId": stripeCustomerId ]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNSaveStripeCustomerIdAPI , parameter: parameter) { (response) in
            debugPrint(response)
            
            //  HideHud()
            HideHud(view: self.view)
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1" {
                    print("callServiceForSaveStripeCustomerId API response = ",message)
                    DispatchQueue.main.async {
                        if let tabbar = (storyBoard.tabbar.instantiateViewController(withIdentifier: "tabbar") as? MainTabbarVC) {
                            self.navigationController?.isNavigationBarHidden = true
                            tabbar.selectedIndex = 2
                            self.navigationController?.pushViewController(tabbar, animated: true)
                            self.showErrorPopup(message: message, title: ALERTMESSAGE)
                        }
                    }
                }else  if status == "4"{
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }else{
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }
            }else{
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
}
//
//extension MNEmailVerificationVC: UITextFieldDelegate{
//    
//
//    
//}

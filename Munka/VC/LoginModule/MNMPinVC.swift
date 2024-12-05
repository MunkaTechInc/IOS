//
//  MNMPinVC.swift
//  Munka
//
//  Created by Amit on 25/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNMPinVC: UIViewController,UITextFieldDelegate,UITabBarDelegate {
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    @IBOutlet weak var lblName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt1.addBottomBorder()
        self.txt2.addBottomBorder()
        self.txt3.addBottomBorder()
        self.txt4.addBottomBorder()
        // Do any additional setup after loading the view.
       // self.title = "mPin"
        let firstName = MyDefaults().swiftUserData["first_name"] as! String
        let lastName = MyDefaults().swiftUserData["last_name"] as! String
    lblName.text = "Welcome Back " + firstName + " " + " " + lastName + "!"
    txt1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    txt2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    txt3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    txt4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
       //self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
        txt1.text = ""
        txt2.text = ""
        txt3.text = ""
        txt4.text = ""
    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
    @IBAction func textFieldDidChange(_ sender: UITextField) {
  
        let text = sender.text
        if  text?.count == 1 {
            switch sender{
            case txt1:
                txt2.becomeFirstResponder()
            case txt2:
                txt3.becomeFirstResponder()
            case txt3:
                txt4.becomeFirstResponder()
            case txt4:
                txt4.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch sender{
            case txt1:
                txt1.becomeFirstResponder()
            case txt2:
                txt1.becomeFirstResponder()
            case txt3:
                txt2.becomeFirstResponder()
            case txt4:
                txt3.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    
    }
//    @IBAction func textFieldDidChange(_ sender: UITextField) {
//
//           let text = sender.text
//           if  text?.count == 1 {
//               switch sender{
//               case txt1:
//                   txt2.becomeFirstResponder()
//               case txt2:
//                   txt3.becomeFirstResponder()
//               case txt3:
//                   txt4.becomeFirstResponder()
//               case txt4:
//                   txt4.resignFirstResponder()
//               default:
//                   break
//               }
//           }
//           if  text?.count == 0 {
//               switch sender{
//               case txt1:
//                   txt1.becomeFirstResponder()
//               case txt2:
//                   txt1.becomeFirstResponder()
//               case txt3:
//                   txt2.becomeFirstResponder()
//               case txt4:
//                   txt3.becomeFirstResponder()
//               default:
//                   break
//               }
//           }
//           else{
//
//           }
//       }
//

//    func textFieldDidBeginEditing(_ textField: UITextField) {
//           textField.text = ""
//       }
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//          print("true")
//           return true
//       }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if textField.text?.count == 0 && string == " "
           {
               return false
           }
           
           if textField == self.txt1 || textField == self.txt2 || textField == self.txt3 || textField == self.txt4
           {
               return Global.checkTextFieldCount(textField, Range: range, replacementString: string, MaxCount: 1)
           }
           return true
       }

    func callcallServicemPinAPI() {

   // ShowHud()
        HideHud(view: self.view)
        let otpCode = txt1.text! + txt2.text! + txt3.text! + txt4.text!
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                        "access_pin":otpCode]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNPinverificationAPI , parameter: parameter) { (response) in
            debugPrint(response)

         //HideHud()
            HideHud(view: self.view)

            if response.count != nil {
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                MyDefaults().LoginStatus = "1"
                    if let tabbar = (storyBoard.tabbar.instantiateViewController(withIdentifier: "tabbar") as? MainTabbarVC) {
                    self.navigationController?.pushViewController(tabbar, animated: true)
                    self.navigationController?.navigationBar.isHidden = true
                    tabbar.selectedIndex = 2
                } else if status == "4"
                    {
                        self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                       
                    }
                else
                    {
                        self.showErrorPopup(message: message, title: ALERTMESSAGE)
                    }
            }else{
                 self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
                
            
        }
    }
    func functionValidation()  {
        if !isMobileValidation() {
            if  isConnectedToInternet() {
                for textField in self.view.subviews where textField is UITextField {
                    textField.resignFirstResponder()
                }
                    callcallServicemPinAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
     @IBAction func actionOnForgotPin(_ sender: UIButton) {
        let details = storyBoard.Main.instantiateViewController(withIdentifier: "MNForgetMpinVC") as! MNForgetMpinVC
         self.navigationController?.pushViewController(details, animated: true)
    }
    @IBAction func actionOnDone(_ sender: UIButton) {
        self.functionValidation()
        
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
    func callForgotPinAPI() {

       //ShowHud()
ShowHud(view: self.view)
        //let otpCode = txt1.text! + txt2.text! + txt3.text! + txt4.text!
           let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
               "type":"Email"]
           debugPrint(parameter)
           HTTPService.callForPostApi(url:MNForgotPinAPI , parameter: parameter) { (response) in
               debugPrint(response)

           // HideHud()
HideHud(view: self.view)
            if response.count != nil{
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
}

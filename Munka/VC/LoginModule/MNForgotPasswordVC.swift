//
//  MNForgotPasswordVC.swift
//  Munka
//
//  Created by Amit on 14/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNForgotPasswordVC: UIViewController {
@IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    @IBAction func actionOnSend(_ sender: UIButton) {
          if !isForgotValidation() {
              if  isConnectedToInternet() {
                  for textField in self.view.subviews where textField is UITextField {
                      textField.resignFirstResponder()
                  }
                  callForgotpasswordAPI()
              } else {
                  self.showErrorPopup(message: internetConnetionError, title: alert)
              }
          }
       }
    func isForgotValidation() -> Bool {
        guard let email = txtEmail.text , email != ""
            else {showAlert(title: ALERTMESSAGE, message: "Please enter email address.")
                return true}
        
       
        return false
    }
    func callForgotpasswordAPI() {

   // ShowHud()
        ShowHud(view: self.view)
     //let otpCode = txt1.text! + txt2.text! + txt3.text! + txt4.text!
        let parameter: [String: Any] = ["email":txtEmail.text!]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNForgotPasswordAPI , parameter: parameter) { (response) in
            debugPrint(response)

        // HideHud()
            HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
               self.pushResetPassword()
                MyDefaults().UserEmail = self.txtEmail.text!
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
    func pushResetPassword() {
         let change = self.storyboard?.instantiateViewController(withIdentifier: "MNChangePasswordVC") as! MNChangePasswordVC
               self.navigationController?.pushViewController(change, animated: true)
    }
}

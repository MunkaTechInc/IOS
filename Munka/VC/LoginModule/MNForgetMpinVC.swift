//
//  MNForgetMpinVC.swift
//  Munka
//
//  Created by Amit on 30/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNForgetMpinVC: UIViewController {

   @IBOutlet weak var txtEmail: UITextField!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "mPin"
            // Do any additional setup after loading the view.
        }
        @IBAction func actionOnSend(_ sender: UIButton) {
              if !isForgotmPinValidation() {
                  if  isConnectedToInternet() {
                      for textField in self.view.subviews where textField is UITextField {
                          textField.resignFirstResponder()
                      }
                      callForgotmPinpasswordAPI()
                  } else {
                      self.showErrorPopup(message: internetConnetionError, title: ALERTMESSAGE)
                  }
              }
           }
        func isForgotmPinValidation() -> Bool {
            guard let email = txtEmail.text , email != ""
                else {showAlert(title: ALERTMESSAGE, message: "Please enter email address.")
                    return true}
            
           
            return false
        }
     @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
        func callForgotmPinpasswordAPI() {

       // ShowHud()
            ShowHud(view: self.view)
         //let otpCode = txt1.text! + txt2.text! + txt3.text! + txt4.text!
            let parameter: [String: Any] = ["email":txtEmail.text!]
            debugPrint(parameter)
            HTTPService.callForPostApi(url:MNForgotPinAPI , parameter: parameter) { (response) in
                debugPrint(response)


            // HideHud()
                HideHud(view: self.view)
                if response.count != nil{
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                   let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                    
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alertController, animated: true, completion: nil)
                    
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

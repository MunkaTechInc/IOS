//
//  MNChangePinVC.swift
//  Munka
//
//  Created by Amit on 23/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
class MNChangePinVC: UIViewController {
    @IBOutlet weak var txtCurrentPin:UITextField!
    @IBOutlet weak var txtNewAccessPin:UITextField!
    @IBOutlet weak var txtConfirmationPin:UITextField!
    var objIndividual = [ModelFavoritesJobDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       }
    
     @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
     }
    @IBAction func actionOnSubmit(_ sender: UIButton) {
       if !isLoginValidation() {
           if  isConnectedToInternet() {
               for textField in self.view.subviews where textField is UITextField {
                   textField.resignFirstResponder()
               }
            self.callServiceForchangePin()
           } else {
               self.showErrorPopup(message: internetConnetionError, title: alert)
           }
       }
       }
    func isLoginValidation() -> Bool {
           guard let currntPin = txtCurrentPin.text , currntPin != ""
               else {showAlert(title: ALERTMESSAGE, message: "Please enter current Pin.")
                   return true}
           guard let newPin = txtNewAccessPin.text , newPin != ""
                      else {showAlert(title: ALERTMESSAGE, message: "Please enter New pin.")
                          return true}
        guard let confimPin = txtConfirmationPin.text , confimPin != "" ,isValidatePasswordMatch(confirmPassword: txtConfirmationPin.text!, password: txtNewAccessPin.text!)
        else {showAlert(title: ALERTMESSAGE, message: "Please enter confirm pin.")
            return true}
           return false
       }
    
    func callServiceForchangePin() {
      // objIndividual = [ModelFavoritesJobDetail]()

       // ShowHud()
ShowHud(view: self.view)
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "current_pin":txtCurrentPin.text!,
                                      "new_pin":txtNewAccessPin.text!]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNGetChangeAccessPinAPI , parameter: parameter) { (response) in
             debugPrint(response)

        //  HideHud()
            HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
               // let response = ModelFavoritesJobs.init(fromDictionary: response as! [String : Any])
//                self.navigationController?.popViewController(animated: true)
//                self.showAlert(title: message, message: ALERTMESSAGE)
                
                self.alertViewForBacktoController(title: ALERTMESSAGE, message: message)
                }else if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
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
}

extension MNChangePinVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if txtCurrentPin == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 4
        }
        if txtNewAccessPin == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 4
        }
            if txtConfirmationPin == textField {
            guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            //return NSPredicate(format: "SELF MATCHES %@", regexPassword).evaluate(with: string)
            return count <= 4
            }
                   
        else{
            return true
        }
    }
}

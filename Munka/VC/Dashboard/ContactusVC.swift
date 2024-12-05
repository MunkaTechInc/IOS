//
//  ContactusVC.swift
//  Munka
//
//  Created by Amit on 19/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class ContactusVC: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtView: UITextView!
    let placeholderText = "Message..."
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        txtView.text = placeholderText
        txtView.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
        
        self.txtName.text = MyDefaults().swiftUserData["first_name"] as? String
        self.txtEmail.text = MyDefaults().swiftUserData["email"] as? String
        self.txtMobile.text = MyDefaults().swiftUserData["mobile"] as? String
    }
    
    @IBAction func actionOnback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOnSubmit(_ sender: UIButton) {
        if !iscontactUsValidation() {
            if  isConnectedToInternet() {
                self.callServiceForContactAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    func iscontactUsValidation() -> Bool {
        guard let name = txtName.text , name != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter name.")
            return true}
        guard let email = txtEmail.text , email != ""  ,isValidEmail(email: txtEmail.text) else {showAlert(title: ALERTMESSAGE, message: "Please enter valid email")
            return true}
        
        guard let MobileNumber = txtMobile.text , MobileNumber != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter mobile number.")
            return true}
        guard let subject = txtSubject.text , subject != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter subject.")
            return true}
        
        guard let message = txtView.text , message != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter message.")
            return true}
        
        return false
    }
    func callServiceForContactAPI() {
        
        
        //  ShowHud()
        ShowHud(view: self.view)
        print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                        "name":txtName.text!,
                                        "email":txtEmail.text!,
                                        "contact_no":txtMobile.text!,
                                        "subject":txtSubject.text!,
                                        "message":txtView.text!]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNContactAPI , parameter: parameter) { (response) in
            debugPrint(response)
            
            //  HideHud()
            HideHud(view: self.view)
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    //            let response = ModelindividualPaymentDetails.init(fromDictionary: response as! [String : Any])
                    //                self.details = response.details
                    //                self.setUI()
                    self.navigationController?.popViewController(animated: true)
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                } else  if status == "4"
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
extension ContactusVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == placeholderText {
            textView.text = ""
        }
        textView.textColor = .black
        return textView.text.count + (text.count - range.length) <= 150
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            // txtView.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
        }
    }
    
}

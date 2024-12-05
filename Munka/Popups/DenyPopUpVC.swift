//
//  DenyPopUpVC.swift
//  Munka
//
//  Created by Amit on 03/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
protocol GetUserDeny {
    func delegateForUserDeny()
}
let placeHolder = "Change reason to explain…"
class DenyPopUpVC: UIViewController {
    @IBOutlet weak var txtView:UITextView!
    var applyedBy = ""
    var jobId = ""
   var delagate: GetUserDeny!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView.text = placeHolder
        txtView.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
        // Do any additional setup after loading the view.
    }
    @IBAction func actionOnSubmit(_ sender: UIButton) {
        if !isActionValidation() {
            if  isConnectedToInternet() {
                self.callServiceForSaveJobAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    func isActionValidation() -> Bool {
        guard let email = txtView.text , email != placeHolder
            else {showAlert(title: ALERTMESSAGE, message: "Please enter cancel reason.")
                return true}
        return false
    }
    func callServiceForSaveJobAPI() {
         

        //   ShowHud()
ShowHud(view: self.view)
          print(MyDefaults().UserId ?? "" )
           let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                         "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                         "applied_by":applyedBy,
                                         "job_id":jobId,
                                         "states":"Rejected",
                                         "rejected_reason":txtView.text!]
            debugPrint(parameter)
            HTTPService.callForPostApi(url:MNJobRequestActionAPI , parameter: parameter) { (response) in
                debugPrint(response)

           //  HideHud()
HideHud(view: self.view)
                if response.count != nil{
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
//                   let response = ModelIndividualHome.init(fromDictionary: response as! [String : Any])
                     if self.delagate != nil {
                         self.dismiss(animated: true, completion: nil)
                         self.delagate.delegateForUserDeny()
                         }
                    
                     self.showErrorPopup(message: message, title: ALERTMESSAGE)
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
    
    @IBAction func actionOnackground(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension DenyPopUpVC:UITextViewDelegate,UITextFieldDelegate{
func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.hexStringToUIColor(hex: "B1B1B1") {
        textView.text = nil
        textView.textColor = UIColor.hexStringToUIColor(hex: "7E8290")
    }
}
func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
        textView.text = placeHolder
        textView.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
    }
}
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 150
    }
}

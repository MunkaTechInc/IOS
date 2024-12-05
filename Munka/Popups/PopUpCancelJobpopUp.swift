//
//  PopUpCancelJobpopUp.swift
//  
//
//  Created by Amit on 22/01/20.
//

import UIKit

protocol GetCancelJob {
    func delegateForCancelJob()
}

class PopUpCancelJobpopUp: UIViewController {
    var delagate: GetCancelJob!
    var contractId = ""
    var jobId = ""
    var postedBy = ""
    let placeHolder = "Change reason to explain…"
     @IBOutlet weak var txtView:UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView.text = placeHolder
        txtView.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
        // Do any additional setup after loading the view.
    }
     @IBAction func actionOnSubmit(_ sender: UIButton) {
            if !isActionValidation() {
                if  isConnectedToInternet() {
                    self.callServiceforRejected()
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

    func callServiceforRejected() {


       // ShowHud()
ShowHud(view: self.view)
               print(MyDefaults().UserId)
               let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                             "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                             "job_id":jobId,
                                             "contract_id":contractId,
                                             "status":"Rejected",
                                             "posted_by":postedBy,
                                             "rejected_reason":txtView.text!]
                debugPrint(parameter)
                HTTPService.callForPostApi(url:MNContractActionAPI , parameter: parameter) { (response) in
                    debugPrint(response)

                // HideHud()
HideHud(view: self.view)
                   if response.count != nil{
                   let status = response["status"] as! String
                    let message = response["msg"] as! String
                    if status == "1"
                    {
                     //  self.navigationController?.popViewController(animated: true)
                    
                       
                   if self.delagate != nil {
                   self.dismiss(animated: true, completion: nil)
                   self.showErrorPopup(message: message, title: ALERTMESSAGE)
                   self.delagate.delegateForCancelJob()
                   }
                    
                    
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
extension PopUpCancelJobpopUp:UITextViewDelegate,UITextFieldDelegate{
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

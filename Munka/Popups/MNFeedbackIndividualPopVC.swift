//
//  MNFeedbackIndividualPopVC.swift
//  Munka
//
//  Created by Amit on 16/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNFeedbackIndividualPopVC: UIViewController {
    @IBOutlet weak var imgView : UIImageView!
       @IBOutlet weak var txtViewfeedback : UITextView!
       @IBOutlet weak var txtViewPrivatefeedback : UITextView!
       @IBOutlet weak var lblName : UILabel!
       var strfeedback = ""
       var profileImage = ""
        var name = ""
        var jobId = ""
        var postedBy = ""
        var experience = ""
        var isPrivate = ""
        var strRating = ""
        var arraiveOnTime = ""
        var recommend = ""
        var contractId = ""
      // var recommned = ""
        var hireAgain = ""
    
    var strPrivate = ""
    
    var isPrivatefeedback = false
    
        @IBOutlet var floatRatingView: FloatRatingView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    self.imgView.sd_setImage(with: URL(string:img_BASE_URL + profileImage), placeholderImage:#imageLiteral(resourceName: "phl_square_profile"))
           // Do any additional setup after loading the view.
           txtViewfeedback.text = "Write Feedback..."
           txtViewPrivatefeedback.text = "Write Private Feedback..."
           txtViewfeedback.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
           txtViewPrivatefeedback.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
           isPrivate = "0"
           floatRatingView.delegate = self
           floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
           floatRatingView.type = .halfRatings
           lblName.text = name
        
        txtViewPrivatefeedback.isEditable = false
    
    }
     @IBAction func actionOnBack(_ sender: UIButton) {
     self.navigationController?.popViewController(animated: true)
     }
        @IBAction func actionOnPrivate(_ sender: UIButton) {
           // strfeedback = "Yes"
            if sender.isSelected {
                sender.isSelected = false
                isPrivate = "0"
                isPrivatefeedback = false
                txtViewPrivatefeedback.isEditable = false
                txtViewPrivatefeedback.text = "Write Private Feedback..."
                txtViewPrivatefeedback.resignFirstResponder()
            }else {
                sender.isSelected = true
                isPrivatefeedback = true
                txtViewPrivatefeedback.text = ""
                 isPrivate = "1"
                txtViewPrivatefeedback.isEditable = true
                txtViewPrivatefeedback.becomeFirstResponder()
               }
        }
        @IBAction func actionOnSubmit(_ sender: UIButton) {
         
            if !isValidation() {
                if  isConnectedToInternet() {
                    if isPrivate == "1" {
                        if self.txtViewPrivatefeedback.text! == "Write Private Feedback..." {
                            showAlert(title: ALERTMESSAGE, message: "Write Private Feedback.")
                        }else{
                            self.callServiceForAddReviewRatingAPI()
                            print("Yes")
                        }
                    }else{
                            self.callServiceForAddReviewRatingAPI()
                          print("No")
                    }
            } else {
                    self.showErrorPopup(message: internetConnetionError, title: alert)
                }
            }
        }
      func callServiceForAddReviewRatingAPI() {

        //ShowHud()
ShowHud(view: self.view)
           print(MyDefaults().UserId ?? "")
            let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                          "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                          "job_id":jobId,
                                         "reciver_id":postedBy,
                                        "rating":strRating,
                                        "is_private":isPrivate,
                                        "private_review":txtViewPrivatefeedback.text!,
                                        "arrive_on_time":arraiveOnTime,
                                        "review":txtViewfeedback.text!,
                                        "recommend":recommend,
                                        "hire_again":hireAgain]
             debugPrint(parameter)
             HTTPService.callForPostApi(url:MNAddReviewRatingAPI , parameter: parameter) { (response) in
                 debugPrint(response)

             // HideHud()
                HideHud(view: self.view)
             
                if response.count != nil {
                let status = response["status"] as! String
                 let message = response["msg"] as! String
                 if status == "1"
                 {

                  //  print(self.navigationController?.viewControllers)
                    self.navigationController?.backToViewController(viewController: MNProgressVC.self)
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                    
                } else if status == "4"
                {
                    self.autoLogout(title: message, message: ALERTMESSAGE)
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
        func isValidation() -> Bool {
           
            print(strRating)
            guard strRating.count > 0 else {showAlert(title: ALERTMESSAGE, message: "Please give us ratings.")
                      return true}
            guard let txtfeedBack = txtViewfeedback.text , txtfeedBack != "Write Feedback..."
                           else {showAlert(title: ALERTMESSAGE, message: "Please write feedback.")
                               return true}
            return false
        }
    }
    extension MNFeedbackIndividualPopVC:UITextViewDelegate,UITextFieldDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.hexStringToUIColor(hex: "B1B1B1") {
            textView.text = nil
            textView.textColor = UIColor.hexStringToUIColor(hex: "7E8290")
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.txtViewfeedback {
            if textView.text.isEmpty {
                textView.text = "Write Feedback..."
                textView.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
            }
        }else{
            if textView.text.isEmpty {
            textView.text = "Write Private Feedback..."
            textView.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
        }
        }
    }
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return textView.text.count + (text.count - range.length) <= 150
        }
    }
    extension MNFeedbackIndividualPopVC: FloatRatingViewDelegate {

        // MARK: FloatRatingViewDelegate
        func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
            strRating = String(format: "%.2f", self.floatRatingView.rating)
        }
        func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
            
            if strRating == "0.00" {
                strRating = ""
            }else{
                strRating = String(format: "%.2f", self.floatRatingView.rating)
            }
        }
        
    }


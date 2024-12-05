//
//  MNEditProfileVC.swift
//  Munka
//
//  Created by Amit on 27/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNEditProfileVC: UIViewController {
    @IBOutlet weak var txtName: UITextField!
     @IBOutlet weak var txtLastName: UITextField!
     @IBOutlet weak var txtMobileNumber: UITextField!
     @IBOutlet weak var txtAddress: UITextField!
     @IBOutlet weak var txtPaypalId: UITextField!
    @IBOutlet weak var txtAboutMe: UITextField!
     @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtBusinessName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
   
   // var uploadImages : UIImage!
    var viewDetails : ModelFreelancerProfileDetail!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   if  isConnectedToInternet() {
           self.callServiceForViewProfileAPI()
       } else {
           self.showErrorPopup(message: internetConnetionError, title: alert)
   }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
    }
    @IBAction func actionOnBack(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
       }
    @IBAction func actionOnSubmit(_ sender: UIButton) {
         if !checkEditprofileValidationOnSubmit() {
              if  isConnectedToInternet() {
                  for textField in self.view.subviews where textField is UITextField {
                      textField.resignFirstResponder()
                  }
                   submitEditProfile()
              } else {
                  self.showErrorPopup(message: internetConnetionError, title: alert)
              }
          }
       }
    @IBAction func actionOnUploadPhoto(_ sender: UIButton) {
        self.view.endEditing(true)
        ImagePickerManager().pickImage(self){ image in
        self.imgProfile.contentMode = .scaleToFill
        self.imgProfile.image = image
        //self.uploadImages = image
        }
    }
   
    func callServiceForViewProfileAPI() {
        // let intCompletJob:Int = 0
        
        // ShowHud()
        ShowHud(view: self.view)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                        "other_user_id":MyDefaults().UserId ?? ""]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNGetProfileAPI , parameter: parameter) { (response) in
            debugPrint(response)
            //  HideHud()hide
            HideHud(view: self.view)
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                let response = ModelFreelancerProfile.init(fromDictionary: response as! [String : Any])
                self.viewDetails = response.details
                self.setUI()
            }
            else
            {
                self.showErrorPopup(message: message, title: alert)
            }
            
        }
    }
    func setUI() {
        self.imgProfile.sd_setImage(with: URL(string:img_BASE_URL + self.viewDetails.profilePic), placeholderImage:#imageLiteral(resourceName: "ic_individual"))
        
        txtName.text! =  self.viewDetails.firstName
        txtLastName.text! =  self.viewDetails.lastName
        txtMobileNumber.text! =  self.viewDetails.mobile
        txtAddress.text! =  self.viewDetails.address
         txtPaypalId.text! =  self.viewDetails.paypalid
         txtAboutMe.text! =  self.viewDetails.aboutUs
        txtBusinessName.text! = self.viewDetails.businessName
        txtEmail.text! = self.viewDetails.email
    }
    func checkEditprofileValidationOnSubmit() -> Bool {

//        guard self.uploadImages != nil
//             else {showAlert(title: ALERTMESSAGE, message: "Please select about us.")
//                              return true}
        guard let name = txtName.text , name != ""
      else {showAlert(title: ALERTMESSAGE, message: "Please enter name.")
                        return true}
      guard let lastName = txtLastName.text , lastName != ""
      else {showAlert(title: ALERTMESSAGE, message: "Please enter last name.")
                        return true}
        guard let mobileNumber = txtMobileNumber.text , mobileNumber != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter mobile number.")
                         return true}
//        guard let paypal = txtPaypalId.text , paypal != ""
//               else {showAlert(title: ALERTMESSAGE, message: "Please enter paypal id.")
//                                return true}
        guard let address = txtAddress.text , address != ""
               else {showAlert(title: ALERTMESSAGE, message: "Please enter address.")
                         return true}
        guard let aboutMe = txtAddress.text , aboutMe != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter about us.")
                         return true}
        return false
           
       }
    func submitEditProfile()  {
        
        ShowHud(view: self.view)//  ShowHud()
        
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                        "first_name":txtName.text!,
                                        "last_name":txtLastName.text!,
                                        "mobile":txtMobileNumber.text!,
                                        "address":txtAddress.text!,
                                        "paypal_id":txtPaypalId.text!,
                                        "about_us":txtAboutMe.text!]
        debugPrint(parameter)
        
        HTTPService.callForUploadMultipleImage(url: MNGetUpdateProfileAPI, imageParameter:"profile_pic",imageToUpload: self.imgProfile.image!, parameters: parameter) { (response) in
            
            // HideHud()
            HideHud(view: self.view)
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    print(response)
                    
                    self.navigationController?.popViewController(animated: true)
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
}
    
extension MNEditProfileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if txtName == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 40
        }
        if txtLastName == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 40
        }
         if txtMobileNumber == textField {
                    guard let textFieldText = textField.text,
                        let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                            return false
                    }
                    let substringToReplace = textFieldText[rangeOfTextToReplace]
                    let count = textFieldText.count - substringToReplace.count + string.count
                     //return NSPredicate(format: "SELF MATCHES %@", regexPassword).evaluate(with: string)
                    return count <= 10
                    
                   // let regex = "[a-z]{1,}"
                   
                    
                }
                   
        else{
            return true
        }
    }
}

              



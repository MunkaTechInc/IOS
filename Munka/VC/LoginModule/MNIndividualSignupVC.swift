//
//  MNIndividualSignupVC.swift
//  Munka
//
//  Created by Amit on 08/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import Toaster
import GoogleMaps
import GooglePlaces

class MNIndividualSignupVC : UIViewController,GetCountrylist,LocationServiceDelegate,GMSMapViewDelegate,CLLocationManagerDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        
    }
    
    
    //  @IBOutlet weak var viewBasicDetailsConstraints: NSLayoutConstraint!
    
    //MARK:- Outlets
    
    
    @IBOutlet weak var txtFirstName: DTTextField!
    @IBOutlet weak var txtLastName: DTTextField!
    @IBOutlet weak var txtMobileNumber: DTTextField!
    @IBOutlet weak var txtEmailAddress: DTTextField!
    @IBOutlet weak var txtPasssword: DTTextField!
    @IBOutlet weak var txtConfirmPassword: DTTextField!
    @IBOutlet weak var txtState: DTTextField!
    @IBOutlet weak var txtTown: DTTextField!
    @IBOutlet weak var txtZipCode: DTTextField!
    @IBOutlet weak var txtEnterPin: DTTextField!
    @IBOutlet weak var txtReenterPin: DTTextField!
    
    @IBOutlet weak var txtLLC: DTTextField!
    @IBOutlet weak var txtSsnNumber: DTTextField!
    @IBOutlet weak var lblRequiredPayout: UILabel!
    @IBOutlet weak var txtTradeName: DTTextField!
    @IBOutlet weak var txtTaxId: DTTextField!
    @IBOutlet weak var imgLience: UIImageView!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var txtReferralCode: DTTextField!

    
    @IBOutlet weak var txtStreetAddress: DTTextField!
    
    @IBOutlet weak var txtMobileNumberHight: NSLayoutConstraint!
    
    @IBOutlet weak var imgRight: UIImageView!
    
    @IBOutlet weak var viewBusinessDetailsConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewBasicDetailsConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewUploadPhotoConstraints: NSLayoutConstraint!
    @IBOutlet weak var txtLLCHightConstraints: NSLayoutConstraint!
    @IBOutlet weak var imgRightconstarints: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewUploadPhoto: UIView!
    @IBOutlet weak var viewBasicDetails: UIView!
    @IBOutlet weak var viewBusinessDetail: UIView!
    
    @IBOutlet weak var btnIndividual: UIButton!
    @IBOutlet weak var btnBUsiness: UIButton!
    
    //MARK:- Properties
    var arrayImages = [[String:Any]]()
    var strLatitude = ""
    var strLongitude = ""
    var isCountryList = false
    var isCountryId = "0"
    var isStateId = "00"
    var isCityId = "00"
    var facebookID = ""
    var googleID = ""
    var appleID = ""
    
    
    var strCountry = ""
    var strCity = ""
    var strState = ""
    var strZipCode = ""

    var isIndividualSelected = true
    var isAllFieldFill = false
    var dictPhoto =  [String:UIImage]()
    var dict =  [String:UIImage]()
    private let locationManager = CLLocationManager()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        viewBusinessDetailsConstraints.constant = 0
        viewBasicDetailsConstraints.constant = 0
        viewUploadPhotoConstraints.constant = 0
        viewUploadPhoto.isHidden = true
        viewBasicDetails.isHidden = true
        viewBusinessDetail.isHidden = true
        
        
      //  viewBasicDetailsConstraints.constant = 167
        //        viewBusinessDetailsConstraints.constant = 120
        //        viewBasicDetailsConstraints.constant = 175
        //        viewUploadPhotoConstraints.constant = 220
        //        viewUploadPhoto.isHidden = false
        //        viewBasicDetails.isHidden = false
        //        viewBusinessDetail.isHidden = false
//        let attributedText : NSMutableAttributedString =  NSMutableAttributedString(string: "Required to receive payout.")
//attributedText.addAttributes([
//                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
//                NSAttributedString.Key.strikethroughColor: UIColor.lightGray,
//                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12.0)
//                ], range: NSMakeRange(0, attributedText.length))
//        self.lblRequiredPayout.attributedText = attributedText
        
        
        self.lblRequiredPayout.font = UIFont(name:"Nunito-SemiBold",size:13)
         
      //  self.txtLLCHightConstraints.constant = 0
        //self.txtLLC.isHidden = true
        self.btnCross.isHidden = true
        btnIndividual.isSelected = true
        MyDefaults().swifProfileType = "Individual"
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        print(appDelegate().apparrayProfileImage.count)
        //        if MyDefaults().swifLoginType != nil {
        //           //print("Ooops, it's empty")
        //            }
        //        else {
        //
        //        MyDefaults().swiftSocialData = Info as NSDictionary
        //                      // self.callServiceLoginLoginAPI(email: email, password: "", facebookId: userId, googleId: "")
        //                       MyDefaults().swifLoginType = "facebook"
        //       }
        
        if MyDefaults().swifLoginType! == "facebook" {
            txtFirstName.text = MyDefaults().swiftFacebookData!["first_name"] as? String
            txtLastName.text = MyDefaults().swiftFacebookData!["last_name"] as? String
            txtEmailAddress.text = MyDefaults().swiftFacebookData!["email"] as? String
            facebookID = MyDefaults().swiftFacebookData!["id"] as? String ?? ""
        }else if MyDefaults().swifLoginType! == "google" {
            txtFirstName.text = MyDefaults().swiftGoolelData!["first_name"] as? String
            txtLastName.text = MyDefaults().swiftGoolelData!["last_name"] as? String
            txtEmailAddress.text = MyDefaults().swiftGoolelData!["email"] as? String
            googleID = MyDefaults().swiftGoolelData!["id"] as? String ?? ""
        }else if MyDefaults().swifLoginType! == "apple" {
            txtFirstName.text = MyDefaults().swiftGoolelData!["first_name"] as? String
            txtLastName.text = MyDefaults().swiftGoolelData!["last_name"] as? String
            txtEmailAddress.text = MyDefaults().swiftGoolelData!["email"] as? String
            appleID = MyDefaults().swiftGoolelData!["id"] as? String ?? ""
        }else{
            
        }
        imgRightconstarints.constant = 0
        imgRight.isHidden = true
        txtPasssword.addTarget(self, action: #selector(MNIndividualSignupVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    func clearAllTextField() {
        txtFirstName.text = ""
        txtLastName.text = ""
        txtMobileNumber.text = ""
        txtEmailAddress.text = ""
        txtPasssword.text = ""
        txtConfirmPassword.text = ""
        // txtCountry.text = ""
        txtState.text = ""
        txtTown.text = ""
        txtZipCode.text = ""
        txtSsnNumber.text = ""
        txtEnterPin.text = ""
        txtReenterPin.text = ""
        txtLLC.text = ""
        txtTradeName.text = ""
        txtTaxId.text = ""
    }
    //MARK:- textfield Did change
    @objc func textFieldDidChange(_ textField: UITextField) {
        let emailPred = NSPredicate(format:"SELF MATCHES %@", regexPassword)
        //return emailPred.evaluate(with: passwordStr)
        
        if  emailPred.evaluate(with: textField.text!){
            imgRightconstarints.constant = 25
            imgRight.isHidden = false
        }else{
            imgRightconstarints.constant = 0
            imgRight.isHidden = true
        }
    }
    //MARK:- Country Delegate
    func DelegateCountryList(CountryName:String,CountryId:String,isCountry:Bool,isTown:Bool) {
        if isTown == true{
            txtTown.text = CountryName
            isCityId = CountryId
        }else{
            if isCountry == true {
                //txtCountry.text = CountryName
                isCountryId = "231"
            }else{
                txtState.text = CountryName
                isStateId = CountryId
            }
        }
    }
    @IBAction func actionOCross(_ sender: UIButton) {
        arrayImages = [[String:Any]]()
        self.imgLience.image = UIImage.init(named: "ic_category_img")
        self.btnCross.isHidden = true
    }
    @IBAction func actionOnStreet(_ sender: UIButton) {
       let placePickerController = GMSAutocompleteViewController()
        let searchBarTextAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white, NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: UIFont.systemFontSize),
                                                                             
        ]
        let filter = GMSAutocompleteFilter()
//        filter.type = .establishment  //suitable filter type
        //filter.country = "USA"  //appropriate country code
        placePickerController.autocompleteFilter = filter
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
        self.popupAlert(title: "Title", message: " Oops, xxxx ", actionTitles: ["Option1","Option2","Option3"], actions:[{action1 in
            
            },{action2 in
                
            }, nil])
    }
    
    //   @IBAction func actionOnCountryList(_ sender: UIButton) {
    //        isCountryList = true
    //        let CountryVC = self.storyboard?.instantiateViewController(withIdentifier: "MNCountryListVC") as! MNCountryListVC
    //        CountryVC.isCountryList = true
    //        CountryVC.delagate = self
    //        self.navigationController?.pushViewController(CountryVC, animated: true)
    //    }
    @IBAction func actionOnStateListList(_ sender: UIButton) {
        if txtStreetAddress.text!.isEmpty {
            self.showAlert(title: ALERTMESSAGE, message: "Please select address.")
        }
        else{
        let CountryVC = self.storyboard?.instantiateViewController(withIdentifier: "MNCountryListVC") as! MNCountryListVC
            CountryVC.isCountryList = false
            CountryVC.CountryId = "231"
            CountryVC.delagate = self
            txtTown.text = ""
            self.navigationController?.pushViewController(CountryVC, animated: true)
        }
    }
    @IBAction func actionOnTown(_ sender: UIButton) {
        // isCountryList = false
        if txtState.text!.isEmpty {
            self.showAlert(title: ALERTMESSAGE, message: "Please select state.")
        }
        else{
        if txtState.text! != "" {
            let CountryVC = self.storyboard?.instantiateViewController(withIdentifier: "MNCountryListVC") as! MNCountryListVC
            CountryVC.isTown = true
            CountryVC.stateId = isStateId
            CountryVC.delagate = self
            self.navigationController?.pushViewController(CountryVC, animated: true)
            }
        }
    }
    @IBAction func actionTypeOfBusiness(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            clearAllTextField()
            viewBasicDetailsConstraints.constant = 0
            viewBusinessDetailsConstraints.constant = 0
            viewUploadPhotoConstraints.constant = 0
            viewUploadPhoto.isHidden = true
            viewBusinessDetail.isHidden = true
            viewUploadPhoto.isHidden = true
            //checkButtonState()
            btnBUsiness.isSelected = false
            btnIndividual.isSelected = true
            isIndividualSelected = true
            MyDefaults().swifProfileType = "Individual"
            //self.txtLLCHightConstraints.constant = 0
           // self.txtLLC.isHidden = true
            //            if isAllFieldFill == true {
            //                checkButtonState()
            //            }
            
        case 102:
            clearAllTextField()
            viewBusinessDetailsConstraints.constant = 0
            viewBasicDetailsConstraints.constant = 0
            viewUploadPhotoConstraints.constant = 0
            viewBusinessDetail.isHidden = true
            viewBasicDetails.isHidden = true
            viewUploadPhoto.isHidden = true
            
            btnBUsiness.isSelected = true
            btnIndividual.isSelected = false
            isIndividualSelected = false
            MyDefaults().swifProfileType = "Business Owner"
            //self.txtLLCHightConstraints.constant = 45
            self.txtLLC.isHidden = false
            //   checkButtonState()
        //  clearAllTextField()
        default:
            break
        }
    }
    @IBAction func actionSaveNext(_ sender: UIButton) {
        if !checkSignUpValidation() {
            if  isConnectedToInternet() {
                
                IndividualSingUpData.shared.user_type = MyDefaults().swiftUserType!
                IndividualSingUpData.shared.first_name = txtFirstName.text!
                IndividualSingUpData.shared.last_name = txtLastName.text!
                IndividualSingUpData.shared.mobile = txtMobileNumber.text!
                IndividualSingUpData.shared.email = txtEmailAddress.text!
                IndividualSingUpData.shared.password = txtPasssword.text!
                IndividualSingUpData.shared.country_id = "231"
                IndividualSingUpData.shared.state_id = isStateId
                IndividualSingUpData.shared.city_id = isCityId
                IndividualSingUpData.shared.address = txtStreetAddress.text!
                IndividualSingUpData.shared.latitude = strLatitude
                IndividualSingUpData.shared.longitude = strLongitude
                IndividualSingUpData.shared.zip_code = strZipCode
                IndividualSingUpData.shared.access_pin = txtEnterPin.text!
                IndividualSingUpData.shared.login_type = MyDefaults().swifLoginType!
                IndividualSingUpData.shared.device_type = C_device_type
                IndividualSingUpData.shared.device_id = MyDefaults().UDeviceId!
                IndividualSingUpData.shared.fb_id = facebookID
                IndividualSingUpData.shared.google_id = googleID
                IndividualSingUpData.shared.apple_id = appleID
                IndividualSingUpData.shared.profile_type = MyDefaults().swifProfileType!
                IndividualSingUpData.shared.countryName = strCountry
                IndividualSingUpData.shared.stateName = strState
                IndividualSingUpData.shared.cityName = strCity

                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MNIndividualSignupCompleteVC") as? MNIndividualSignupCompleteVC
                self.navigationController?.pushViewController(vc!, animated: true)
            }else{
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
       /* if !checkSignUpValidation() {
            if  isConnectedToInternet() {
                for textField in self.view.subviews where textField is UITextField {
                    textField.resignFirstResponder()
                }
                checkButtonState()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }*/
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSubmit(_ sender: UIButton) {
   /*     if !checkSignUpValidationOnSubmit() {
            if  isConnectedToInternet() {
                for textField in self.view.subviews where textField is UITextField {
                    textField.resignFirstResponder()
                }
                CallServiceForIndividualAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }*/
    }
    func checkButtonState() {
        if isIndividualSelected == true{
            viewBasicDetailsConstraints.constant = 192
            viewUploadPhotoConstraints.constant = 260
            viewBusinessDetailsConstraints.constant = 0
            viewUploadPhoto.isHidden = false
            viewBasicDetails.isHidden = false
            viewBusinessDetail.isHidden = true
            // btnIndividual.isSelected = true
            
        }else{
            viewBasicDetailsConstraints.constant = 192
            viewUploadPhotoConstraints.constant = 260
            viewBusinessDetailsConstraints.constant = 88
            viewUploadPhoto.isHidden = false
            viewBasicDetails.isHidden = false
            viewBusinessDetail.isHidden = false
        }
    }
    @IBAction func actionUploadPhoto(_ sender: UIButton) {
        // dictPhoto = [String:UIImage]()
        
        self.showSimpleActionSheet(controller: self, tagValue: 100)
        
    }
    
    //MARK:- Check Signup validation
    func checkSignUpValidation() -> Bool {
        
        print("Password: \(txtPasssword.text)")
        print("CPassword: \(txtConfirmPassword.text)")
        
        guard let firstName = txtFirstName.text , firstName != ""
            else {
                //showAlert(title: ALERTMESSAGE, message: "Please enter first name.")
               txtFirstName.showError(message: "Please enter first name.")
                return true}
        guard let lastName = txtLastName.text , lastName != ""
            else {
               // showAlert(title: ALERTMESSAGE, message: "Please enter last name.")
                txtLastName.showError(message: "Please enter last name.")
                return true}
        guard let mobileNumber = txtMobileNumber.text, mobileNumber != "",isValidateMobileNumberLength(password: txtMobileNumber.text) else {
           // showAlert(title: ALERTMESSAGE, message: "Please enter mobile number.")
            //self.txtMobileNumberHight.constant = 40
            txtMobileNumber.showError(message: "Please enter mobile number.")
            return true
        }
        guard let userEmail = txtEmailAddress.text , userEmail != ""  ,isValidEmail(email: txtEmailAddress.text) else {
            
            txtEmailAddress.showError(message: "Please enter valid email.")
            //showAlert(title: ALERTMESSAGE, message: "Please enter valid email")
            return true}
        guard let password = txtPasssword.text , password != "" ,isValidPassword(emailStr: txtPasssword.text!) else {
           
            txtPasssword.showError(message: "Use at least one numeric,alphabetic character and one symbol for password.")
            //showAlert(title: ALERTMESSAGE, message: "Use at least one numeric,alphabetic character and one symbol for password.")
            return true}
        guard let _ = txtConfirmPassword.text ,PasswordMatch() else {
            txtConfirmPassword.showError(message: "Please enter confirm password.")
            //showAlert(title: ALERTMESSAGE, message: "Please enter confirm password.")
            return true}
        guard let streetAddress = txtStreetAddress.text, streetAddress != "" else {
           // showAlert(title: ALERTMESSAGE, message: "Please enter street address.")
            txtStreetAddress.showError(message: "Please enter street address.")
            return true
        }
      /*  guard let state = txtState.text, state != "" else {
           // showAlert(title: ALERTMESSAGE, message: "Please enter street address.")
            txtState.showError(message: "Please enter satate.")
            return true
        }
        guard let town = txtTown.text, town != "" else {
           // showAlert(title: ALERTMESSAGE, message: "Please enter street address.")
            txtTown.showError(message: "Please enter town.")
            return true
        }
        guard let zipCode = txtZipCode.text, zipCode != "",isValidateZipCodeLength(zipCode: txtZipCode.text) else {
           // showAlert(title: ALERTMESSAGE, message: "Please enter Zip code.")
            txtZipCode.showError(message: "Please enter Zip code.")
            return true
        }
        guard let country = txtTown.text, country != "" else {
           // showAlert(title: ALERTMESSAGE, message: "Please enter town.")
           txtTown.showError(message: "Please enter town.")
            return true
        }*/
        guard let enterPin = txtEnterPin.text, enterPin != "" else {
           // showAlert(title: ALERTMESSAGE, message: "Please enter enter pin.")
            txtEnterPin.showError(message: "Please enter enter pin.")
            return true
        }
        guard let reenterPin = txtReenterPin.text, reenterPin != "" else {
           // showAlert(title: ALERTMESSAGE, message: "Please enter enter pin.")
            txtReenterPin.showError(message: "Please enter re-enetr pin.")
            return true
        }
        guard let _ = txtReenterPin.text,VaidationForPin() else {showAlert(title: ALERTMESSAGE, message: "lease enter pin.")
            return true}
        return false
    }
    
   /* func checkSignUpValidationOnSubmit() -> Bool {
        
        if isIndividualSelected == true{
            guard let llcNumber = txtLLC.text , llcNumber != ""
                else {//showAlert(title: ALERTMESSAGE, message: "Please enter Legal name.")
                    txtLLC.showError(message: "Please enter Legal name.")

                    return true}
            return false
        }
        //else{
//            guard let llcNumber = txtLLC.text , llcNumber != "" ,isValidateLLcNumberLength(llcNumber: txtLLC.text)
//                else {showAlert(title: ALERTMESSAGE, message: "Please enter llc number.")
//                    return true}
//            guard let tradeName = txtTradeName.text , tradeName != ""
//                else {showAlert(title: ALERTMESSAGE, message: "Please enter trade name.")
//                    return true}
//            guard let taxid = txtTaxId.text , taxid != ""
//                else {showAlert(title: ALERTMESSAGE, message: "Please enter tax ID number.")
//                    return true}
//            guard arrayImages.count > 0 else {showAlert(title: ALERTMESSAGE, message: "Please upload id proof.")
//                return true}
//            return false
//        }
      guard let llcNumber = txtLLC.text , llcNumber != "" ,isValidateLLcNumberLength(llcNumber: txtLLC.text)
                else {
                    txtLLC.showError(message: "Please enter Legal name.")
                    //showAlert(title: ALERTMESSAGE, message: "Please enter Legal name.")
                    return true}
            guard let tradeName = txtTradeName.text , tradeName != ""
                else {
                    txtTradeName.showError(message: "Please enter Legal name.")
                    //showAlert(title: ALERTMESSAGE, message: "Please enter trade name.")
                    return true}
            guard let taxid = txtTaxId.text , taxid != ""
                else {
                    txtTaxId.showError(message: "Please enter tax ID or EIN  number.")
                    //showAlert(title: ALERTMESSAGE, message: "Please enter tax ID number.")
                    return true}
            guard arrayImages.count > 0 else {showAlert(title: ALERTMESSAGE, message: "Please upload id proof.")
                return true}
           
        return false
        
    }*/
    func VaidationForPin() -> Bool {
        if txtEnterPin.text == txtReenterPin.text {
            return true
        }
        showAlert(title: ALERTMESSAGE, message: "Pin did not match")
        return false
    }
    func PasswordMatch() -> Bool {
        if txtPasssword.text! == txtConfirmPassword.text!{
            return true
        }
        else{ showAlert(title: ALERTMESSAGE, message: "Please enter confirm password")  }
        return false
    }
 /*   //MARK:- Call API
    func CallServiceForIndividualAPI() {
        UserDefaults.standard.set(true, forKey: "isDisplayIntroPage")
        UserDefaults.standard.synchronize()
        calllAPI()
    }
    func calllAPI() {
        var arrayUploadImage =  [[String:Any]]()

      //  ShowHud()
        ShowHud(view: self.view)
        let parameter: [String: Any] = [
            "user_type":MyDefaults().swiftUserType!,
            "first_name":txtFirstName.text!,
            "last_name":txtLastName.text!,
            "mobile":txtMobileNumber.text!,
            "email":txtEmailAddress.text!,
            "password":txtPasssword.text!,
            "country_id":"231",
            "state_id":isStateId,
            "city_id":isCityId,
            "address":txtStreetAddress.text!,
            "latitude":strLatitude,
            "longitude":strLongitude,
            "zip_code":strZipCode,
            "access_pin":txtEnterPin.text!,
            "login_type":MyDefaults().swifLoginType!,
            "device_type":C_device_type,
            "device_id":MyDefaults().UDeviceId!,
            "fb_id":facebookID,
            "google_id":googleID,
            "apple_id":appleID,
            "profile_type":MyDefaults().swifProfileType!,
            "llc_number":txtLLC.text!,
            "ssn_number":txtSsnNumber.text!,
            "business_name":txtTradeName.text!,
            "tax_id":txtTaxId.text!,
            "countryName":strCountry,
            "stateName":strState,
            "cityName":strCity,
            "referral_code":txtReferralCode.text!]
        
        if appDelegate().apparrayProfileImage.count > 0{
            
            var dictionary =  [String:Any]()
            let image1 = appDelegate().apparrayProfileImage[0] as AnyObject
            dictionary ["png"] = (image1 as! UIImage)
            dictionary ["url"] = ""
            dictionary ["uploadfile"] = "profile_pic"
            dictionary ["type"] = "image"
            arrayUploadImage.append(dictionary)
            
            if self.arrayImages.count > 0 {
                let dict = self.arrayImages[0]
                let fileType = dict["file"] as! String
                if fileType == "image" {
                    var dictionary1 =  [String:Any]()
                    let image = dict["png"] as! UIImage
                    dictionary1 ["png"] = image
                    dictionary1 ["url"] = ""
                    dictionary1 ["uploadfile"] = "goverment_id"
                    dictionary1 ["type"] = "image"
                    arrayUploadImage.append(dictionary1)
                } else {
                    var dictionary1 =  [String:Any]()
                    let url = dict["url"] as! URL
                    dictionary1 ["png"] = ""
                    dictionary1 ["url"] = url
                    dictionary1 ["uploadfile"] = "goverment_id"
                    dictionary1 ["type"] = "url"
                    arrayUploadImage.append(dictionary1)
                }
            }
        }else{
            if self.arrayImages.count > 0 {
                let dict = self.arrayImages[0]
                let fileType = dict["file"] as! String
                if fileType == "image" {
                    var dictionary1 =  [String:Any]()
                    let image = dict["png"] as! UIImage
                    dictionary1 ["png"] = image
                    dictionary1 ["url"] = ""
                    dictionary1 ["uploadfile"] = "goverment_id"
                    dictionary1 ["type"] = "image"
                    arrayUploadImage.append(dictionary1)
                } else {
                    var dictionary1 =  [String:Any]()
                    let image = dict["url"] as! URL
                    dictionary1 ["png"] = ""
                    dictionary1 ["url"] = image
                    dictionary1 ["uploadfile"] = "goverment_id"
                    dictionary1 ["type"] = "url"
                    arrayUploadImage.append(dictionary1)
                }
            }
        }
            debugPrint(parameter)
        HTTPService.callForProfessinalUploadMultipleImage(url:MNSignUpAPI, imageToUpload: arrayUploadImage as [[String:Any]], parameters: parameter) { (response) in
            debugPrint(response)
HideHud(view: self.view)
           // HideHud()
            let status = response["status"] as! String
            let message = response["msg"] as! String
            
            if status == "1"
            {
                // let response = ModelCountryList.init(fromDictionary: response as! [String : Any])
                // self.details = response.details
                let responseData = response["details"] as! [String: Any]
                MyDefaults().UserId = responseData["user_id"] as? String
                MyDefaults().swifSignUpMobileNumber = self.txtMobileNumber.text!
                
                if let cCode = responseData["country_code"]{
                    MyDefaults().swifCountryCode = "\(cCode)"
                }
                MyDefaults().UserEmail = self.txtEmailAddress.text!
                MyDefaults().swifLoginMPIN = self.txtEnterPin.text!
                
                self.pushAccountVarification()
                Toast(text: message).show()
                //self.tblViewCountry?.reloadData()
            }else
            {
                self.showErrorPopup(message: message, title: alert)
            }
        }
    }
    
    func pushAccountVarification() {
        let mobile = self.storyboard?.instantiateViewController(withIdentifier: "MNMobileVarificationVC") as! MNMobileVarificationVC
        self.navigationController?.pushViewController(mobile, animated: true)
    }*/
}

//MARK:- text Field Delegate
extension MNIndividualSignupVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtFirstName == textField {
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
            return count <= 10
               }
        if txtEmailAddress == textField {
         guard let textFieldText = textField.text,
         let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
         }
         let substringToReplace = textFieldText[rangeOfTextToReplace]
         let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 40
            }
        if txtPasssword == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 12
        }
        if txtConfirmPassword == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 12
        }
//        if txtStreetAddress == textField {
//            guard let textFieldText = textField.text,
//                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
//                    return false
//            }
//            let substringToReplace = textFieldText[rangeOfTextToReplace]
//            let count = textFieldText.count - substringToReplace.count + string.count
//            return count <=
//        }
        if txtZipCode == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 8
        }
       
        if txtEnterPin == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 4
        }
        if txtReenterPin == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 4
        }
        if txtLLC == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 10
        }
        if txtSsnNumber == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 10
        }
    else{
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtFirstName:
            txtLastName.becomeFirstResponder()
        case txtLastName:
            txtMobileNumber.becomeFirstResponder()
        case txtMobileNumber:
            txtEmailAddress.becomeFirstResponder()
        case txtEmailAddress:
            txtPasssword.becomeFirstResponder()
        case txtPasssword:
            txtConfirmPassword.becomeFirstResponder()
        case txtConfirmPassword:
            txtConfirmPassword.resignFirstResponder()
        case txtZipCode:
            txtEnterPin.becomeFirstResponder()
        case txtEnterPin:
            txtReenterPin.becomeFirstResponder()
        case txtReenterPin:
            txtReenterPin.resignFirstResponder()
        case txtLLC:
            txtLLC.resignFirstResponder()
        case txtSsnNumber:
            txtSsnNumber.resignFirstResponder()
        case txtTaxId:
            txtTaxId.resignFirstResponder()
        case txtTradeName:
            txtTradeName.resignFirstResponder()
        case txtReferralCode:
            txtReferralCode.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    //MARK:- Show Action Sheet
    func showSimpleActionSheet(controller: UIViewController,tagValue:Int) {
        let alert = UIAlertController(title: "Munka", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera/Gallery", style: .default, handler: { (_) in
            print("User click Approve button")
            self.openCamera(tag: 0)
        }))
        alert.addAction(UIAlertAction(title: "Documents", style: .default, handler: { (_) in
            self.openDocumnets()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    //open Doc
    func openDocumnets() {
        //let types : [String] = ["public.image", "com.microsoft.word.doc", kUTTypePDF] as! [String]
        let picker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc"], in: .open)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        self.present(picker, animated: true, completion: nil)
    }
    func createFolder(_ folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Construct a URL with desired folder name
        let folderURL = MNProfessionalSignupVC.self.getDocumentsDirectory().appendingPathComponent(folderName)
        // If folder URL does not exist, create it
        if !fileManager.fileExists(atPath: folderURL.path) {
            do {
                // Attempt to create folder
                try fileManager.createDirectory(atPath: folderURL.path,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                // Creation failed. Print error & return nil
                print(error.localizedDescription)
                return nil
            }
        }
        // Folder either exists, or was created. Return URL
        return folderURL
    }
    class func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func deletePathFromDocumentsDirectory(_ folderURL : URL)
    {
        if FileManager.default.fileExists(atPath: folderURL.path)
        {
            do {
                try FileManager.default.removeItem(atPath: folderURL.path)
            } catch let error as NSError {
                print("Could not clear temp folder: \(error.debugDescription)")
            }
        }
    }
    
}
//MARK:- Document Delegate
extension MNIndividualSignupVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard
            controller.documentPickerMode == .open,
            let url = urls.first,
            url.startAccessingSecurityScopedResource()
            else {
                return
        }
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        do {
            let folderPath = createFolder("Munka")
            let filePath : URL = (folderPath?.appendingPathComponent(url.lastPathComponent))!
            var mediaImage : UIImage = UIImage()
            // Create a FileManager instance
            
            do {
                try FileManager.default.copyItem(atPath: url.path, toPath: filePath.path)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
            
            if filePath.absoluteString.contains(".jpg") || filePath.absoluteString.contains(".jpeg") || filePath.absoluteString.contains(".png") {
                mediaImage = #imageLiteral(resourceName: "doc_img")
            } else if filePath.absoluteString.contains(".doc") || filePath.absoluteString.contains(".docx") || filePath.absoluteString.contains(".txt"){
                mediaImage = #imageLiteral(resourceName: "doc_file")
            }
            else if filePath.absoluteString.contains(".pdf") {
                mediaImage = #imageLiteral(resourceName: "doc_pdf")
            }
            else if filePath.absoluteString.contains(".xls") || filePath.absoluteString.contains(".xlsx"){
                mediaImage = #imageLiteral(resourceName: "doc_file")
            }
            self.arrayImages  = [[String:Any]]()
            var dictionary1 =  [String:Any]()
            dictionary1 ["url"] = filePath
            dictionary1 ["png"] = ""
            dictionary1 ["file"] = "url"
            dictionary1 ["isplaceHolder"] = "no"
            dictionary1 ["type"] = "url"
            self.arrayImages.append(dictionary1)
            self.imgLience.image = UIImage.init(named: "ic_category_doc")
            self.btnCross.isHidden = false
            
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK:- Open Camera
    func openCamera(tag:Int) {
        
        self.view.endEditing(true)
        self.arrayImages  = [[String:Any]]()
        ImagePickerManager().pickImage(self){ image in
            self.imgLience.contentMode = .scaleAspectFill
            self.imgLience.image = image
            var dictionary1 =  [String:Any]()
            dictionary1 ["url"] = ""
            dictionary1 ["png"] = image
            dictionary1 ["file"] = "image"
            dictionary1 ["isplaceHolder"] = "no"
            dictionary1 ["type"] = "image"
            self.btnCross.isHidden = false
            self.arrayImages.append(dictionary1)
        }
    }
}


//MARK:- Autocomplete View Controller
extension MNIndividualSignupVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        let objPlace = GoogleLocation().extractFromGooglePlcae(place: place)
        
        print("city: \(objPlace.city), country: \(objPlace.state), state: \(objPlace.state),strZipCode: \(objPlace.postalCode ?? "000000") ")
        
        strCity = objPlace.city ?? ""
        strState = objPlace.state ?? ""
        strCountry = objPlace.country ?? ""
        strZipCode = objPlace.postalCode ?? "000000"
    
        
        var dLatitude = place.coordinate.latitude
        var dLongitude = place.coordinate.longitude
        
        strLatitude = String(dLatitude)
        strLongitude = String(dLongitude)
        self.txtStreetAddress.text = place.formattedAddress!
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

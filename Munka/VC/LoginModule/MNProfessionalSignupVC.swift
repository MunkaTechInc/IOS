//
//  MNProfessionalSignupVC.swift
//  Munka
//
//  Created by Amit on 08/11/19.
//  Copyright © 2019 Harish Patidar. All rights reserved.
//

import UIKit
import Toaster
import MobileCoreServices
import GooglePlaces
////// Is Professinal type 1 = yes , 2 = No
class MNProfessionalSignupVC: UIViewController,GetCountrylist,GetSelectCategory {
    
    @IBOutlet weak var collectinViewCategory: UICollectionView!
    @IBOutlet weak var txtFirstName: DTTextField!
    @IBOutlet weak var txtLastName: DTTextField!
    @IBOutlet weak var txtMobileNumber: DTTextField!
    @IBOutlet weak var txtEmailAddress: DTTextField!
    @IBOutlet weak var txtPasssword: DTTextField!
    @IBOutlet weak var txtConfirmPassword: DTTextField!
    
    @IBOutlet weak var txtStreetAddress: DTTextField!
    // @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: DTTextField!
    @IBOutlet weak var txtTown: DTTextField!
    @IBOutlet weak var txtZipCode: DTTextField!
    @IBOutlet weak var txtSelectCategory: DTTextField!
    
    @IBOutlet weak var txtEnterPin: DTTextField!
    @IBOutlet weak var txtReenterPin: DTTextField!
    
    
    @IBOutlet weak var txtRefferalCode: DTTextField!

    @IBOutlet weak var txtBusinessAddress: DTTextField!
    @IBOutlet weak var txtTaxId: DTTextField!
    @IBOutlet weak var txtBusinessName: DTTextField!

    @IBOutlet weak var imgUploadImage: UIImageView!
    @IBOutlet weak var imgGovtUploadImage: UIImageView!
    @IBOutlet weak var btnUploadResume: UIButton!
    @IBOutlet weak var btnUploadGovtId: UIButton!
    @IBOutlet weak var btnCrossUploadResume: UIButton!
    @IBOutlet weak var btnCrossUploadGovtId: UIButton!
    
    @IBOutlet weak var imgRightconstarints: NSLayoutConstraint!
    @IBOutlet weak var viewSelectCategoryConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewSelectCategory: UIView!
    @IBOutlet weak var viewSelectBottom: UIView!
    
    @IBOutlet weak var btnselectCategoryYes: UIButton!
    @IBOutlet weak var btnselectCategoryNo: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgRight: UIImageView!
    
    @IBOutlet weak var txtShift: DTTextField!
    @IBOutlet weak var txtSelectedDay: DTTextField!
    
    @IBOutlet weak var txtEndTime: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    
    
    var arrayImagesCategory = NSMutableArray()
    var arrayUploadResume = NSMutableArray()
    var arrayGovtidUpload = NSMutableArray()

    var uploadImages = [UIImage]()
    var govtuploadImages = [UIImage]()
    
    var arrayFileType = [String]()
    var arraySetId = [String]()
    var arraySelectItems = [[String:String]]()
    //var isAllValidation = false
    var isSelectCategory = false
    var isCountryList = false
    var isCountryId = "00"
    var isStateId = "00"
    var isCityId = "00"
    var facebookID = ""
    var googleID = ""
     var appleID = ""
    var strCategoryId = ""
    var isProfessional = false
    var isProfessionalTypeClick = false
    var isOnClickUploadResume = false
    var isUploadImage = false
    var isUploadGovtId = false
    var isTagForCollectionCell = false
    var isFromBusinessAddress = false
    var isSelectCataegoryImage = false
    var strLatitudeBusiness = ""
    var strLongitudeBusiness = ""
    var strLatitude = ""
    var strLongitude = ""
    //var imagePlaceholder = UIImage()
    var kResume_1 : Int       = 0
    var kResume_2 : Int       = 0
    var kResume_3 : Int       = 0
    var tagForCollectionCell : Int       = 0
    
    var kGovernmentId1 : Int = 2
    
    var strCountry = ""
    var strCity = ""
    var strState = ""
    var strZipCode = ""
    
    var startTime = String()
    var endTime = String()
    var arrSelectedShift = [DayShiftDetail]()

    private var startDateWithTime = Date()
    private var endDateWithTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController?.isNavigationBarHidden = false
        //        viewSelectCategoryConstraints.constant = 128
        //        viewBottomConstraints.constant = 634
        //        viewSelectCategory.isHidden = false
        //        viewSelectBottom.isHidden = false
        viewSelectCategoryConstraints.constant = 0
        viewBottomConstraints.constant = 0
        viewSelectCategory.isHidden = true
        viewSelectBottom.isHidden = true
        btnCrossUploadResume.isHidden = true
        btnCrossUploadGovtId.isHidden = true
        imgRight.isHidden = true
        imgRightconstarints.constant = 0
        MyDefaults().swifProfileType = "Individual"
        if MyDefaults().swifLoginType! == "facebook" {
            txtFirstName.text = MyDefaults().swiftFacebookData!["first_name"] as? String
            txtLastName.text = MyDefaults().swiftFacebookData!["last_name"] as? String
            facebookID = MyDefaults().swiftFacebookData!["id"] as? String ?? ""
            txtEmailAddress.text = MyDefaults().swiftFacebookData!["email"] as? String
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
        txtPasssword.addTarget(self, action: #selector(MNProfessionalSignupVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        viewBottomConstraints.constant = 0
    }
    
    
    func delegateSelectedWorkingDay(array: [String]) {
        print("Select Working Day")
        txtSelectedDay.text! = array.map{String($0)}.joined(separator: ",")
    }
    
    func delegateSelectedShifts(array: [DayShiftDetail]) {
        print("Select Shift ")
        arrSelectedShift = array
         
        var arrTitle = [String]()
        
        for str in array{
            
            arrTitle.append(str.headerTitle)
        }
        arrTitle = Array(Set(arrTitle))
//        arrTitle = arrTitle.reversed()
        /*let week = DateFormatter().weekdaySymbols!
        guard Set(arrTitle).isSubset(of: week) else {
            fatalError("The elements of the array must all be day names with the first letter capitalized")
        }*/
        txtShift.text! = arrTitle.map{String($0)}.joined(separator: ",")
        

   
    }
    
    
    
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
    @IBAction func btnEndTimeTap(_ sender: Any) {

        DatePickerDialog().show(controller: self, "End Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel" ,minimumDate: nil, datePickerMode: .time) { [self]
            (date) -> Void in
            if let dt = date {
                var formatter = DateFormatter()
                formatter = DateFormatter()
                formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "time")
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.amSymbol = "AM"
                formatter.pmSymbol = "PM"
                //sender.setTitle(formatter.string(from: dt), for: .normal)
                self.txtEndTime.text = (formatter.string(from: dt))
                self.endTime = formatter.string(from: dt)
                print("endTime:\(endTime)")

                self.txtEndTime.text! = self.endTime

            }
        }
    }
    @IBAction func btnStartTimeTap(_ sender: Any) {
        
        DatePickerDialog().show(controller:self,"Start Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: Date(), datePickerMode: .time) { [self]
            (date) -> Void in
            if let dt = date {
                var formatter = DateFormatter()
                formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "time")
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.amSymbol = "AM"
                formatter.pmSymbol = "PM"
                self.startTime = formatter.string(from: dt)
                formatter = DateFormatter()
                formatter.amSymbol = "AM"
                formatter.pmSymbol = "PM"
                formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "time")
                formatter.locale = Locale(identifier: "en_US_POSIX")
                self.startDateWithTime = dt//formatter.string(from: dt)
                self.startTime = formatter.string(from: dt)
                self.endTime = ""
            
            print("startTime:\(startTime), startDateWithTime:\(startDateWithTime)")
                self.txtStartTime.text! = self.startTime

            }
        }
    }
    
    @IBAction func btnSelecteShiftTap(_ sender: Any) {
        let popup : SelectCategoryPopupVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "SelectCategoryPopupVC") as! SelectCategoryPopupVC
        popup.delagate = self
        popup.isShiftSelected = true
        if arrSelectedShift.count > 0{
            popup.arrSelectedShift = arrSelectedShift
        }
        self.presentOnRoot(with: popup)
        
    }
    
    @IBAction func btnSelectedDayTap(_ sender: Any) {
        /*let popup : SelectCategoryPopupVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "SelectCategoryPopupVC") as! SelectCategoryPopupVC
        popup.delagate = self
        popup.isDaySelected = true
        self.presentOnRoot(with: popup)*/
    }
    
    @IBAction func actionOnCrossUploadResume(_ sender: UIButton) {
        arrayUploadResume = NSMutableArray()
        self.imgUploadImage.image = UIImage.init(named: "ic_category_img")
        btnCrossUploadResume.isHidden = true
    }
    
    @IBAction func actionOnCrossUploadGovtId(_ sender: UIButton) {
        arrayGovtidUpload = NSMutableArray()
        self.imgGovtUploadImage.image = UIImage.init(named: "ic_category_img")
        btnCrossUploadGovtId.isHidden = true
    }
    
    @IBAction func actionOnStreet(_ sender: UIButton) {
    
        view.endEditing(true)
    
        let placePickerController = GMSAutocompleteViewController()
        let searchBarTextAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white, NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter  //suitable filter type
     //   filter.country = "USA"  //appropriate country code//#DR
        placePickerController.autocompleteFilter = filter
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
        self.isFromBusinessAddress = false
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
        self.popupAlert(title: "Title", message: " Oops, xxxx ", actionTitles: ["Option1","Option2","Option3"], actions:[{action1 in
            
            },{action2 in
                
            }, nil])
    }
    @IBAction func actionOnStateListList(_ sender: UIButton) {
        if txtStreetAddress.text!.isEmpty {
            self.showAlert(title: ALERTMESSAGE, message: "Please select address.")
        }
        else{
            isCountryList = false
            let CountryVC = self.storyboard?.instantiateViewController(withIdentifier: "MNCountryListVC") as! MNCountryListVC
            CountryVC.isCountryList = false
            CountryVC.CountryId = "231"
            CountryVC.delagate = self
            txtTown.text = ""
            self.navigationController?.pushViewController(CountryVC, animated: true)
        }
    }
    @IBAction func actionOnCityListList(_ sender: UIButton) {
        // isCountryList = false
        if txtState.text!.isEmpty {
            self.showAlert(title: ALERTMESSAGE, message: "Please select state.")
        }else{
            let CountryVC = self.storyboard?.instantiateViewController(withIdentifier: "MNCountryListVC") as! MNCountryListVC
            CountryVC.isTown = true
            CountryVC.stateId = isStateId
            CountryVC.delagate = self
            self.navigationController?.pushViewController(CountryVC, animated: true)
        }
    }
    
    //google Adress For Business Address
    @IBAction func btnBusinessAdress(_ sender: Any) {
         let placePickerController = GMSAutocompleteViewController()
                let searchBarTextAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white, NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: UIFont.systemFontSize)]
                let filter = GMSAutocompleteFilter()
                filter.type = .noFilter  //suitable filter type
//                filter.country = "USA"  //appropriate country code
                placePickerController.autocompleteFilter = filter
         UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
        self.isFromBusinessAddress = true
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func actionOnSelectCategory(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            btnselectCategoryYes.isSelected = true
            btnselectCategoryNo.isSelected = false
            isProfessional = true
            isProfessionalTypeClick = true
            //viewSelectCategoryConstraints.constant = 128
            //viewSelectCategory.isHidden = false
            if !isSelectCategory{
                viewSelectCategoryConstraints.constant = 0
                viewSelectCategory.isHidden = true
            }else{
                viewSelectCategoryConstraints.constant = 128.0
                viewSelectCategory.isHidden = false
            }
        case 102:
            btnselectCategoryYes.isSelected = false
            btnselectCategoryNo.isSelected = true
            isProfessional = false
            isProfessionalTypeClick = true
            viewSelectCategoryConstraints.constant = 0
            viewSelectCategory.isHidden = true
            if !isSelectCategory{
                viewSelectCategoryConstraints.constant = 0
                viewSelectCategory.isHidden = false
            }else{
                viewSelectCategoryConstraints.constant = 0
                viewSelectCategory.isHidden = true
            }
            
        default:
            break
        }
    }
    @IBAction func actionOnCategory(_ sender: UIButton) {
        let popup : SelectCategoryPopupVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "SelectCategoryPopupVC") as! SelectCategoryPopupVC
        popup.delagate = self
        popup.isCategorySelected = true
        self.presentOnRoot(with: popup)
    }
    @IBAction func actionSaveNext(_ sender: UIButton) {
    
     if !checkSignUpValidation() {
         
         ProfessionalSingUpData.shared.user_type = MyDefaults().swiftUserType!
         ProfessionalSingUpData.shared.first_name = txtFirstName.text!
         ProfessionalSingUpData.shared.last_name = txtLastName.text!
         ProfessionalSingUpData.shared.mobile = txtMobileNumber.text!
         ProfessionalSingUpData.shared.email = txtEmailAddress.text!
         ProfessionalSingUpData.shared.password = txtPasssword.text!
         ProfessionalSingUpData.shared.country_id = "231"
         ProfessionalSingUpData.shared.state_id = isStateId
         ProfessionalSingUpData.shared.city_id = isCityId
         ProfessionalSingUpData.shared.address = txtStreetAddress.text!
         ProfessionalSingUpData.shared.latitude = strLatitude
         ProfessionalSingUpData.shared.longitude = strLongitude
         ProfessionalSingUpData.shared.zip_code = strZipCode
         ProfessionalSingUpData.shared.access_pin = txtEnterPin.text!
         ProfessionalSingUpData.shared.login_type = MyDefaults().swifLoginType!
         ProfessionalSingUpData.shared.device_type = C_device_type
         ProfessionalSingUpData.shared.strCategoryId = strCategoryId
         ProfessionalSingUpData.shared.device_id = MyDefaults().UDeviceId!
         
        
         ProfessionalSingUpData.shared.fb_id = facebookID
         ProfessionalSingUpData.shared.google_id = googleID
         ProfessionalSingUpData.shared.apple_id = appleID
         
         
         ProfessionalSingUpData.shared.profile_type = MyDefaults().swifProfileType!
         ProfessionalSingUpData.shared.countryName = strCountry
         ProfessionalSingUpData.shared.stateName = strState
         ProfessionalSingUpData.shared.cityName = strCity
         ProfessionalSingUpData.shared.arrSelectedShift = arrSelectedShift
         
         ProfessionalSingUpData.shared.businessLatitude = strLatitudeBusiness
         ProfessionalSingUpData.shared.businessLongitude = strLongitudeBusiness
         
         /*
          "":,
          "service_category":ProfessionalSingUpData.shared.strCategoryId,
          "is_professional":"1",
          "referral_code":txtRefferalCode.text!,
          "business_latitude":ProfessionalSingUpData.shared.businessLatitude,
          "business_longitude": ProfessionalSingUpData.shared.businessLongitude,
          */
         
         
         UserDefaults.standard.set(true, forKey: "isDisplayIntroPage")
         UserDefaults.standard.synchronize()
         let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MNProfessionalSignupCompleteVC") as? MNProfessionalSignupCompleteVC
         vc?.arrayImagesCategory = self.arrayImagesCategory
         vc?.kResume_3  = self.kResume_3
         vc?.arraySetId  = self.arraySetId
         vc?.isProfessional = self.isProfessional
         self.navigationController?.pushViewController(vc!, animated: true)
            
//          if !isSelectCataegoryImage {
//                showAlert(title: ALERTMESSAGE, message: "Please select category image.")
//            }else{
//                viewBottomConstraints.constant = 634
//                viewSelectBottom.isHidden = false
//            }
           /// showAlert(title: ALERTMESSAGE, message: "Please select category image.")
//            viewBottomConstraints.constant = 590
//            viewSelectBottom.isHidden = false
        }
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSubmit(_ sender: UIButton) {
      /*  if !checkSignUpValidationOnSubmit() {
            if  isConnectedToInternet() {
                for textField in self.view.subviews where textField is UITextField {
                    textField.resignFirstResponder()
                }
                CallServiceForIndividualAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: ALERTMESSAGE)
            }
        }*/
         CallServiceForIndividualAPI()
    }
    
    func openSelectedDay(){
        let popup : SelectCategoryPopupVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "SelectCategoryPopupVC") as! SelectCategoryPopupVC
        popup.delagate = self
        self.presentOnRoot(with: popup)
    }
    
    func openSelectedShif(){
        let popup : SelectCategoryPopupVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "SelectCategoryPopupVC") as! SelectCategoryPopupVC
        popup.delagate = self
        self.presentOnRoot(with: popup)
    }
    
    func checkSignUpValidationOnSubmit() -> Bool {
        
//        guard let businessname = txtBusinessName.text , businessname != ""
//            else {
//             //   showAlert(title: ALERTMESSAGE, message: "Please enter business name")
//               txtBusinessName.showError(message: "Please enter business name.")
//
//                return true}
//        guard let businessAddress = txtBusinessAddress.text , businessAddress != ""else {
//            //showAlert(title: ALERTMESSAGE, message: "Please enter business name.")
//            txtBusinessAddress.showError(message: "Please enter business address.")
//            return true}
//
//        guard let taxid = txtTaxId.text , taxid != ""else {
//            //showAlert(title: ALERTMESSAGE, message: "Please enter tax ID number.")
//            txtTaxId.showError(message: "Please enter tax ID number or EIN.")
//            return true}
        //        guard uploadImages.count > 0 else {showAlert(title: "Alert", message: "Please upload id proof.")
        //                return true}
        //        guard govtuploadImages.count > 0 else {showAlert(title: "Alert", message: "Please upload Govt. id proof.")
        //                return true}
        guard isUploadImage == true else {
            showAlert(title: ALERTMESSAGE, message: "Please upload id proof.")
            return true
        }
        
        guard isUploadGovtId == true else {
            showAlert(title: ALERTMESSAGE, message: "Please upload Govt. id proof.")
            return true
        }
        
        
        return false
        
    }
    @IBAction func actionUploadPhoto(_ sender: UIButton) {
        btnUploadResume.tag = 10001
        btnUploadGovtId.tag = 0
        isOnClickUploadResume = true
        self.showSimpleActionSheet(controller: self, tagValue: 99)
    }
    @IBAction func actionGovtUploadPhoto(_ sender: UIButton) {
        btnUploadGovtId.tag = 10002
        btnUploadResume.tag = 0
        isOnClickUploadResume = false
        self.showSimpleActionSheet(controller: self, tagValue: 99)
    }
    
    func checkSignUpValidation() -> Bool {
        guard let firstName = txtFirstName.text , firstName != ""
            else {
                txtFirstName.showError(message: "Please enter first name.")
                //showAlert(title: ALERTMESSAGE, message: "Please enter first name.")
                return true}
        guard let lastName = txtLastName.text , lastName != ""
            else {
                txtLastName.showError(message: "Please enter last name.")
               // showAlert(title: ALERTMESSAGE, message: "Please enter last name.")
                return true}
        guard let mobileNumber = txtMobileNumber.text, mobileNumber != "",isValidateMobileNumberLength(password: txtMobileNumber.text) else {
           // showAlert(title: ALERTMESSAGE, message: "Please enter mobile number.")
            txtMobileNumber.showError(message: "Please enter mobile number.")
            return true
        }
        guard let userEmail = txtEmailAddress.text , userEmail != ""  ,isValidEmail(email: txtEmailAddress.text) else {
            txtEmailAddress.showError(message: "Please enter valid email.")
            //showAlert(title: ALERTMESSAGE, message: "Please enter valid email.")
            return true}
        guard let password = txtPasssword.text , password != "" ,isValidPassword(emailStr: txtPasssword.text!) else {
            txtPasssword.showError(message: "Use at least one numeric,alphabetic character and one symbol for password.")
           // txtPasssword.showError(message: "Please enter valid email.")
            //showAlert(title: ALERTMESSAGE, message: "Use at least one numeric,alphabetic character and one symbol for password.")
            return true}
        guard let _ = txtConfirmPassword.text ,PasswordMatch() else {
            txtConfirmPassword.showError(message: "Please enter confirm passwor.")
           // showAlert(title: ALERTMESSAGE, message: "Please enter confirm password")
            return true}
        guard let streetAddress = txtStreetAddress.text, streetAddress != "" else {
            //showAlert(title: ALERTMESSAGE, message: "Please enter street address.")
            txtStreetAddress.showError(message: "Please enter street address.")
            return true
        }
      /*  guard let state = txtState.text, state != "" else {
            //showAlert(title: ALERTMESSAGE, message: "Please enter street address.")
            txtState.showError(message: "Please enter state.")
            return true
        }
        guard let town = txtTown.text, town != "" else {
            txtTown.showError(message: "Please enter town.")
            //showAlert(title: ALERTMESSAGE, message: "Please enter town.")
            return true
        }
        guard let zipCode = txtZipCode.text, zipCode != "" ,isValidateZipCodeLength(zipCode: txtZipCode.text) else {
            //showAlert(title: ALERTMESSAGE, message: "Please enter Zip code.")
            txtZipCode.showError(message: "Please enter Zip code.")
            return true
        }*/
        
        guard let category = txtSelectCategory.text, category != "" else {
         //   showAlert(title: ALERTMESSAGE, message: "Please enter select category.")
            
            txtSelectCategory.showError(message: "Please enter select category.")
            return true
        }
        
        guard isProfessionalTypeClick == true else {showAlert(title: ALERTMESSAGE, message: "Please professional type.")
            return true
        }
        guard let enterPin = txtEnterPin.text, enterPin != "" else {
           // showAlert(title: ALERTMESSAGE, message: "Please enter pin.")
            
            txtEnterPin.showError(message: "Please enter pin.")
            return true
        }
        guard let repint = txtReenterPin.text, repint != "" else {
           // showAlert(title: ALERTMESSAGE, message: "Please enter pin.")
            
            txtReenterPin.showError(message: "Please enter pin.")
            return true
        }
        guard let _ = txtReenterPin.text,VaidationForPin() else {showAlert(title: ALERTMESSAGE, message: "lease enter pin.")
            return true
        }
        
        return false
    }
    func VaidationForPin() -> Bool {
        if txtEnterPin.text == txtReenterPin.text {
            return true
        }
        showAlert(title: ALERTMESSAGE, message: "Pin did not match")
        return false
    }
    
    func delegatePostJobcategory(array:[[String:Any]]){
        
    }
    func delegateCategoryType(array: [[String : String]]) {
        var arrayName = [String]()
        var arrayCategoryId = [String]()
        arraySetId = [String]()
        //arrayId = [String]()
        arraySelectItems = [[String:String]]()
        arraySelectItems = array
        if arraySelectItems.count > 0 {
            for item in arraySelectItems {
                isSelectCategory = true
                let dict = item
                let name = dict["name"]!
                let catId = dict["id"]!
                arrayName.append(name)
                arrayCategoryId.append(catId)
            }
            
            
            let strCategoryID = arrayCategoryId.map{String($0)}.joined(separator: ",")
            let strSelecterCategory = arrayName.map{String($0)}.joined(separator: ",")
//            strCategoryId = removeLastCharecter(strData: strCategoryID)
//            txtSelectCategory.text! = removeLastCharecter(strData: strSelecterCategory)
            strCategoryId = arrayCategoryId.map{String($0)}.joined(separator: ",")
            txtSelectCategory.text! = arrayName.map{String($0)}.joined(separator: ",")
            arraySetId = arrayCategoryId
            
            arrayImagesCategory.removeAllObjects()
            for each in strCategoryId{
                var dictionary =  [String:Any]()
                dictionary ["url"] = ""
                dictionary ["png"] = (UIImage(named: "ic_category_img")!)
                dictionary ["file"] = "image"
                dictionary ["isplaceHolder"] = "yes"
                arrayImagesCategory.add(dictionary)
            }
            
            print("txtSelectCategory: \(txtSelectCategory.text!),\n strCategoryId: \(strCategoryId),\n arraySetId: \(arraySetId),\n arrayImagesCategory: \(arrayImagesCategory)")
            
        
            viewSelectCategoryConstraints.constant = 128.0
            viewSelectCategory.isHidden = false
            collectinViewCategory.reloadData()
        }else{
            txtSelectCategory.text = ""
            viewSelectCategoryConstraints.constant = 0
            viewSelectCategory.isHidden = true
            //            btnselectCategoryNo.isSelected = true
            //            btnselectCategoryYes.isSelected = false
            //            isSelectCategory = false
        }
    }
    
    func removeLastCharecter(strData: String) -> String {
        var str = strData.dropLast()
        print("str: \(str)")
        return String(str)
    }
    
    func PasswordMatch() -> Bool {
        if txtPasssword.text! == txtConfirmPassword.text!{
            return true
        }
        else{ showAlert(title: ALERTMESSAGE, message: "Password did not match.")  }
        return false
    }
    func CallServiceForIndividualAPI() {
        //         if isIndividualSelected == true{
        //            individualAPI()
        //        // print(MyDefaults().swifarrayImages.count)
        //         }else{
        //            calllAPI()
        //        }
        UserDefaults.standard.set(true, forKey: "isDisplayIntroPage")
        UserDefaults.standard.synchronize()
//        calllAPI()
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MNIndividualSignupCompleteVC") as? MNIndividualSignupCompleteVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
/*    func calllAPI() {

     //   ShowHud()
ShowHud(view: self.view)
        var arrayImage =  [[String:Any]]()
        
        if isProfessional == true {
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
                "zip_code":txtZipCode.text!,
                "access_pin":txtEnterPin.text!,
                "login_type":MyDefaults().swifLoginType!,
                "device_type":C_device_type,
                "device_id":MyDefaults().UDeviceId!,
                "business_name":txtBusinessName.text!,
                "business_address":txtBusinessAddress.text!,
                "ssn_number":txtTaxId.text!,
                "service_category":strCategoryId,
                "is_professional":"1",
                "referral_code":txtRefferalCode.text!,
                "business_latitude":self.strLatitudeBusiness,
                "business_longitude": self.strLongitudeBusiness,
                "fb_id":facebookID,
                "apple_id":appleID,
                "google_id":googleID,
            
            ]
            
            if appDelegate().apparrayProfileImage.count > 0{
                var dictionary =  [String:Any]()
                 let image1 = appDelegate().apparrayProfileImage[0] as AnyObject
                dictionary ["png"] = (image1 as! UIImage)
                dictionary ["url"] = ""
                dictionary ["uploadfile"] = "profile_pic"
                dictionary ["type"] = "image"
                arrayImage.append(dictionary)
            }
            if kResume_1 == 210 {
                var dictionary =  [String:Any]()
                let image1 = uploadImages[0] as AnyObject
                dictionary ["png"] = (image1 as! UIImage)
                dictionary ["url"] = ""
                dictionary ["uploadfile"] = "resume"
                dictionary ["type"] = "image"
                arrayImage.append(dictionary)
                
            }else{
                var dictionary =  [String:Any]()
                let image1 = arrayUploadResume[0] as AnyObject
                dictionary ["png"] = ""
                dictionary ["url"] = (image1) as? URL
                dictionary ["uploadfile"] = "resume"
                dictionary ["type"] = "url"
                arrayImage.append(dictionary)
            }
            if kResume_2 == 211 {
                let image1 = govtuploadImages[0] as AnyObject
                var dictionary =  [String:Any]()
                dictionary ["url"] = ""
                dictionary ["png"] = (image1 as! UIImage)
                dictionary ["uploadfile"] = "goverment_id"
                dictionary ["type"] = "image"
                arrayImage.append(dictionary)
            }else{
                var dictionary =  [String:Any]()
                let image1 = arrayGovtidUpload[0] as AnyObject
                dictionary ["url"] = (image1) as? URL
                dictionary ["png"] = ""
                dictionary ["uploadfile"] = "goverment_id"
                dictionary ["type"] = "url"
                arrayImage.append(dictionary)
            }
            //dictionary ["uploadfile"] = "professional_proof_" + "(\(String(describing: index))"
            if kResume_3 == 212 {
               
                for i in 0..<arrayImagesCategory.count {
                    let dict = arrayImagesCategory[i] as![String:Any]
                    let placeHolder = dict["isplaceHolder"] as! String
                    if placeHolder == "no" {
                        let imageId = arraySetId[i]
                        let fileType = dict["file"] as! String
                        if fileType == "image" {
                            let image = dict["png"] as! UIImage
                            var dictionary =  [String:Any]()
                            dictionary ["url"] = ""
                            dictionary ["png"] = image
                            dictionary ["uploadfile"] = "professional_proof_" + imageId
                            dictionary ["type"] = "image"
                            arrayImage.append(dictionary)
                        }else{
                            let url = dict["url"] as! URL
                            var dictionary =  [String:Any]()
                            dictionary ["url"] = url
                            dictionary ["png"] = ""
                            dictionary ["uploadfile"] = "professional_proof_" + imageId
                            dictionary ["type"] = "url"
                            arrayImage.append(dictionary)
                        }
                    }
                    
}
                }
            print(arrayImage)
            print(parameter)
            HTTPService.callForProfessinalUploadMultipleImage(url:MNSignUpAPI, imageToUpload: arrayImage as [[String:Any]], parameters: parameter) { (response) in
                debugPrint(response)

              //  HideHud()
                HideHud(view: self.view)

                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
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
                }else
                {
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }
            }
        }else{
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
                "apple_id":appleID,
                "google_id":googleID,
                "business_name":txtBusinessName.text!,
                "business_address":txtBusinessAddress.text!,
                "ssn_number":txtTaxId.text!,
                "service_category":strCategoryId,
                "is_professional":"2",
                "referral_code":txtRefferalCode.text!,
                "business_latitude":self.strLatitudeBusiness ,
                "countryName":strCountry,
                "stateName":strState,
                "cityName":strCity,
                "business_longitude": self.strLongitudeBusiness
            ]
            if appDelegate().apparrayProfileImage.count > 0{
                var dictionary =  [String:Any]()
                let image1 = appDelegate().apparrayProfileImage[0] as AnyObject
                dictionary ["png"] = (image1 as! UIImage)
                dictionary ["url"] = ""
                dictionary ["uploadfile"] = "profile_pic"
                dictionary ["type"] = "image"
                arrayImage.append(dictionary)
            }
            if kResume_1 == 210 {
                var dictionary =  [String:Any]()
                let image1 = uploadImages[0] as AnyObject
                dictionary ["png"] = (image1 as! UIImage)
                dictionary ["url"] = ""
                dictionary ["uploadfile"] = "resume"
                dictionary ["type"] = "image"
                arrayImage.append(dictionary)
                
            }else{
                var dictionary =  [String:Any]()
                let image1 = arrayUploadResume[0] as AnyObject
                dictionary ["png"] = ""
                dictionary ["url"] = (image1) as? URL
                dictionary ["uploadfile"] = "resume"
                dictionary ["type"] = "url"
                arrayImage.append(dictionary)
            }
            if kResume_2 == 211 {
                let image1 = govtuploadImages[0] as AnyObject
                var dictionary =  [String:Any]()
                dictionary ["url"] = ""
                dictionary ["png"] = (image1 as! UIImage)
                dictionary ["uploadfile"] = "goverment_id"
                dictionary ["type"] = "image"
                arrayImage.append(dictionary)
            }else{
                var dictionary =  [String:Any]()
                let image1 = arrayGovtidUpload[0] as AnyObject
                dictionary ["url"] = (image1) as? URL
                dictionary ["png"] = ""
                dictionary ["uploadfile"] = "goverment_id"
                dictionary ["type"] = "url"
                arrayImage.append(dictionary)
            }
            if kResume_3 == 212 {
                
                for i in 0..<arrayImagesCategory.count {
                    let imageId = arraySetId[i]
                    let dict = arrayImagesCategory[i] as![String:Any]
                    let fileType = dict["file"] as! String
                    if fileType == "image" {
                        let image = dict["png"] as! UIImage
                        var dictionary =  [String:Any]()
                        dictionary ["url"] = ""
                        dictionary ["png"] = image
                        dictionary ["uploadfile"] = "professional_proof_" + imageId
                        dictionary ["type"] = "image"
                        arrayImage.append(dictionary)
                    }else{
                        let url = dict["url"] as! URL
                        var dictionary =  [String:Any]()
                        dictionary ["url"] = url
                        dictionary ["png"] = ""
                        dictionary ["uploadfile"] = "professional_proof_" + imageId
                        dictionary ["type"] = "url"
                        arrayImage.append(dictionary)
                    }
                }
            }
            print(arrayImage)
            print(parameter)
            HTTPService.callForProfessinalUploadMultipleImage(url:MNSignUpAPI,imageToUpload: arrayImage as [[String:Any]], parameters: parameter) { (response) in
                debugPrint(response)

               // HideHud()
HideHud(view: self.view)
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                   let responseData = response["details"] as! [String: Any]
                    MyDefaults().UserId = responseData["user_id"] as? String
                    MyDefaults().swifSignUpMobileNumber = self.txtMobileNumber.text!
                    if let cCode = responseData["country_code"]{
                        MyDefaults().swifCountryCode = "\(cCode)"
                    }
                    
                    MyDefaults().UserEmail = self.txtEmailAddress.text!
                    MyDefaults().swifLoginMPIN = self.txtEnterPin.text!
                    MyDefaults().UserId = responseData["user_id"] as? String
                    self.pushAccountVarification()
                    Toast(text: message).show()
                    //self.tblViewCountry?.reloadData()
                }else
                {
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }
            }
        }
    }
    
    func pushAccountVarification() {
        let mobile = self.storyboard?.instantiateViewController(withIdentifier: "MNMobileVarificationVC") as! MNMobileVarificationVC
        self.navigationController?.pushViewController(mobile, animated: true)
    }*/
}
extension MNProfessionalSignupVC: UITextFieldDelegate {
    
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
        
        if txtZipCode == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 8
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
        
        if txtPasssword == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            //return NSPredicate(format: "SELF MATCHES %@", regexPassword).evaluate(with: string)
            return count <= 12
            
            // let regex = "[a-z]{1,}"
            
            
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
        if txtBusinessName == textField {
                guard let textFieldText = textField.text,
                    let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                        return false
                }
                let substringToReplace = textFieldText[rangeOfTextToReplace]
                let count = textFieldText.count - substringToReplace.count + string.count
                return count <= 40
            }
        if txtTaxId == textField {
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
            txtZipCode.resignFirstResponder()
        case txtEnterPin:
            txtReenterPin.becomeFirstResponder()
        case txtReenterPin:
            txtReenterPin.resignFirstResponder()
        case txtBusinessName:
            txtBusinessAddress.becomeFirstResponder()
        case txtBusinessAddress:
            txtTaxId.becomeFirstResponder()
        case txtTaxId:
            txtTaxId.resignFirstResponder()
        case txtRefferalCode:
            txtRefferalCode.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
}
extension MNProfessionalSignupVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.arraySelectItems.count)
        return self.arraySelectItems.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
        if arrayImagesCategory.count > 0{
            //            cell.imgCategory.image = self.arrayImagesCategory[indexPath.item] as? UIImage
            //            cell.btnCross.tag = indexPath.row
            //            cell.btnCross.addTarget(self, action: #selector(clickOnCross(sender:)), for: .touchUpInside)
            //            if cell.imgCategory.image == imagePlaceholder {
            //                cell.btnCross.isHidden = true
            //                cell.imgCategory.image = UIImage(named: "ic_category_img")
            //            }else{
            //                cell.imgCategory.image = self.arrayImagesCategory[indexPath.item] as? UIImage
            //                 cell.btnCross.isHidden = false
            //            }
            
            if indexPath.item < self.arrayImagesCategory.count{
                let dict = self.arrayImagesCategory[indexPath.item] as! [String:Any]
                print(dict)
                let fileType = dict["file"] as! String
                let isPlaceHolder = dict["isplaceHolder"] as! String
                if fileType == "image" {
                    
                    if isPlaceHolder == "yes" {
                        cell.btnCross.isHidden = true
                        cell.imgCategory.image = dict["png"] as? UIImage
                    }else{
                        cell.imgCategory.image = dict["png"] as? UIImage
                        cell.btnCross.isHidden = false}
                }else{
                    if isPlaceHolder == "yes" {
                        cell.btnCross.isHidden = true
                        cell.imgCategory.image = dict["png"] as? UIImage
                    }else{
                        cell.imgCategory.image = UIImage.init(named: "ic_category_doc")
                        cell.btnCross.isHidden = false}
                    
                }
                cell.btnCross.tag = indexPath.row
                cell.btnCross.addTarget(self, action: #selector(clickOnCross(sender:)), for: .touchUpInside)
            }
        }
        return cell
    }
    @objc func clickOnCross(sender : UIButton){
        print(sender.tag)
        self.alertforDeleteCategory(tagValue: sender.tag)
    }
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.getProfileImages(tag: indexPath.row)
    }
    func getProfileImages(tag:Int) {
        self.view.endEditing(true)
        //               ImagePickerManager().pickImage(self){ image in
        //               self.arrayImagesCategory.replaceObject(at: tag, with: image)
        //               self.collectinViewCategory.reloadData()
       self.btnUploadGovtId.tag = 0
       self.btnUploadResume.tag = 0
        kResume_3 = 212
        tagForCollectionCell = tag
        self.showSimpleActionSheet(controller: self, tagValue: tag)
        //}
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  0
        //let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: 104 - padding, height: 96)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = 104 * 3
        let totalSpacingWidth = 10 * (3 - 1)
        let leftInset = (collectionView.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func alertforDeleteCategory(tagValue : Int) {
        let alertController = UIAlertController(title: ALERTMESSAGE, message: "Do you want to delete category.", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.deleteCategory(tag: tagValue)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        // self.DeleteCarRagistration(tag: tagValue)
    }
    func deleteCategory(tag : Int) {
        self.deleteCategoryFormList(categoryId: tag)
    }
    func deleteCategoryFormList(categoryId:Int) {
        if self.arrayImagesCategory.count > 0{
            var dictionary1 =  [String:Any]()
            dictionary1 ["url"] = ""
            dictionary1 ["png"] = (UIImage(named: "ic_category_img")!)
            dictionary1 ["file"] = "image"
            dictionary1 ["isplaceHolder"] = "yes"
            self.arrayImagesCategory.replaceObject(at: categoryId, with: dictionary1)
            self.collectinViewCategory.reloadData()
        }
    }
}

extension MNProfessionalSignupVC: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        //    self.uploadImages  = NSMutableArray()
        //    self.govtuploadImages  = NSMutableArray()
        
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
            
            if  btnUploadResume.tag == 10001{
                self.arrayUploadResume.add(filePath)
                self.kResume_1 = 0
                isUploadImage = true
                btnCrossUploadResume.isHidden = false
                // btnCrossUploadResume.isHidden = false
                self.imgUploadImage.contentMode = .scaleAspectFit
                self.imgUploadImage.image = UIImage.init(named: "ic_category_doc")
                
            } else  if  btnUploadGovtId.tag == 10002{
                self.arrayGovtidUpload.add(filePath)
                self.kResume_2 = 0
                isUploadGovtId = true
                self.imgGovtUploadImage.image = UIImage.init(named: "ic_category_doc")
                self.imgGovtUploadImage.contentMode = .scaleAspectFit
                btnCrossUploadGovtId.isHidden = false
                
            } else  if kResume_3 == 212 {
                //self.arrayGovtidUpload.add(filePath)
                // self.kResume_3 = 0
                //  self.arrayImagesCategory.replaceObject(at: tagForCollectionCell, with: filePath)
                
                var dictionary1 =  [String:Any]()
                dictionary1 ["url"] = filePath
                dictionary1 ["png"] = ""
                dictionary1 ["file"] = "url"
                dictionary1 ["isplaceHolder"] = "no"
                //self.arrayImagesCategory.add(dictionary1)
                self.arrayImagesCategory.replaceObject(at: tagForCollectionCell, with: dictionary1)
                self.collectinViewCategory.reloadData()
                //kResume_3 = 0
                //self.isSelectCataegoryImage = true
                self.collectinViewCategory.reloadData()
                
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
  // MARK: Open camera
    func openCamera(tag:Int) {
        self.view.endEditing(true)
        if tag == 99 {
            if  btnUploadResume.tag == 10001{
                self.uploadImages = [UIImage]()
                    ImagePickerManager().pickImage(self){ image in
                    self.imgGovtUploadImage.contentMode = .scaleToFill
                    self.imgUploadImage.image = image
                    self.uploadImages.append(image)
                    self.btnUploadResume.setImage(nil, for: .normal)
                    self.kResume_1 = 210
                    self.btnCrossUploadResume.isHidden = false
                    self.isUploadImage = true
                       
                }
            } else  if  btnUploadGovtId.tag == 10002{
                self.govtuploadImages = [UIImage]()
                    ImagePickerManager().pickImage(self){ image in
                    self.imgGovtUploadImage.contentMode = .scaleToFill
                    self.imgGovtUploadImage.image = image
                    self.govtuploadImages.append(image)
                    self.btnUploadGovtId.setImage(nil, for: .normal)
                    self.kResume_2 = 211
                    self.btnCrossUploadGovtId.isHidden = false
                    self.isUploadGovtId = true
                        
                }
            }
        }else{
            self.govtuploadImages = [UIImage]()
            ImagePickerManager().pickImage(self){ image in
                self.kResume_2 = 212
                var dictionary1 =  [String:Any]()
                dictionary1 ["url"] = ""
                dictionary1 ["png"] = image
                dictionary1 ["file"] = "image"
                dictionary1 ["isplaceHolder"] = "no"
                self.govtuploadImages.append(image)
                self.arrayImagesCategory.add(dictionary1)
                self.isSelectCataegoryImage = true
                self.arrayImagesCategory.replaceObject(at: tag, with: dictionary1)
                self.collectinViewCategory.reloadData()
            }
        }
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
    
    func showSimpleActionSheet(controller: UIViewController,tagValue:Int) {
        let alert = UIAlertController(title: ALERTMESSAGE, message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera/Gallery", style: .default, handler: { (_) in
            print("User click Approve button")
            self.openCamera(tag: tagValue)
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
    func openDocumnets() {
        //let types : [String] = ["public.image", "com.microsoft.word.doc", kUTTypePDF] as! [String]
        let picker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc"], in: .open)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        self.present(picker, animated: true, completion: nil)
    }
    func arrayToJsonStr(_ object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return ""
    }
    
    func jsonStrToObject(_ jsonText: String) -> Any? {
        var dictonary:[String:AnyObject]?
        
        if let data = jsonText.data(using: String.Encoding.utf8) {
            do {
                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                return dictonary
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}

extension MNProfessionalSignupVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        let dLatitude = place.coordinate.latitude
        let dLongitude = place.coordinate.longitude
        
        if isFromBusinessAddress{
            self.strLatitudeBusiness = String(dLatitude)
            self.strLongitudeBusiness = String(dLongitude)
            self.txtBusinessAddress.text = place.formattedAddress!
        }else{
            self.strLatitude = String(dLatitude)
            self.strLongitude = String(dLongitude)
            self.txtStreetAddress.text = place.formattedAddress!
        }
        
        let objPlace = GoogleLocation().extractFromGooglePlcae(place: place)
        
        print("city: \(objPlace.city), country: \(objPlace.state), state: \(objPlace.state),strZipCode: \(objPlace.postalCode ?? "000000") ")
        
        strCity = objPlace.city ?? ""
        strState = objPlace.state ?? ""
        strCountry = objPlace.country ?? ""
        strZipCode = objPlace.postalCode ?? "000000"
        
        
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

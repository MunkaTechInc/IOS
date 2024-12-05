//
//  MNProfessionalSignupCompleteVC.swift
//  Munka
//
//  Created by keshav on 26/10/23.
//  Copyright © 2023 Amit. All rights reserved.
//

import UIKit
import Toaster


class ProfessionalSingUpData {
    static let shared = ProfessionalSingUpData()
    
    var user_type = ""
    var first_name = ""
    var last_name = ""
    var mobile = ""
    var email = ""
    var password = ""
    var country_id = ""
    var state_id = ""
    var city_id = ""
    var address = ""
    var latitude = ""
    var longitude = ""
    var businessLatitude = ""
    var businessLongitude = ""
    var zip_code = ""
    var access_pin = ""
    var login_type = ""
    var device_type = ""
    var device_id = ""
    var fb_id = ""
    var google_id = ""
    var apple_id = ""
    var profile_type = ""
    var countryName = ""
    var stateName = ""
    var cityName = ""
    var strCategoryId = ""
    var arrSelectedShift = [DayShiftDetail]()
    var arraySetId = [String]()

}



class MNProfessionalSignupCompleteVC: UIViewController {


    @IBOutlet weak var txtTaxId: DTTextField!
    @IBOutlet weak var txtBusinessName: DTTextField!
    @IBOutlet weak var txtBusinessAddress: DTTextField!
    @IBOutlet weak var imgUploadImage: UIImageView!
    @IBOutlet weak var imgGovtUploadImage: UIImageView!
    @IBOutlet weak var btnUploadResume: UIButton!
    @IBOutlet weak var btnUploadGovtId: UIButton!
    @IBOutlet weak var btnCrossUploadResume: UIButton!
    @IBOutlet weak var btnCrossUploadGovtId: UIButton!
    @IBOutlet weak var txtRefferalCode: IBTextField!
    
    @IBOutlet weak var lblSSNRequired: UILabel!
    //    @IBOutlet weak var collectinViewCategory: UICollectionView!

    
    var kResume_1 : Int       = 0
    var kResume_2 : Int       = 0
    var kResume_3 : Int       = 0
    var tagForCollectionCell : Int       = 0

    var arrayImagesCategory = NSMutableArray()
    var arrayUploadResume = NSMutableArray()
    var arrayGovtidUpload = NSMutableArray()
    var uploadImages = [UIImage]()
    var govtuploadImages = [UIImage]()
    var arraySetId = [String]()
    var arraySelectItems = [[String:String]]()

    var isUploadImage = false
    var isUploadGovtId = false
    var isOnClickUploadResume = false
    var isProfessional = false

    var strSelectedShiftTime = String ()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        convertArrayIntoString()
        
        lblSSNRequired.isHidden = true
        print("kResume_1: \(kResume_1),kResume_2: \(kResume_2), kResume_3: \(kResume_3)")
//        arraySetId = ProfessionalSingUpData.shared
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        if !checkSignUpValidationOnSubmit() {
            if  isConnectedToInternet() {
                for textField in self.view.subviews where textField is UITextField {
                    textField.resignFirstResponder()
                }
                CallServiceForIndividualAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: ALERTMESSAGE)
            }
        }
        // CallServiceForIndividualAPI()
    }
    @IBAction func actionGovtUploadPhoto(_ sender: UIButton) {
        btnUploadGovtId.tag = 10002
        btnUploadResume.tag = 0
        isOnClickUploadResume = false
        self.showSimpleActionSheet(controller: self, tagValue: 99)
    }
    @IBAction func actionUploadPhoto(_ sender: UIButton) {
        btnUploadResume.tag = 10001
        btnUploadGovtId.tag = 0
        isOnClickUploadResume = true
        self.showSimpleActionSheet(controller: self, tagValue: 99)
    }
    
    @IBAction func actionPhotoCross(_ sender: UIButton) {
        uploadImages = [UIImage]()
        self.imgUploadImage.image = UIImage.init(named: "ic_category_img")
        self.btnCrossUploadResume.isHidden = true
    }

    @IBAction func actionGovtCross(_ sender: UIButton) {
        govtuploadImages = [UIImage]()
        self.imgGovtUploadImage.image = UIImage.init(named: "ic_category_img")
        self.btnCrossUploadGovtId.isHidden = true
    }
    
    func convertArrayIntoString(){
        for data in  ProfessionalSingUpData.shared.arrSelectedShift{
            
            var strDay = String()
            var strShift = String()
            var strStartTime = String()
            var strEndTime = String()
           
            strDay = "\"day\"" + ":" + "\"\(data.headerTitle)\""
            strShift = "\"shift\"" + ":" + "\"\(data.shift ?? "")\""
            strStartTime = "\"start_time\"" + ":" + "\"\(data.StartTime ?? "")\""
            strEndTime = "\"end_time\"" + ":" + "\"\(data.EndTime ?? "")\""
            
            if strSelectedShiftTime == ""{
          

                strSelectedShiftTime = "{\(strDay),\(strShift),\(strStartTime),\(strEndTime)}"
            }else{
                strSelectedShiftTime = "\(strSelectedShiftTime)," + "{\(strDay),\(strShift),\(strStartTime),\(strEndTime)}"
            }
        }
        
        strSelectedShiftTime = "[\(strSelectedShiftTime)]"
        
        print("strShiftData: \(strSelectedShiftTime)")
    }
}

extension MNProfessionalSignupCompleteVC: UIDocumentPickerDelegate {
    
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
                //kResume_3 = 0
                //self.isSelectCataegoryImage = true
//                self.collectinViewCategory.reloadData()
                
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
               // self.govtuploadImages.append(image)
                //self.arrayImagesCategory.add(dictionary1)
               // self.isSelectCataegoryImage = true
                self.arrayImagesCategory.replaceObject(at: tag, with: dictionary1)
            }
        }
    }
    func createFolder(_ folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Construct a URL with desired folder name
        let folderURL = MNProfessionalSignupCompleteVC.self.getDocumentsDirectory().appendingPathComponent(folderName)
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
extension MNProfessionalSignupCompleteVC{
    
    func checkSignUpValidationOnSubmit() -> Bool {
        
        /*guard let ssn = txtTaxId.text , ssn != ""
            else {
            lblSSNRequired.text! =  "* Required to receive payout"
            lblSSNRequired.isHidden = false
                //showAlert(title: ALERTMESSAGE, message: "Please enter first name.")
                return true}*/
        guard isUploadImage == true else {
            showAlert(title: ALERTMESSAGE, message: "Please upload Resume.")
            return true
        }
        guard isUploadGovtId == true else {
            showAlert(title: ALERTMESSAGE, message: "Please upload Govt. id proof.")
            return true
        }
        return false
    }
    
    func CallServiceForIndividualAPI() {

        UserDefaults.standard.set(true, forKey: "isDisplayIntroPage")
        UserDefaults.standard.synchronize()
        calllAPI()
    }
    func calllAPI() {
        
        ShowHud(view: self.view)
        var arrayImage =  [[String:Any]]()
        
        if isProfessional == true {
            let parameter: [String: Any] = [
                "user_type":MyDefaults().swiftUserType!,
                "first_name": ProfessionalSingUpData.shared.first_name,
                "last_name":ProfessionalSingUpData.shared.last_name,
                "mobile":ProfessionalSingUpData.shared.mobile,
                "email":ProfessionalSingUpData.shared.email,
                "password":ProfessionalSingUpData.shared.password,
                "country_id":"231",
                "state_id":ProfessionalSingUpData.shared.state_id,
                "city_id":ProfessionalSingUpData.shared.city_id,
                "address":ProfessionalSingUpData.shared.address,
                "latitude":ProfessionalSingUpData.shared.latitude,
                "longitude":ProfessionalSingUpData.shared.latitude,
                "zip_code":ProfessionalSingUpData.shared.zip_code,
                "access_pin":ProfessionalSingUpData.shared.access_pin,
                "login_type":MyDefaults().swifLoginType!,
                "device_type":C_device_type,
                "device_id":MyDefaults().UDeviceId!,
                "business_name":txtBusinessName.text!,
                "business_address":txtBusinessAddress.text!,
//                "ssn_number":txtTaxId.text!,
                "service_category":ProfessionalSingUpData.shared.strCategoryId,
                "is_professional":"1",
                "referral_code":txtRefferalCode.text!,
                "business_latitude":ProfessionalSingUpData.shared.businessLatitude,
                "business_longitude": ProfessionalSingUpData.shared.businessLongitude,
                "fb_id":ProfessionalSingUpData.shared.fb_id,
                "apple_id":ProfessionalSingUpData.shared.apple_id,
                "google_id":ProfessionalSingUpData.shared.google_id,
                "shiftList": strSelectedShiftTime
            ]
            
            print("dict : \(parameter)")
            
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
                    if placeHolder != "no" {
                        
                        if  arraySetId.count > i{
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
                    MyDefaults().swifSignUpMobileNumber = ProfessionalSingUpData.shared.mobile
//                    self.txtMobileNumber.text!
                    
                    if let cCode = responseData["country_code"]{
                        MyDefaults().swifCountryCode = "\(cCode)"
                    }
                    
                    MyDefaults().UserEmail = ProfessionalSingUpData.shared.email
                    //self.txtEmailAddress.text!
                    MyDefaults().swifLoginMPIN = ProfessionalSingUpData.shared.access_pin
                    //self.txtEnterPin.text!
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
                "first_name":ProfessionalSingUpData.shared.first_name,
                "last_name":ProfessionalSingUpData.shared.last_name,
                "mobile":ProfessionalSingUpData.shared.mobile,
                "email":ProfessionalSingUpData.shared.email,
                "password":ProfessionalSingUpData.shared.password,
                "country_id":"231",
                "state_id":ProfessionalSingUpData.shared.state_id,
                "city_id":ProfessionalSingUpData.shared.city_id,
                "address":ProfessionalSingUpData.shared.address,
                "latitude":ProfessionalSingUpData.shared.latitude,
                "longitude":ProfessionalSingUpData.shared.longitude,
                "zip_code":ProfessionalSingUpData.shared.zip_code,
                "access_pin":ProfessionalSingUpData.shared.access_pin,
                "login_type":MyDefaults().swifLoginType!,
                "device_type":C_device_type,
                "device_id":MyDefaults().UDeviceId!,
                "fb_id":ProfessionalSingUpData.shared.fb_id,
                "apple_id":ProfessionalSingUpData.shared.apple_id,
                "google_id":ProfessionalSingUpData.shared.google_id,
                "business_name":txtBusinessName.text!,
                "business_address":txtBusinessAddress.text!,
//                "ssn_number":txtTaxId.text!,
                "service_category":ProfessionalSingUpData.shared.strCategoryId,
                "is_professional":"2",
                "referral_code":txtRefferalCode.text!,
                "business_latitude": ProfessionalSingUpData.shared.businessLatitude,
                "countryName":ProfessionalSingUpData.shared.countryName,
                "stateName":ProfessionalSingUpData.shared.stateName,
                "cityName":ProfessionalSingUpData.shared.cityName,
                "business_longitude":  ProfessionalSingUpData.shared.businessLongitude,
                "shiftList": strSelectedShiftTime

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
                    if arraySetId.count > i{
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
                    MyDefaults().swifSignUpMobileNumber = ProfessionalSingUpData.shared.mobile //self.txtMobileNumber.text!
                    if let cCode = responseData["country_code"]{
                        MyDefaults().swifCountryCode = "\(cCode)"
                    }
                    
                    MyDefaults().UserEmail = ProfessionalSingUpData.shared.email
                    MyDefaults().swifLoginMPIN = ProfessionalSingUpData.shared.access_pin
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
    }
}
/*
extension MNProfessionalSignupCompleteVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
//            self.collectinViewCategory.reloadData()
        }
    }
}*/
/*
extension MNProfessionalSignupCompleteVC: UIDocumentPickerDelegate {
    
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
               // self.govtuploadImages.append(image)
                //self.arrayImagesCategory.add(dictionary1)
               // self.isSelectCataegoryImage = true
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
*/

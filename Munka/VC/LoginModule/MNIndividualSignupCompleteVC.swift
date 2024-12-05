//
//  MNIndividualSignupCompleteVC.swift
//  Munka
//
//  Created by keshav on 26/10/23.
//  Copyright © 2023 Amit. All rights reserved.
//

import UIKit
import Toaster

class IndividualSingUpData {
    static let shared = IndividualSingUpData()
    
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
    
}



class MNIndividualSignupCompleteVC: UIViewController {
    
    @IBOutlet weak var txtLLC: DTTextField!
    @IBOutlet weak var txtSsnNumber: DTTextField!
    @IBOutlet weak var lblRequiredPayout: UILabel!
    @IBOutlet weak var txtTradeName: DTTextField!
    @IBOutlet weak var txtTaxId: DTTextField!
    @IBOutlet weak var imgLience: UIImageView!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var txtReferralCode: IBTextField!
        
    var isIndividualSelected = true
    var arrayImages = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("IndividualSingUpData: \(IndividualSingUpData.shared.email)")
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
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    @IBAction func actionOCross(_ sender: UIButton) {
        arrayImages = [[String:Any]]()
        self.imgLience.image = UIImage.init(named: "ic_category_img")
        self.btnCross.isHidden = true
    }
    
    
    @IBAction func actionUploadPhoto(_ sender: UIButton) {
        // dictPhoto = [String:UIImage]()
        
        self.showSimpleActionSheet(controller: self, tagValue: 100)
        
    }
    func checkSignUpValidationOnSubmit() -> Bool {
        
        if isIndividualSelected == true{
            guard let llcNumber = txtLLC.text , llcNumber != ""
                else {
                    txtLLC.showError(message: "Please enter Legal name.")
                    return true}
            return false
        }

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
    
    }
    
}
extension MNIndividualSignupCompleteVC{
    
    
    //MARK:- Call API
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
            "first_name":IndividualSingUpData.shared.first_name,
            "last_name":IndividualSingUpData.shared.last_name,
            "mobile":IndividualSingUpData.shared.mobile,
            "email":IndividualSingUpData.shared.email,
            "password":IndividualSingUpData.shared.password,
            "country_id":"231",
            "state_id":IndividualSingUpData.shared.state_id,
            "city_id":IndividualSingUpData.shared.city_id,
            "address":IndividualSingUpData.shared.address,
            "latitude":IndividualSingUpData.shared.latitude,
            "longitude":IndividualSingUpData.shared.longitude,
            "zip_code":IndividualSingUpData.shared.zip_code,
            "access_pin":IndividualSingUpData.shared.access_pin,
            "login_type":MyDefaults().swifLoginType!,
            "device_type":C_device_type,
            "device_id":MyDefaults().UDeviceId!,
            "fb_id":IndividualSingUpData.shared.fb_id,
            "google_id":IndividualSingUpData.shared.google_id,
            "apple_id":IndividualSingUpData.shared.apple_id,
            "profile_type":MyDefaults().swifProfileType!,
            "llc_number":txtLLC.text!,
//            "ssn_number":txtSsnNumber.text!,
            "business_name":txtTradeName.text!,
            "tax_id":txtTaxId.text!,
            "countryName":IndividualSingUpData.shared.countryName,
            "stateName":IndividualSingUpData.shared.stateName,
            "cityName":IndividualSingUpData.shared.cityName,
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
                print(responseData)
                MyDefaults().swifSignUpMobileNumber = IndividualSingUpData.shared.mobile
                //self.txtMobileNumber.text!//#DR check
                
                if let cCode = responseData["country_code"]{
                    MyDefaults().swifCountryCode = "\(cCode)"
                }
                MyDefaults().UserEmail = IndividualSingUpData.shared.email
                MyDefaults().swifLoginMPIN = IndividualSingUpData.shared.access_pin
                
                self.pushAccountVarification()
                Toast(text: message).show()
                //self.tblViewCountry?.reloadData()
            }else
            {
                let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                   // self.clickOnYesAlert()
                    if message == "Email address already in use. Please verify your account to proceed." || message == "Mobile number already in use. Please verify your account to proceed."{
                        MyDefaults().swifSignUpMobileNumber = IndividualSingUpData.shared.mobile
                        MyDefaults().UserEmail = IndividualSingUpData.shared.email
                        MyDefaults().swifLoginMPIN = IndividualSingUpData.shared.access_pin
                        self.pushAccountVarification()
                        Toast(text: message).show()
                    }else{
                        self.showErrorPopup(message: message, title: alert)
                    }
                }
                // Add the actions
                alertController.addAction(okAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
                
            }
        }
    }
    
    func pushAccountVarification() {
        let mobile = self.storyboard?.instantiateViewController(withIdentifier: "MNMobileVarificationVC") as! MNMobileVarificationVC
        self.navigationController?.pushViewController(mobile, animated: true)
    }
}

extension MNIndividualSignupCompleteVC{
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
extension MNIndividualSignupCompleteVC: UIDocumentPickerDelegate {
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

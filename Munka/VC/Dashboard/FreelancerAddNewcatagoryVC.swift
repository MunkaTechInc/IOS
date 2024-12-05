//
//  FreelancerAddNewcatagoryVC.swift
//  Munka
//
//  Created by Amit on 05/05/20.
//  Copyright © 2020 Amit. All rights reserved.
//

import UIKit
import Toaster

    
class FreelancerAddNewcatagoryVC: UIViewController,GetSelectCategoryOnPostJob,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var viewimage : UIView!
    @IBOutlet weak var viewimageHight : NSLayoutConstraint!
   @IBOutlet weak var imgview : UIImageView!
    @IBOutlet weak var btnOnImage : UIButton!
    @IBOutlet weak var btnClose : UIButton!
    @IBOutlet weak var txtCategory : UITextField!
    var serviceCategory = ""
    var arrayImages = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewimage.isHidden = true
        self.viewimageHight.constant = 0
        self.btnClose.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionOnBack(_ sender: UIButton) {
           self.self.navigationController?.popViewController(animated: true)
       }
    @IBAction func actionOnClose(_ sender: UIButton) {
      //  self.self.navigationController?.popViewController(animated: true)
        arrayImages = [[String:Any]]()
        self.imgview.image = nil
        self.imgview.contentMode = .scaleAspectFit
        self.imgview.image = UIImage.init(named: "ic_category_img")
        self.btnClose.isHidden = true
    
    }
    @IBAction func actionOnAddService(_ sender: UIButton) {
        //self.self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionOnCamera(_ sender: UIButton) {
      self.showSimpleActionSheet(controller: self, tagValue: 100)
    }
    @IBAction func actionOnDropDown(_ sender: UIButton) {
           let popup : PostJobSelectcategoryPopUpVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "PostJobSelectcategoryPopUpVC") as! PostJobSelectcategoryPopUpVC
                                popup.delagate = self
                    //        popup.isClickOnSignUp = false
                            self.presentOnRoot(with: popup)
       }
    
    
    @IBAction func actionOnUpdate(_ sender: UIButton) {
        //self.self.navigationController?.popViewController(animated: true)
         
    
    if !isLoginValidation() {
           if  isConnectedToInternet() {
               self.callServicEditCategoryAPI(servicecategoryid: serviceCategory)
           } else {
               self.showErrorPopup(message: internetConnetionError, title: alert)
           }
       }
    
    }
    func isLoginValidation() -> Bool {
           guard let email = txtCategory.text , email != ""
               else {showAlert(title: ALERTMESSAGE, message: "Please enter category.")
                   return true}
           
           return false
       }
    func delegateselectPostJobcategory(array: [[String : Any]]) {
        
        self.viewimage.isHidden = false
        self.viewimageHight.constant = 83
        let dict = array[0]
        self.txtCategory.text = dict["name"] as? String
        serviceCategory = dict["id"] as! String
        
      //  self.callServicEditCategoryAPI(servicecategoryid: servicecategoryid as! String)
    }
    func callServicEditCategoryAPI(servicecategoryid:String) {
        
        
        ShowHud(view: self.view)
           print(MyDefaults().UserId ?? "")
            let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                          "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                          "category_id":servicecategoryid]
             debugPrint(parameter)
        

                // HTTPService.callForProfessinalUploadMultipleImage(url: MNAddServiceAPI, imageParameter:"professional proof",imageToUpload: self.imgview.image!, parameters: parameter) { (response) in
        HTTPService.callForProfessinalUploadMultipleImage(url: MNAddServiceAPI, imageToUpload: self.arrayImages, parameters: parameter){ (response) in
                        // HideHud()
             HideHud(view: self.view)
                         if response.count != nil {
                         let status = response["status"] as! String
                         let message = response["msg"] as! String
                         if status == "1"
                         {
                             print(response)
             //                let dictResponse = response["details"] as! [String:Any]
             //                self.sendImageMsg(message:dictResponse["message"] as! String, created: getCurrentShortDate())
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
       
           
            func showSimpleActionSheet(controller: UIViewController,tagValue:Int) {
                      

                let alert = UIAlertController(title: "Munka", message: "Please Select an option", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                        self.getImage(fromSourceType: .camera)
                    }))

                    alert.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (_) in
                        self.getImage(fromSourceType: .photoLibrary)
                    }))
                    alert.addAction(UIAlertAction(title: "Documents", style: .default, handler: { (_) in
                          self.openDocumnets()
                       }))

                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel
                        , handler: { (_) in
                            // print("User click Dismiss button")
                    }))

                    self.present(alert, animated: true, completion: {
                    print("completion block")
                    })
            }
        func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
               if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                   let imagePickerController = UIImagePickerController()
                   imagePickerController.delegate = self
                   imagePickerController.sourceType = sourceType
                   self.present(imagePickerController, animated: true, completion: nil)
               }
           }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
            if let chosenImage = info[.originalImage] as? UIImage{
               self.imgview.image = chosenImage
               self.imgview.contentMode = .scaleAspectFill
               var dictionary1 =  [String:Any]()
               dictionary1 ["url"] = ""
               dictionary1 ["png"] = chosenImage
               dictionary1 ["file"] = "image"
               dictionary1 ["uploadfile"] = "professional proof"
               dictionary1 ["type"] = "image"
               self.btnClose.isHidden = false
               self.arrayImages.append(dictionary1)
               picker.dismiss(animated: true, completion: nil)
           }
        }
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
              print("picker cancel.")
           picker.dismiss(animated: true, completion: nil)
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
          extension FreelancerAddNewcatagoryVC: UIDocumentPickerDelegate {
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
                     dictionary1 ["uploadfile"] = "professional proof"
                    
                      self.arrayImages.append(dictionary1)
                      self.imgview.contentMode = .scaleAspectFill
                      self.imgview.image = UIImage.init(named: "ic_category_doc")
                      self.btnClose.isHidden = false
                      
                  }
                  catch {
                      print(error.localizedDescription)
                  }
              }
              
              //MARK:- Open Camera
             


      }


    


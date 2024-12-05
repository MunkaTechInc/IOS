//
//  ChatViewControllerExtension.swift
//  Munka
//
//  Created by Puneet Sharma on 13/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import JSQMessagesViewController


class CustomJSQMessage: JSQMessage {
    var customDate: Date
    
    override init(senderId: String?, senderDisplayName: String?, date: Date?, text: String?) {
        self.customDate = date ?? Date()
        super.init(senderId: senderId, senderDisplayName: senderDisplayName, date: self.customDate, text: text)
    }
    
    override init(senderId: String, senderDisplayName: String, date: Date?, media: JSQMessageMediaData) {
        self.customDate = date ?? Date()
        super.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, media: media)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK:- Set Initial data
extension ChatViewController{
    func setInitialUI(){
        self.viewContentFullScreenImage.isHidden = true
        self.viewContentDocumentFullScreen.isHidden = true
    }
}
//MARK:- Hide Show Full Screen Image
extension ChatViewController{
    func hideShowFullScreenImage(view: UIView,isHidden:Bool){
        UIView.transition(with: view, duration: 0.1, options: .transitionCrossDissolve, animations: {
            view.isHidden = isHidden
        })
    }
}
//MARK:- Send Text Message
extension ChatViewController{
    func getCurrentDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    func sendTextMsg(){
        let currentDateTimeString = getCurrentDateTime()
        
        if self.messageText.count > 0 {
            let dictMessage = ["sender_id":self.sender_id,"receiver_id":self.receiver_Id,"message":self.messageText,"job_id":self.job_Id,"type":"Text","file_type":"","created":getCurrentShortDate()]
            print(dictMessage)
            SocketIOManager.sharedInstance.establishConnection()
            SocketIOManager.socket.emit("send_message", dictMessage)
            tfMessage.text! = ""
            self.arrChatMessage.append(dictMessage)
            var message: CustomJSQMessage?
            message = CustomJSQMessage(senderId: self.sender_id, senderDisplayName: "", date: self.dateFromString(dateString: currentDateTimeString), text: self.messageText)
            if let message = message {
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.scrollToBottom(animated: true)
                }
            }
            
            //            self.tblViewChatList.reloadData()
            //            if self.arrChatMessage.count > 0{
            //            let indexPath = NSIndexPath(row: self.arrChatMessage.count-1, section: 0)
            //            UIView.transition(with: self.tblViewChatList, duration: 0.5, options: .beginFromCurrentState, animations: {
            //            self.tblViewChatList.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
            //                                              })
            
            //            }
        }
    }
}

//MARK:- Send Documents Message
extension ChatViewController{
    func sendDocumentsMsg(message:String,file_type:String,original_file_name:String,created:String){
        let dictMessage = ["sender_id":self.sender_id,"receiver_id":self.receiver_Id,"message":message,"type":"Document","file_type":file_type,"original_file_name":original_file_name,"created":created]
        SocketIOManager.socket.emit("send_message", dictMessage)
        self.arrChatMessage.append(dictMessage)
        
        let documentImage = UIImage(named: "doc_file") // Your document icon image
        let documentItem = CustomDocumentMediaItem()
        documentItem.documentImage = documentImage
        documentItem.fileName = original_file_name // File name here
        documentItem.senderId = self.sender_id
        let urlDocument = URL(string:chat_img_BASE_URL + message)
        documentItem.documentURL = urlDocument
        documentItem.delegate = self
        let documentMessage = CustomJSQMessage(senderId: self.sender_id, senderDisplayName: "", date: self.dateFromString(dateString: created)!, media: documentItem)
        
        self.messages.append(documentMessage)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.scrollToBottom(animated: true)
        }
        
    }
}
//MARK:- Send Image Message
extension ChatViewController{
    func sendImageMsg(message:String,created:String){
        let dictMessage = ["sender_id":self.sender_id,"receiver_id":self.receiver_Id,"message":message,"type":"Image","file_type":"png","created":created]
        SocketIOManager.socket.emit("send_message", dictMessage)
        print(dictMessage)
        self.arrChatMessage.append(dictMessage)
        var mesage: CustomJSQMessage?
        
        let photo = JSQPhotoMediaItem()
        if let url = NSURL(string:chat_img_BASE_URL + message){
            guard let data = NSData(contentsOf: url as URL) else{ return }
            let image = UIImage(data: data as Data)
            photo.image = image
            photo.appliesMediaViewMaskAsOutgoing = true
            mesage = CustomJSQMessage(senderId: self.sender_id, senderDisplayName: "", date: self.dateFromString(dateString: created)!, media: photo)
        }
        if let message = mesage {
            self.messages.append(message)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.scrollToBottom(animated: true)
            }
        }
        
        //        self.tblViewChatList.reloadData()
        //        if self.arrChatMessage.count > 0{
        //                           let indexPath = NSIndexPath(row: self.arrChatMessage.count-1, section: 0)
        //                       UIView.transition(with: self.tblViewChatList, duration: 0.5, options: .beginFromCurrentState, animations: {
        //                       self.tblViewChatList.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        //                                          })
        
        //        }
    }
}

//MARK:- Send Video Message
extension ChatViewController{
    func sendVideoMsg(message:String){
        let dictMessage = ["sender_id":self.sender_id,"receiver_id":self.receiver_Id,"message":message,"type":"Video","file_type":"mp4"]
        SocketIOManager.socket.emit("send_message", dictMessage)
        self.arrChatMessage.append(dictMessage)
        //        self.tblViewChatList.reloadData()
        //        if self.arrChatMessage.count > 0{
        //            let indexPath = NSIndexPath(row: self.arrChatMessage.count-1, section: 0)
        //        UIView.transition(with: self.tblViewChatList, duration: 0.5, options: .beginFromCurrentState, animations: {
        //        self.tblViewChatList.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        //                           })
        //        }
    }
}



//MARK:- TableView Delegate Datasource
//extension ChatViewController : UITableViewDelegate,UITableViewDataSource, WKUIDelegate{
//    //Chat Count
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrChatMessage.count
//    }
//
//    //Cell For Row
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let dictChat = self.arrChatMessage[indexPath.row]
//        print(dictChat as AnyObject)
//        let strDate = dictChat["created"] as! String
//        let strEditedDate = strDate.replacingOccurrences(of: ".000Z", with: "")
//        let strNewDate = strEditedDate.replacingOccurrences(of: "T", with:" " )
//
//        let strTimeAgo = dateDiff(strNewDate, DateFormat: "yyyy-MM-dd HH:mm:ss")
//        let strSenderID = dictChat["sender_id"] as! String
//        let msgType  =  dictChat["type"] as! String
//        //Checking cell For Sender or reciever
//        if strSenderID == self.sender_id {
//            if msgType == "Image"{
//                let cell = self.tblViewChatList.dequeueReusableCell(withIdentifier: "RecieverImageChatCellClass") as! RecieverImageChatCellClass
//                let image = dictChat["message"] as? String ?? ""
//                let urlImage = URL(string:chat_img_BASE_URL + image)
//                cell.imgViewReciverChatImage.sd_setImage(with: urlImage, placeholderImage:#imageLiteral(resourceName: "phl_employee_square"))
//                cell.lblrecieverTime.text = strTimeAgo
//                return cell
//            }
//            else if  msgType == "Video"{
//            }
//            else if  msgType == "Document"{
//                let cell = self.tblViewChatList.dequeueReusableCell(withIdentifier: "RecieverChatDocumentCellClass") as! RecieverChatDocumentCellClass
//                cell.lblRecieverDocName.text = dictChat["original_file_name"] as? String ?? ""
//                cell.lblRecieverTime.text = strTimeAgo
//                return cell
//            }
//            else if  msgType == "Text"{
//                let cell = self.tblViewChatList.dequeueReusableCell(withIdentifier: "RecieverChatCellClass") as! RecieverChatCellClass
//                cell.lblRecieverTime.text = strTimeAgo
//                cell.lblRecieverTxt.text = dictChat["message"] as? String ?? "..."
//                return cell
//            }
//        }
//        else{
//            if msgType == "Image"{
//                let cell = self.tblViewChatList.dequeueReusableCell(withIdentifier: "SenderImageChatCellClass") as! SenderImageChatCellClass
//                let image = dictChat["message"] as? String ?? ""
//                let urlImage = URL(string:chat_img_BASE_URL + image)
//                cell.imgViewSenderChatImage.sd_setImage(with: urlImage , placeholderImage:#imageLiteral(resourceName: "phl_employee_square"))
//                cell.lblSenderTime.text = strTimeAgo
//                return cell
//
//            }
//
//            else if  msgType == "Video"{
//
//
//            }
//
//            else if  msgType == "Document"{
//                let cell = self.tblViewChatList.dequeueReusableCell(withIdentifier: "SenderChatDocumentCellClass") as! SenderChatDocumentCellClass
//                cell.lblSenderDocName.text = dictChat["original_file_name"] as? String ?? ""
//                cell.lblSenderTime.text = strTimeAgo
//                return cell
//
//            }
//
//            else if  msgType == "Text"{
//                let cell = self.tblViewChatList.dequeueReusableCell(withIdentifier: "SenderChatCellClass") as! SenderChatCellClass
//                cell.lblSenderTime.text = strTimeAgo
//                cell.lblSenderTxt.text = dictChat["message"] as? String ?? "..."
//
//                return cell
//
//            }
//
//        }
//        return UITableViewCell()
//    }
//
//
//
//
//
//    //MARK:- Show Image Documnets On Full Screen
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let dictChat = self.arrChatMessage[indexPath.row]
//        print(dictChat as AnyObject)
//        let msgType  =  dictChat["type"] as! String
//        if msgType == "Image"{
//            let image = dictChat["message"] as? String ?? ""
//            self.imgViewFullScreenImage.sd_setImage(with: URL(string:chat_img_BASE_URL + image), placeholderImage:#imageLiteral(resourceName: "phl_employee_square"))
//
//            //   self.navigationController?.isNavigationBarHidden = true
//            self.hideShowFullScreenImage(view:self.viewContentFullScreenImage,isHidden:false)
//
//        }else if msgType == "Document"{
//            //    self.navigationController?.isNavigationBarHidden = true
//            let webView = WKWebView(frame: self.view.frame)
//            //webView. = true
//            self.hideShowFullScreenImage(view:self.viewContentDocumentFullScreen,isHidden:false)
//
//            self.viewDocumentWebView.addSubview(webView)
//            let doc_url = dictChat["message"] as? String ?? ""
//            let urlS  = chat_img_BASE_URL  + doc_url
//            let url = URL(string: urlS)
//            self.strDocUrl = urlS
//            let request = URLRequest(url: url!)
//            webView.load(request)
//        }
//    }
//}



//MARK:- Media Picker
extension ChatViewController{
    func showSimpleActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: "Munka", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { (_) in
            print("User click Approve button")
            self.openCamera()
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
    
    //Open Documnets
    func openDocumnets() {
        //let types : [String] = ["public.image", "com.microsoft.word.doc", kUTTypePDF] as! [String]
        let picker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc"], in: .open)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        self.present(picker, animated: true, completion: nil)
    }
    
    //Open Camera
    func openCamera(){
        ImagePickerManager().pickImage(self){ image in
            self.callUploadImageAPI(image:image, file_format: "png", type: "Image")//Calling Upload Image to Server
        }
    }
}

//MARK:- API Calling



//MARK:- Call Chat History API
extension ChatViewController{
    func callChatHistoryAPIToGetAllChatBetweenUsers(){
        
        //   ShowHud()
        ShowHud(view: self.view)
        print("#DN: UserId: \(MyDefaults().UserId ?? "")")
        print("#DN: sender_id: \(self.sender_id)")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken!,
                                        "room_id":self.room_id,
                                        "sender_id":self.sender_id,
                                        "receiver_id":self.receiver_Id,
                                        "job_id":self.job_Id,
                                        "page":"1",
                                        "limit":"20"]
        
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNGetUserChatHistoryListAPI, parameter: parameter) { (response) in
            debugPrint(response)
            
            //   HideHud()
            HideHud(view: self.view)
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    //  let response = response["details"] as? [[String:Any]] ?? [String:AnyObject]
                    // if  response["details"].count
                    
                    if let post = response["details"] as? [String: AnyObject] {
                        //self.thumbnail_images.append(ThumbImages(dict: postImage))
                        print(post)
                    }else{
                        let response = response["details"] as! [[String:Any]]
                        self.arrChatMessage = response.reversed()
                    }
                    self.messages.removeAll()
                    
                    //print(response)
                    // let responseMessage = response["msg"] as! String
                    print(response)
                    
                    // Replace this with your actual data source
                    for messageDict in self.arrChatMessage {
                        let senderId = messageDict["sender_id"] as? String ?? ""
                        let displayName = messageDict["receiver_id"] as? String ?? ""
                        let text = messageDict["message"] as? String ?? ""
                        let date = messageDict["created"] as? String ?? ""
                        let messageType = messageDict["type"] as? String ?? ""
                        let strEditedDate = date.replacingOccurrences(of: ".000Z", with: "")
                        let strNewDate = strEditedDate.replacingOccurrences(of: "T", with:" " )
                        
                        var message: CustomJSQMessage?
                        switch messageType {
                        case "Text":
                            message = CustomJSQMessage(senderId: senderId, senderDisplayName: displayName, date: self.dateFromString(dateString: strNewDate), text: text)
                        case "Image":
                            let imagename = messageDict["message"] as? String ?? ""
                            let photo = JSQPhotoMediaItem()
                            if let url = NSURL(string:chat_img_BASE_URL + imagename){
                                guard let data = NSData(contentsOf: url as URL) else{ return }
                                let image = UIImage(data: data as Data)
                                photo.image = image
                                photo.appliesMediaViewMaskAsOutgoing = true
                                message = CustomJSQMessage(senderId: senderId, senderDisplayName: displayName, date: self.dateFromString(dateString: strNewDate)!, media: photo)
                            }
                        case "Document":
                            var documentmessage = messageDict["message"] as? String ?? ""
                            if let documentUrl = messageDict["original_file_name"] as? String {
                                let documentImage = UIImage(named: "doc_file") // Your document icon image
                                let documentItem = CustomDocumentMediaItem()
                                documentItem.documentImage = documentImage
                                documentItem.fileName = documentUrl // File name here
                                documentItem.senderId = senderId
                                let urlDocument = URL(string:chat_img_BASE_URL + documentmessage)
                                documentItem.documentURL = urlDocument
                                documentItem.delegate = self
                                message = CustomJSQMessage(senderId: senderId, senderDisplayName: displayName, date: self.dateFromString(dateString: strNewDate)!, media: documentItem)
                            }
                        default:
                            break
                        }
                        
                        if let message = message {
                            self.messages.append(message)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.scrollToBottom(animated: true) // Optional: Scroll to the bottom after reloading
                    }
                    
                }else if  status == "0"{
                    
                }
                else
                {
                    self.tblViewChatList.isHidden = true
                    self.showErrorPopup(message: message, title: alert)
                }
            }
            else{
                self.showErrorPopup(message: serverNotFound, title: alert)
            }}
        
    }
    func dateFromString(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust the date format according to your API response
        return dateFormatter.date(from: dateString)
    }
    
    // Scroll to the bottom of the message collection view
    override func scrollToBottom(animated: Bool) {
        let lastSection = collectionView.numberOfSections - 1
        guard lastSection >= 0 else { return }
        
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else { return }
        
        let indexPath = IndexPath(item: lastItem, section: lastSection)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }
}



//MARK:- Call Upload Documents API
extension ChatViewController{
    func callUploadDocumentAPI(uploadData:[[String:Any]],file_type:String) {
        let parameter: [String: Any] = ["sender_id":self.sender_id,"receiver_id":self.receiver_Id,"job_id":self.job_Id,"file_format":file_type,"type":"Document"]
        print(parameter)
        //<<<<<<< Updated upstream
        //        //ShowHud()
        //        HTTPService.callForUploadDoc(url: MNChatFileUploadAPI, imageToUpload: uploadData, parameters: parameter) { (response) in
        //          //  HideHud()
        //=======
        //  ShowHud()
        ShowHud(view: self.view)
        HTTPService.callForUploadDoc(url: MNChatFileUploadAPI, imageToUpload: uploadData, parameters: parameter) { (response) in
            // HideHud()
            HideHud(view: self.view)
            //>>>>>>> Stashed changes
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    print(response)
                    let dictResponse = response["details"] as! [String:Any]
                    let strFilename = dictResponse["original_file_name"] as! String
                    self.sendDocumentsMsg(message: dictResponse["message"] as! String, file_type: file_type, original_file_name: strFilename, created: getCurrentShortDate())
                    //                self.tblViewChatList.reloadData()
                } else if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}
            else
            {
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
}




//MARK:- Call Upload Documents API
extension ChatViewController{
    func callUploadImageAPI(image:UIImage,file_format:String,type:String) {
        let parameter: [String: Any] = ["file_format":file_format,"type":type,"sender_id":self.sender_id,"receiver_id":self.receiver_Id,"job_id":self.job_Id]
        print(parameter)
        //<<<<<<< Updated upstream
        //      //  ShowHud()
        //        HTTPService.callForUploadMultipleImage(url: MNChatFileUploadAPI, imageParameter:"message",imageToUpload: image, parameters: parameter) { (response) in
        //        //    HideHud()
        //=======
        //        ShowHud()
        
        ShowHud(view: self.view)
        HTTPService.callForUploadMultipleImage(url: MNChatFileUploadAPI, imageParameter:"message",imageToUpload: image, parameters: parameter) { (response) in
            //   HideHud()
            HideHud(view: self.view)
            //>>>>>>> Stashed changes
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    print(response)
                    let dictResponse = response["details"] as! [String:Any]
                    self.sendImageMsg(message:dictResponse["message"] as! String, created: getCurrentShortDate())
                    //                self.tblViewChatList.reloadData()
                }else if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}
            else
            {
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
}

//MARK:- Document Picker Delegate
extension ChatViewController : UIDocumentPickerDelegate {
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
            let mediaImage = UIImageView()
            var file_format = ""
            // Create a FileManager instance
            
            do {
                try FileManager.default.copyItem(atPath: url.path, toPath: filePath.path)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
            
            if filePath.absoluteString.contains(".jpg") || filePath.absoluteString.contains(".jpeg") || filePath.absoluteString.contains(".png") {
                file_format = "png"
                //callFileUploadAPIForDocumentsa(document_url:filePath.absoluteString,file_format:"png")
            } else if filePath.absoluteString.contains(".doc") || filePath.absoluteString.contains(".docx") || filePath.absoluteString.contains(".txt"){
                
                file_format = "doc"
                //callFileUploadAPIForDocumentsa(document_url:filePath.absoluteString,file_format:"doc")
            }
            else if filePath.absoluteString.contains(".pdf") {
                //callFileUploadAPIForDocumentsa(document_url:filePath.absoluteString,file_format:"pdf")
                file_format = "pdf"
            }
            else if filePath.absoluteString.contains(".xls") || filePath.absoluteString.contains(".xlsx"){
                
                file_format = "xls"
                //callFileUploadAPIForDocumentsa(document_url:filePath.absoluteString,file_format:"xls")
            }
            let dict  = ["message":"message","type":"Document","uploadfile":file_format,"url":filePath.absoluteURL] as [String : Any]
            var arr = [[String : Any]]()
            arr.append(dict)
            self.callUploadDocumentAPI(uploadData: arr, file_type: file_format)
            
        }
    }
    //Create Folder
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
    
    //Get Document Directory path
    class func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

func getCurrentShortDate() -> String {
    let todaysDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let DateInFormat = dateFormatter.string(from: todaysDate)
    return DateInFormat
}

//
//  ChatListVCExtension.swift
//  Munka
//
//  Created by Puneet Sharma on 12/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation
import UIKit

//MARK:- TableView Delegate DataSource

extension MNIndividualInboxVC:UITableViewDelegate,UITableViewDataSource{
    
    //Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChatList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //Cell for rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewChatList.dequeueReusableCell(withIdentifier:"ChatListCellClass") as! ChatListCellClass
        let dictUser = self.arrChatList[indexPath.row]
        print(dictUser as AnyObject)
        cell.lblUserName.text = dictUser["user_name"] as? String ?? ""
        cell.lblJobTitle.text = dictUser["job_title"] as? String ?? ""
        let unreadCount = dictUser["unread"] as? String ?? ""
        let countTag = Int(unreadCount)
        print(unreadCount)
       // cell.lblUnreadCount.text = unreadCount
       // cell.viewContentUnraedCount.isHidden = Int(unreadCount)! > 0 ? false:true
        if countTag == 0 {
            cell.viewContentUnraedCount.isHidden = true
        }else{
            cell.viewContentUnraedCount.isHidden = false
            cell.lblUnreadCount.text = unreadCount
        }
        
        let strDate = dictUser["created"] as? String ?? "2019-12-13 06:50:42"
        let strEditedDate = strDate.replacingOccurrences(of: ".000Z", with: "")
        let strNewDate = strEditedDate.replacingOccurrences(of: "T", with:" " )
       
        var strTimeAgo = ""
        
        if let strDateCreat = dictUser["created"] as? String{
            if strDateCreat != ""{
             let strDate = dictUser["v"] as? String ?? "2019-12-13 06:50:42"
                   let strEditedDate = strDate.replacingOccurrences(of: ".000Z", with: "")
                   let strNewDate = strEditedDate.replacingOccurrences(of: "T", with:" " )
                    strTimeAgo = self.dateDiff(strNewDate, DateFormat: "yyyy-MM-dd HH:mm:ss")
                 
            }
        }
        cell.lblTimeAgo.text = dateDiff(strNewDate, DateFormat: "yyyy-MM-dd HH:mm:ss")
        let strImageUrl = dictUser["profile_pic"] as? String ?? ""
        cell.imgViewUserImage.sd_setImage(with: URL(string:img_BASE_URL + strImageUrl), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
       // print("I want to select index \(indexPath.row)")
        return cell
    }
    
    //Did select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictUser = self.arrChatList[indexPath.row]
        print(dictUser)
        let vc = storyBoard.Individual.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        let strImageUrl = dictUser["profile_pic"] as? String ?? ""
        vc.hidesBottomBarWhenPushed = true
        print("#DN: sender_id: \(dictUser["sender_id"] as! String)")
        vc.sender_id = dictUser["sender_id"] as! String
        vc.receiver_Id = dictUser["receiver_id"] as! String
        vc.job_Id = dictUser["job_id"] as! String
        if let aud = dictUser["room_id"] as? Int {
        vc.room_id = String(aud)
//            vc.strTitle =
//            vc.strImgeUrl = strImageUrl
        
        
        
        
        
        }

        vc.strTitle = dictUser["job_title"] as? String ?? ""
        vc.strImgeUrl =  img_BASE_URL + strImageUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Swipe cell Action
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //Archive User from Chat List
        let archive = UITableViewRowAction(style: .normal, title: "Archive") { (action, indexPath) in
            // Archive User at indexPath
            let room_id =  self.arrChatList[indexPath.row]["room_id"]
//            if self.arrChatList[indexPath.row]["room_id"] == nil {
//                print("Nothing to see here")
//            }else{
//               // self.callArchiveAPIToArchiveUserFromChatList(room_id:room_id as! String ,indexPath:indexPath,index:indexPath.row)
//                           print("I want to Archive: \(self.arrChatList[indexPath.row])")
//            }
    
           self.callArchiveAPIToArchiveUserFromChatList(room_id:room_id as! String ,indexPath:indexPath,index:indexPath.row)
           print("I want to Archive: \(self.arrChatList[indexPath.row])")
        }
        archive.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        //Delete User from Chat List
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete User at indexPath
            self.alertForDelete(index: indexPath.row, indexPath: indexPath)
            
        }
        return [archive,delete] //Index 0 > Delete, Index1 Archive
        //Swipe option shows from right to left. So first item will come in last
    }
}



//MARK:- Call Chat List (User List) API
extension MNIndividualInboxVC{
    
    func callChatListAPIToGetAllUserList(){
//<<<<<<< Updated upstream
      //  ShowHud()

       // ShowHud()
        ShowHud(view: self.view)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "", "action":"Normal","mobile_auth_token":MyDefaults().UDeviceToken ?? "",]
        if isConnectedToInternet(){
            debugPrint(parameter)
            HTTPService.callForPostApi(url:MNGetUserChatListAPI , parameter: parameter) { (response) in
                debugPrint(response)

              //  HideHud()
                HideHud(view: self.view)
//>>>>>>> Stashed changes
                if response.count != nil {
                    let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    let response = response["details"] as! [[String:Any]]
                    print(response)
                  //  self.arrChatList = response
                    
                    
                    for dict in response {
                        var dictionary =  [String:Any]()
                                   
                        if dict["sender_id"] as? String == MyDefaults().UserId {
                            dictionary ["other_user_id"] = dict["sender_id"] as? String
                        }else{
                            dictionary ["other_user_id"] = dict["receiver_id"] as? String                        }
                    
                    dictionary ["chat_status"] = dict["chat_status"] as? String
                    dictionary ["created"] = dict["created"] as? String
                    dictionary ["job_id"] = dict["job_id"] as? String
                    dictionary ["job_title"] = dict["job_title"] as? String
                    dictionary ["message"] = dict["message"] as? String
                    dictionary ["profile_pic"] = dict["profile_pic"] as? String
                    dictionary ["receiver_id"] = dict["receiver_id"] as? String
                    //dictionary ["unread"] = dict["unread"] as? String
                    if let aud = dict["room_id"] as? Int {
                        dictionary ["room_id"] = String(aud)
                    }
                        
                        if let unread = dict["unread"] as? Int {
                           print(unread)
                        dictionary ["unread"] =  String(unread)
                           }
                        
                    dictionary ["sender_id"] = dict["sender_id"] as? String
                   
                    dictionary ["user_name"] = dict["user_name"] as? String
                   // dictionary ["other_user_id"] = dict["sender_id"] as? String
                        print(dictionary)
                        let jobid = dict["job_id"] as? String
//                        if jobid != "undefined"{
                            self.arrChatList.append(dictionary)
//                        }
                    }
                    
                    print(self.arrChatList)
                    
                    if self.arrChatList.count > 0
                    {
                        self.tblViewChatList.isHidden = false
                        self.tblViewChatList.reloadData()
                    }else{
                        self.viewNoInternet.isHidden = true
                        self.viewNoDataFound.isHidden = false
                        self.tblViewChatList.isHidden = true
                    }
                } else  if status == "4"
                               {
                                self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    self.viewNoInternet.isHidden = true
                    self.viewNoDataFound.isHidden = false
                    self.tblViewChatList.isHidden = true
                    self.showErrorPopup(message: message, title: alert)
                }
                } else{
                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
        }
            //else{
//            self.viewNoInternet.isHidden = false
//            self.viewNoDataFound.isHidden = true
//            self.tblViewChatList.isHidden = true
//        }
    }
}
}
//MARK:- Archive User List API
extension MNIndividualInboxVC{
    
    func callArchiveAPIToArchiveUserFromChatList(room_id:String,indexPath:IndexPath,index:Int){
       // ShowHud(view: self.view)
        let parameter: [String: Any] = ["sender_id":MyDefaults().UserId ?? "", "room_id":room_id,"action":"Archive","mobile_auth_token":MyDefaults().UserId ?? ""]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNArchiveUserChatAPI , parameter: parameter) { (response) in
            debugPrint(response)
         //   HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                self.tblViewChatList.isHidden = false
                self.arrChatList.remove(at: index)
                self.tblViewChatList.deleteRows(at: [indexPath], with: .right)
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    if self.arrChatList.count > 0
                    {
                        self.tblViewChatList.isHidden = false
                        self.tblViewChatList.reloadData()
                    }else{
                        self.viewNoInternet.isHidden = true
                        self.viewNoDataFound.isHidden = false
                        self.tblViewChatList.isHidden = true
                    }
                }
            } else  if status == "4"
                       {
                        self.autoLogout(title: ALERTMESSAGE, message: message)
                        
            }
            else
            {
                self.viewNoInternet.isHidden = false
                self.viewNoDataFound.isHidden = true
                self.tblViewChatList.isHidden = true
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}else
            {
                
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
}

//MARK:- Delete User from List API
extension MNIndividualInboxVC{
    
    func callDeleteAPIToDeleteUserFromChatList(room_id:Int,indexpath:IndexPath,index:Int){
//<<<<<<< Updated upstream
     //   ShowHud()
//=======
      ShowHud(view: self.view)
//>>>>>>> Stashed changes
        let parameter: [String: Any] = ["sender_id":MyDefaults().UserId ?? "", "room_id":room_id]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNDeleteUserChatFromListAPI , parameter: parameter) { (response) in
            debugPrint(response)
//<<<<<<< Updated upstream
         //   HideHud()
//=======
//            HideHud()
//>>>>>>> Stashed changes
           HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                self.arrChatList.remove(at: index)
                self.tblViewChatList.deleteRows(at: [indexpath], with: .fade)
                self.showAlert(title: alert, message: message)
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    if self.arrChatList.count > 0
                    {
                        self.tblViewChatList.isHidden = false
                        self.tblViewChatList.reloadData()
                    }else{
                        self.viewNoInternet.isHidden = true
                        self.viewNoDataFound.isHidden = false
                        self.tblViewChatList.isHidden = true
                    }
                }
            } else if status == "4"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)
            }
            else
            {
                self.viewNoInternet.isHidden = false
                self.viewNoDataFound.isHidden = true
                self.tblViewChatList.isHidden = true
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }}else
            {
                
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
}


//MARK:- Alert Action For delete
extension MNIndividualInboxVC{
    //Delete Chat From User list
    func alertForDelete(index:Int , indexPath:IndexPath){
        let alertController = UIAlertController(title: ALERTMESSAGE, message: "are you sure want to delete this chat?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            let room_id =  self.arrChatList[index]["room_id"] as! String
            self.callDeleteAPIToDeleteUserFromChatList(room_id:Int(room_id) ?? 0 ,indexpath:indexPath,index:index)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}


//********************************************************//
//MARK:- geting Time Ago from created Time
func dateDiff(_ dateStr:String, DateFormat dateFormate: String) -> String {
    let f:DateFormatter = DateFormatter()
    f.timeZone = NSTimeZone.local
    f.dateFormat = dateFormate
    
    let now = f.string(from: NSDate() as Date)
    let startDate = f.date(from: dateStr)
    let endDate = f.date(from: now)
    
    let dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: startDate!, to: endDate!)
    
    let weeks   = dateComponents.weekOfMonth ?? 0
    let days    = dateComponents.day ?? 0
    let hours   = dateComponents.hour ?? 0
    let min     = dateComponents.minute ?? 0
    let sec     = dateComponents.second ?? 0
    
    var timeAgo = ""
    
    if (sec > 0){
        if (sec > 1) {
            timeAgo = "\(sec) Sec Ago"
        } else {
            timeAgo = "\(sec) Sec Ago"
        }
    }
    
    if (min > 0){
        if (min > 1) {
            timeAgo = "\(min) Mins Ago"
        } else {
            timeAgo = "\(min) Min Ago"
        }
    }
    
    if(hours > 0){
        if (hours > 1) {
            timeAgo = "\(hours) Hours Ago"
        } else {
            timeAgo = "\(hours) Hour Ago"
        }
    }
    
    if (days > 0) {
        if (days > 1) {
            timeAgo = "\(days) Days Ago"
        } else {
            timeAgo = "\(days) Day Ago"
        }
    }
    
    if(weeks > 0){
        timeAgo = stringFromNSDate(startDate!, dateFormate: "MMM dd, YYYY")
    }
    
    //print("timeAgo is===> \(timeAgo)")
    return timeAgo;
}

//STring From date
func stringFromNSDate(_ date: Date, dateFormate: String) -> String
{
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.full
    dateFormatter.dateFormat = dateFormate
    let formattedDate: String = dateFormatter.string(from: date)
    return formattedDate
    
}


//MARK:- get String from image
extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}

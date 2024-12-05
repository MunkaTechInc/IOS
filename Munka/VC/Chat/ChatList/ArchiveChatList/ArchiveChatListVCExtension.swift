//
//  ArchiveChatListVCExtension.swift
//  Munka
//
//  Created by Puneet Sharma on 13/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation
import UIKit

//MARK:- TableView Delegate DataSource

extension ArchiveChatListVC:UITableViewDelegate,UITableViewDataSource{
    
    //Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrArchivedList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //Cell for rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewArchivedList.dequeueReusableCell(withIdentifier:"ChatListCellClass") as! ChatListCellClass // Using Sam cell class for archive chat lst because all properties are same as chat list cell
        let dictUser = self.arrArchivedList[indexPath.row]
        print(dictUser)
        cell.lblUserName.text = dictUser["user_name"] as? String ?? ""
        cell.lblJobTitle.text = dictUser["job_title"] as? String ?? ""
        let strImageUrl = dictUser["profile_pic"] as? String ?? ""
        let strDate = dictUser["created"] as? String ?? "2019-12-13 06:50:42"
        let strEditedDate = strDate.replacingOccurrences(of: ".000Z", with: "")
        let strNewDate = strEditedDate.replacingOccurrences(of: "T", with:" " )
        
        cell.lblTimeAgo.text = dateDiff(strNewDate, DateFormat: "yyyy-MM-dd HH:mm:ss")
        cell.imgViewUserImage.sd_setImage(with: URL(string:img_BASE_URL + strImageUrl), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
        print("I want to select index \(indexPath.row)")
        return cell
    }
    
    //Did select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictUser = self.arrArchivedList[indexPath.row]
        print(dictUser)
        let vc = storyBoard.Individual.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        let strImageUrl = dictUser["profile_pic"] as? String ?? ""
        vc.sender_id = dictUser["other_user_id"] as! String
        vc.receiver_Id = dictUser["receiver_id"] as! String
        vc.job_Id = dictUser["job_id"] as! String
        vc.strTitle = dictUser["user_name"] as? String ?? ""
        vc.strImgeUrl =  img_BASE_URL + strImageUrl
        
        
        
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Swipe cell Action
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //Archive User from Chat List
               let unArchive = UITableViewRowAction(style: .normal, title: "Unarchive") { (action, indexPath) in
                   // Archive User at indexPath
                  let room_id =  self.arrArchivedList[indexPath.row]["room_id"] as! Int
                   self.callUnArchiveAPIToArchiveUserFromChatList(room_id:room_id ,indexPath:indexPath,index:indexPath.row)
                   print("I want to Unarchive: \(self.arrArchivedList[indexPath.row])")
               }
               unArchive.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        //Delete User from Chat List
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete User at indexPath
            self.alertForDelete(index: indexPath.row, indexPath: indexPath)
        }
        return [unArchive,delete] //Index 0 > Delete, Index1 Archive
        //Swipe option shows from right to left. So first item will come in last
    }
}



//MARK:- Call UnArchive List API
extension ArchiveChatListVC{
    
    func callArchiveAPIToGetAllArchiveUserList(){
       // ShowHud(view: self.view)

//        ShowHud()
        ShowHud(view: self.view)
        
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "", "action":"Archive"]
        if isConnectedToInternet(){
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNGetUserChatListAPI , parameter: parameter) { (response) in
            debugPrint(response)
           // HideHud(view: self.view)

            HideHud(view: self.view)

            if response.count != nil {
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                let response = response["details"] as! [[String:Any]]
                print(response)
                self.arrArchivedList = response
                if self.arrArchivedList.count > 0
                {
                self.tblViewArchivedList.isHidden = false
                self.tblViewArchivedList.reloadData()
                }else{
                self.viewNoInternet.isHidden = true
                self.viewNoDataFound.isHidden = false
                self.tblViewArchivedList.isHidden = true
                }
            } else if status == "4"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)
            }
            else{
                self.viewNoInternet.isHidden = true
                self.viewNoDataFound.isHidden = false
                self.tblViewArchivedList.isHidden = true
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }
        }else{
            self.viewNoInternet.isHidden = false
            self.viewNoDataFound.isHidden = true
            self.tblViewArchivedList.isHidden = true
            self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
        }
    }
        }}
}


//MARK:-UnArchive User API
extension ArchiveChatListVC{
    
    func callUnArchiveAPIToArchiveUserFromChatList(room_id:Int,indexPath:IndexPath,index:Int){
      //  ShowHud(view: self.view)
        let parameter: [String: Any] = ["sender_id":MyDefaults().UserId ?? "", "room_id":room_id,"action":"Unarchive"]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNArchiveUserChatAPI , parameter: parameter) { (response) in
            debugPrint(response)
          //  HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                self.tblViewArchivedList.isHidden = false
                self.arrArchivedList.remove(at: index)
                self.tblViewArchivedList.deleteRows(at: [indexPath], with: .fade)
                if self.arrArchivedList.count > 0
                {
                self.tblViewArchivedList.isHidden = false
                self.tblViewArchivedList.reloadData()
                }else{
                    self.viewNoInternet.isHidden = true
                    self.viewNoDataFound.isHidden = false
                    self.tblViewArchivedList.isHidden = true
                }
            } else  if status == "4"
                       {
                        self.autoLogout(title: ALERTMESSAGE, message: message)
            }
            else
            {
                self.viewNoInternet.isHidden = false
                self.viewNoDataFound.isHidden = true
                self.tblViewArchivedList.isHidden = true
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }}else
            {
              
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
}

//MARK:- Delete User from List API
extension ArchiveChatListVC{
    
    func callDeleteAPIToDeleteUserFromArchiveList(room_id:Int,indexpath:IndexPath,index:Int){

        //ShowHud()
ShowHud(view: self.view)
        let parameter: [String: Any] = ["sender_id":MyDefaults().UserId ?? "", "room_id":room_id]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNDeleteUserChatFromListAPI , parameter: parameter) { (response) in
            debugPrint(response)

           // HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
            self.arrArchivedList.remove(at: index)
            self.tblViewArchivedList.deleteRows(at: [indexpath], with: .fade)
            self.showAlert(title: alert, message: message)
                if self.arrArchivedList.count > 0
                {
                self.tblViewArchivedList.isHidden = false
                self.tblViewArchivedList.reloadData()
                }else{
                    self.viewNoInternet.isHidden = true
                    self.viewNoDataFound.isHidden = false
                    self.tblViewArchivedList.isHidden = true
                }
            } else if status == "4"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)
            }
            else
            {
                self.viewNoInternet.isHidden = false
                self.viewNoDataFound.isHidden = true
                self.tblViewArchivedList.isHidden = true
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }}else
            {
               
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
}


//MARK:- Alert Action For delete
extension ArchiveChatListVC{
    //Delete Chat From User list
    func alertForDelete(index:Int , indexPath:IndexPath){
            let alertController = UIAlertController(title: ALERTMESSAGE, message: "are you sure want to delete this chat?", preferredStyle: .alert)

               // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                   UIAlertAction in
                   NSLog("OK Pressed")
               let room_id =  self.arrArchivedList[index]["room_id"] as! Int
               self.callDeleteAPIToDeleteUserFromArchiveList(room_id:room_id ,indexpath:indexPath,index:index)
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


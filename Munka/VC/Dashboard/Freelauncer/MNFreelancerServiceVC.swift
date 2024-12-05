//
//  MNFreelancerServiceVC.swift
//  Munka
//
//  Created by Amit on 14/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNFreelancerServiceVC: UIViewController {
var serviceCategory = [ModelServiceCategory]()
    @IBOutlet weak var tblView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hidesBottomBarWhenPushed = true
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated) // No need for semicolon
         //  listdetails = [ModelListViewDetail]()
           if  isConnectedToInternet() {
                    //self.pageNumber = 1
                   // self.isTotalCountReached = false
                   self.callServiceAddCategotyAPI()
               } else {
                   self.showErrorPopup(message: internetConnetionError, title: alert)
           }
       }
    
    
    @IBAction func actionOnAddNewCategory(_ sender: UIButton) {
           //self.dismiss(animated: true, completion: nil)
        let details = storyBoard.freelauncer.instantiateViewController(withIdentifier: "FreelancerAddNewcatagoryVC") as! FreelancerAddNewcatagoryVC
//            details.JobId = self.jobList[indexPath.row].id
//            details.ContractId = self.jobList[indexPath.row].contractId
//            print(self.jobList[indexPath.row].contractId!)
        details.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(details, animated: true)
        }
    func callServiceAddCategotyAPI() {
          

           // ShowHud()
    ShowHud(view: self.view)
           print(MyDefaults().UserId ?? "")
            let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                          "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                          "other_user_id":OtheerUserId,
                                          "user_type":MyDefaults().swiftUserData["user_type"] as! String]
             debugPrint(parameter)
             HTTPService.callForPostApi(url:MNGetProfileAPI , parameter: parameter) { (response) in
                 debugPrint(response)

             // HideHud()
                HideHud(view: self.view)
               // self.isApiCalled = false
                if response.count != nil{
                let status = response["status"] as! String
                 let message = response["msg"] as! String
                 if status == "1"
                 {
                    let response = ModelGetuserservice.init(fromDictionary: response as! [String : Any])
                    self.serviceCategory = response.details.serviceCategory
                    self.tblView.delegate = self
                    self.tblView.dataSource = self
                    self.tblView.reloadData()
                    
                } else  if status == "4"
                 {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                 }
                    else  if status == "2"
                    {
                      // self.autoLogout(title: ALERTMESSAGE, message: message)
                 self.showErrorPopup(message: message, title: ALERTMESSAGE)
                 }
                    else  if status == "0"
                    {
                     //  self.autoLogout(title: ALERTMESSAGE, message: message)
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                    }
                }else{
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
            }
        }
}
// MARK: - extension
extension MNFreelancerServiceVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceCategory.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : FreelancerServiceVC_TableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "FreelancerServiceVC_TableViewCell", for: indexPath) as? FreelancerServiceVC_TableViewCell
       //self.serviceCategory
       
        cell.lblCountryName.text = self.serviceCategory[indexPath.row].categoryName
        cell.lblStatus.text = self.serviceCategory[indexPath.row].status
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(clickOnDelete(sender:)), for: .touchUpInside)
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(clickOnEdit(sender:)), for: .touchUpInside)
        
        cell.btnEdit.isHidden = true
        cell.btnDelete.isHidden = true
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let details = self.storyboard?.instantiateViewController(withIdentifier: "MNPostDetailVC") as! MNPostDetailVC
//         self.navigationController?.pushViewController(details, animated: true)
    }
    @objc func clickOnDelete(sender : UIButton){
       // self.serviceCategory = [ModelServiceCategory]()
        self.alertcancelJob(tag: sender.tag)
        }
    @objc func clickOnEdit(sender : UIButton){
   //self.serviceCategory = [ModelServiceCategory]()
   // self.alertcancelJob(tag: sender.tag)
         let details = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNFreelancerEditServiceVC") as! MNFreelancerEditServiceVC
        details.documentImage = self.serviceCategory[sender.tag].document
        details.category = self.serviceCategory[sender.tag].categoryName
        details.categoryId = self.serviceCategory[sender.tag].id
        details.serviceCategory = self.serviceCategory[sender.tag].categoryId
        
        details.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(details, animated: true)
    }
    func alertcancelJob(tag: Int){
        let alertController = UIAlertController(title: ALERTMESSAGE, message: "are you sure want to delete this category.", preferredStyle: .alert)

           // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
               UIAlertAction in
               NSLog("OK Pressed")
            self.callServicDeleteCategoryAPI(sender: tag)
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
    func callServicDeleteCategoryAPI(sender:Int) {
          

           // ShowHud()
    ShowHud(view: self.view)
           print(MyDefaults().UserId ?? "")
            let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "" ,
                                          "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                          "service_category_id":self.serviceCategory[sender].id ?? ""]
             debugPrint(parameter)
             HTTPService.callForPostApi(url:deleteservicecategoryAPI , parameter: parameter) { (response) in
                 debugPrint(response)
//                self.serviceCategory.removeAll()
//                self.serviceCategory = [ModelServiceCategory]()
             // HideHud()
                HideHud(view: self.view)
               // self.isApiCalled = false
                if response.count != nil{
                let status = response["status"] as! String
                 let message = response["msg"] as! String
                 if status == "1"
                 {
                    //self.serviceCategory.remove(at: sender)
                    
                    if "Service deleted successfully" == message {
                        self.serviceCategory.remove(at: sender)
                       // let index = IndexPath(row: sender, section: 0)
                       // self.tblView.reloadRows(at: [index], with: .automatic)
                        self.tblView.reloadData()
                    }else{
                        let response = ModelGetuserservice.init(fromDictionary: response as! [String : Any])
                        self.serviceCategory = response.details.serviceCategory
                        self.tblView.delegate = self
                        self.tblView.dataSource = self
                        self.tblView.reloadData()
                    }
                    
                    
                    
                } else  if status == "4"
                 {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                 }
                    else  if status == "2"
                    {
                      // self.autoLogout(title: ALERTMESSAGE, message: message)
                 self.showErrorPopup(message: message, title: ALERTMESSAGE)
                 }
                    else  if status == "0"
                    {
                     //  self.autoLogout(title: ALERTMESSAGE, message: message)
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                    }
                }else{
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
            }
        }
}

//
//  MNSaveJobsVC.swift
//  Munka
//
//  Created by Amit on 28/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNSaveJobsVC: UIViewController {
@IBOutlet weak var tblMyjobs:UITableView!
    var objIndividual = [ModelIndividualDetail]()
    @IBOutlet weak var viewNointernetConnaction:UIView!
       @IBOutlet weak var viewNoDataFound:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblMyjobs.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        if  isConnectedToInternet() {
            self.callServiceForSaveJobAPI()
            } else {
                self.tblMyjobs.isHidden = true
                self.viewNointernetConnaction.isHidden = false
                self.viewNoDataFound.isHidden = true
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    func callServiceForSaveJobAPI() {
      objIndividual = [ModelIndividualDetail]()

      //  ShowHud()
ShowHud(view: self.view)
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "list_type":"Save",
                                      "user_type":MyDefaults().swiftUserData["user_type"] as! String,
                                      "page":"1",
                                      "Keyword":""]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNPIndividualHomeAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelIndividualHome.init(fromDictionary: response as! [String : Any])
                    self.objIndividual = response.details
                   self.tblMyjobs.isHidden = false
                   self.tblMyjobs.reloadData()
            } else if status == "4"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)
             }
             else
             {
                 self.tblMyjobs.isHidden = true
                self.viewNointernetConnaction.isHidden = true
                self.viewNoDataFound.isHidden = false
                // self.tblMyjobs.reloadData()
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }}else
            {
               
               self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
            
         }
    }
    @IBAction func actionOnBack(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
        }
}
// MARK: - extension
extension MNSaveJobsVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objIndividual.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : SavejobsTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "SavejobsTableViewCell", for: indexPath) as? SavejobsTableViewCell
         
         cell?.lblName.text = self.objIndividual[indexPath.row].jobTitle
         let startDate = self.convertDateFormater(self.objIndividual[indexPath.row].jobStartDate)
         let startTime = self.convertTimeFormater(self.objIndividual[indexPath.row].jobStartTime)
         cell?.lblStartDate.text = startDate + "  " + startTime
         
        let EndDateDate = self.convertDateFormater(self.objIndividual[indexPath.row].jobEndDate)
        let endTime = self.convertTimeFormater(self.objIndividual[indexPath.row].jobEndTime)
           cell?.lblEndDate.text = EndDateDate + "  " + endTime
        // let status = self.objIndividual[indexPath.row].status
        if  self.objIndividual[indexPath.row].jobType == "Fixed" {
            cell?.lblDays.text = "Fixed - " + "$" + self.objIndividual[indexPath.row].budgetAmount
           // cell?.lblDays.text = self.objIndividual[indexPath.row].timeDuration + " " + "Days"
        }else{
            cell?.lblDays.text = "Hourly - " + "$" + self.objIndividual[indexPath.row].budgetAmount  + "/hr."
           // cell?.lblDays.text = self.objIndividual[indexPath.row].timeDuration + " " + "Days"
        }
        cell?.btnDelete.tag = indexPath.row
        cell?.btnDelete.addTarget(self, action: #selector(clickOnDelete(sender:)), for: .touchUpInside)
        return cell!
    }
    @objc func clickOnDelete(sender : UIButton){
        print(sender.tag)
        self.alertforDeleteCategory(tagValue: sender.tag)
    }
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let details = storyBoard.tabbar.instantiateViewController(withIdentifier: "SavedjobInfodetailVC") as! SavedjobInfodetailVC
       details.jobId = self.objIndividual[indexPath.row].id
       self.navigationController?.pushViewController(details, animated: true)

    }
    func alertforDeleteCategory(tagValue : Int) {
        let alertController = UIAlertController(title: ALERTMESSAGE, message: "Do you want to delete this job.", preferredStyle: .alert)
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
//           if self.objIndividual.count > 0{
//            objIndividual.remove(at: categoryId)
//            self.tblMyjobs.reloadData()
//        }
        self.callServiceForDeletJobAPI(deleteTag: categoryId)
    }
    func callServiceForDeletJobAPI(deleteTag:Int) {

       //  ShowHud()
ShowHud(view: self.view)
          
           let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                         "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                         "job_id":self.objIndividual[deleteTag].id ?? ""]
            debugPrint(parameter)
            HTTPService.callForPostApi(url:MNPJobDeleteAPI , parameter: parameter) { (response) in
                debugPrint(response)

            // HideHud()
HideHud(view: self.view)
                if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    self.objIndividual.remove(at: deleteTag)
                    
                    self.navigationController?.popViewController(animated: true)
                    self.showAlert(title: ALERTMESSAGE, message: message)
                } else if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}else
                {
                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
               
            }
       }
    
    func convertDateFormater(_ strdate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
    func convertTimeFormater(_ dateAsString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "hh:mm a"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
    }
}

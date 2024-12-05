//
//  MNMyJobsVC.swift
//  Munka
//
//  Created by Amit on 27/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNMyJobsVC: UIViewController,getJobType {
    
   @IBOutlet weak var tblMyjobs:UITableView!
   @IBOutlet weak var viewNoInternet:UIView!
   @IBOutlet weak var viewNoDataFound:UIView!
   @IBOutlet var btnFilterDropDown: UIButton!
    var pageNumber: Int = 1
    var isTotalCountReached : Bool = false
    var objIndividual = [ModelIndividualDetail]()
    
    var jobType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblMyjobs.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
        objIndividual = [ModelIndividualDetail]()
         self.tblMyjobs.isHidden = true
        if  isConnectedToInternet() {
                 self.pageNumber = 1
                 self.isTotalCountReached = false
            self.jobType = "All"
            self.callServiceForJobListAPI(listType: self.jobType)
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
    }
     @IBAction func actionViewAllJobs(_ sender: UIButton) {
        let popup : ViewAllJobsPopUps = storyBoard.PopUp.instantiateViewController(withIdentifier: "ViewAllJobsPopUps") as! ViewAllJobsPopUps
            popup.delagate = self
        self.presentOnRoot(with: popup)
    }
     @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
     }
    // MARK: - UIScrollView Delegate and DataSource
    
    var isApiCalled: Bool = false
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let endScrolling: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height + 1
        if endScrolling >= scrollView.contentSize.height && !self.isTotalCountReached
        {
            if !self.isApiCalled {
                self.isApiCalled = true
                self.callServiceForJobListAPI(listType: self.jobType)
            }
        }
    }
    @IBAction func actionOnSave(_ sender: UIButton) {
        let details = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNSaveJobsVC") as! MNSaveJobsVC
              self.navigationController?.pushViewController(details, animated: true)
    }
    func delegateJotType(strJob: String) {
        if strJob == "All" {
            jobType = strJob
            self.btnFilterDropDown.setTitle(strJob, for: .normal)
        }else if strJob == "Upcoming" {
            jobType = strJob
            self.btnFilterDropDown.setTitle(strJob, for: .normal)
        }else if strJob == "In-Progress" {
            jobType = "In_Progess"
            self.btnFilterDropDown.setTitle("In-Progress", for: .normal)
        }else if strJob == "Completed" {
            jobType = strJob
            self.btnFilterDropDown.setTitle(strJob, for: .normal)
        }else if strJob == "Canceled" {
            jobType = strJob
            self.btnFilterDropDown.setTitle(strJob, for: .normal)
        } else if strJob == "Rejected" {
            jobType = strJob
            self.btnFilterDropDown.setTitle(strJob, for: .normal)
        }
       
      
        
        
        
        
        
        
        
        self.pageNumber = 1
        self.objIndividual = [ModelIndividualDetail]()
        self.callServiceForJobListAPI(listType: jobType)
       
    }
    func callServiceForJobListAPI(listType:String) {
      // objIndividual = [ModelIndividualDetail]()

       // ShowHud()
ShowHud(view: self.view)
       
        
        print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "list_type":listType,
                                      "user_type":MyDefaults().swiftUserData["user_type"] as! String,
                                      "page":pageNumber,
                                      "Keyword":""]
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            debugPrint(parameter)
         HTTPService.callForPostApi(url:MNPIndividualHomeAPI , parameter: parameter) { (response) in
             debugPrint(response)
          self.isApiCalled = false

           // HideHud()
            HideHud(view: self.view)

            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelIndividualHome.init(fromDictionary: response as! [String : Any])
                if response.details.count == 0 {
                 self.isTotalCountReached = true
                }
                            self.objIndividual += response.details
                           // self.lblTotalAmount.text = "$ " + response.walletAmount
                            if self.objIndividual.count == 0
                                    {
                                        self.isTotalCountReached = true
                                        self.viewNoDataFound.isHidden = false
                                        self.tblMyjobs.isHidden = true
                                    }else{
                                        if self.objIndividual.count % 10 != 0
                                        {
                                            self.isTotalCountReached = true
                                        }
                                        self.pageNumber = self.pageNumber + 1
                                        self.viewNoDataFound.isHidden = true
                                        self.tblMyjobs.isHidden = false
                                        self.tblMyjobs.reloadData()
                                    }
    } else if status == "4"
    {
        self.autoLogout(title: ALERTMESSAGE, message: message)
             }

            else {
               if self.objIndividual.count == 0
               {
                   self.viewNoDataFound.isHidden = false
                   self.tblMyjobs.isHidden = true
               }
                self.isTotalCountReached = true
                self.tblMyjobs.reloadData()
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }
            }else{
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
    }
    }
}
// MARK: - extension
extension MNMyJobsVC: UITableViewDataSource,UITableViewDelegate,GetSelectJobType{
    func delegetSetJobType(jobType: String) {
        self.pageNumber = 1
        self.jobType = jobType
        self.btnFilterDropDown.setTitle(jobType, for: .normal)
       // self.isTotalCountReached = true
        // self.isApiCalled = true
        self.objIndividual = [ModelIndividualDetail]()
        self.callServiceForJobListAPI(listType: jobType)
    }
    
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if self.isTotalCountReached {
            return self.objIndividual.count
        } else {
            return self.objIndividual.count + 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.objIndividual.count
        {
            return 44
        }
        else{
            return 128
        }
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : MyjobsTableViewCell?
       
        if indexPath.row == self.objIndividual.count {
            let cell1 : UITableViewCell = self.tblMyjobs.dequeueReusableCell(withIdentifier: "LoadingCell")!
            let activityIndicator : UIActivityIndicatorView = (cell1.contentView.viewWithTag(100) as? UIActivityIndicatorView)!
            activityIndicator.startAnimating()
                      return cell1
        } else{
            cell = tableView.dequeueReusableCell(withIdentifier: "MyjobsTableViewCell", for: indexPath) as? MyjobsTableViewCell
             cell?.imgMyjobs.sd_setImage(with: URL(string:img_BASE_URL + self.objIndividual[indexPath.row].freelancerProfilePic), placeholderImage:#imageLiteral(resourceName: "phl_square_profile"))
             cell?.lblAssign.text = self.objIndividual[indexPath.row].jobWorkedBy
             cell?.lblName.text = self.objIndividual[indexPath.row].jobTitle
           
            if self.objIndividual[indexPath.row].jobStartDate.isEmpty || self.objIndividual[indexPath.row].jobStartTime.isEmpty {
                print("Nothing to see here")
            }else{
              //  let startDate = self.convertDateFormater(self.objIndividual[indexPath.row].jobStartDate)
               
                let startDate =  Global.convertDateFormat(self.objIndividual[indexPath.row].jobStartDate, sourceFormate: "yyyy-MM-dd", targetFormate: "MMM dd, yyyy")
                let startTime = self.convertTimeFormater(self.objIndividual[indexPath.row].jobStartTime)
                cell?.lblStartDate.text = startDate + "  " + startTime
            }
            if self.objIndividual[indexPath.row].jobEndDate.isEmpty ||  self.objIndividual[indexPath.row].jobEndTime.isEmpty {
                print("Nothing to see here")
            }else{
//            let EndDateDate =
//                self.convertDateFormater(self.objIndividual[indexPath.row].jobEndDate)
            let EndDateDate =  Global.convertDateFormat(self.objIndividual[indexPath.row].jobEndDate, sourceFormate: "yyyy-MM-dd", targetFormate: "MMM dd, yyyy")
             let endTime = self.convertTimeFormater(self.objIndividual[indexPath.row].jobEndTime)
                cell?.lblEndDate.text = EndDateDate + "  " + endTime
            }
             

             let status = self.objIndividual[indexPath.row].status
             cell?.lblStatus.text = "  \(String(describing: status!))   "
             if status == "New" {
                 cell?.lblStatus.backgroundColor = UIColor.hexStringToUIColor(hex: "#E5983E")
                 cell?.imgMyjobs.isHidden = true
             } else if status == "In Process" {
                 cell?.lblStatus.backgroundColor = UIColor.hexStringToUIColor(hex: "#13C1B3")
                cell?.imgMyjobs.isHidden = false
             } else if status == "Pending" {
                  cell?.lblStatus.backgroundColor = UIColor.hexStringToUIColor(hex: "#E5983E")
                cell?.imgMyjobs.isHidden = false
             } else if status == "Canceled" {
                  cell?.lblStatus.backgroundColor = UIColor.hexStringToUIColor(hex: "#C7481A")
                cell?.imgMyjobs.isHidden = false
             } else if status == "Completed" {
                  cell?.lblStatus.backgroundColor = UIColor.hexStringToUIColor(hex: "#18A25D")
                cell?.imgMyjobs.isHidden = false
             }
             if  self.objIndividual[indexPath.row].jobType == "Fixed" {
                 cell?.lblHour.text = "Fixed - " + "$" + self.objIndividual[indexPath.row].budgetAmount  
                 cell?.lblDays.text = self.objIndividual[indexPath.row].timeDuration + " " + "Days"
             }else{
                 cell?.lblHour.text = "Hourly - " + self.objIndividual[indexPath.row].budgetAmount  + "/h"
                 cell?.lblDays.text = self.objIndividual[indexPath.row].timeDuration + " " + "hr"
             }
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if self.objIndividual[indexPath.row].isApplied == "0" {
            let details = storyBoard.tabbar.instantiateViewController(withIdentifier: "EditJobVC") as! EditJobVC
             
            details.jobId = self.objIndividual[indexPath.row].id
            self.navigationController?.pushViewController(details, animated: true)
        }else{
            let details = self.storyboard?.instantiateViewController(withIdentifier: "MNPostDetailVC") as! MNPostDetailVC
            details.strJobId = self.objIndividual[indexPath.row].id
            details.delagate = self
            details.JobType = jobType
            self.navigationController?.pushViewController(details, animated: true)
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

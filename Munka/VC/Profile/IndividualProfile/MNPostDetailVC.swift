//
//  MNPostDetailVC.swift
//  Munka
//
//  Created by Amit on 29/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
protocol GetSelectJobType {
    func delegetSetJobType(jobType:String)
}

class MNPostDetailVC: UIViewController {
   
    @IBOutlet weak var vwBgJob: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMiles: UILabel!
    @IBOutlet weak var lblJobDescriptions: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblJobName: UILabel!
    @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var viewschedule: UIView!
    @IBOutlet weak var viewscheduleHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblview: UITableView!
    var delagate: GetSelectJobType!
    var JobType = ""
    var strJobId = ""
    var jobDetails : ModelJobDetail!
    var hourlyJobTime = [ModelHourlyJobTime]()
    var isHourlyAvailableDate : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if  isConnectedToInternet() {
                self.callServiceForJobDetailsAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    @IBAction func actionOnBack(_ sender: UIButton) {
     
        if self.delagate != nil {
            self.navigationController?.popViewController(animated: true)
            self.delagate.delegetSetJobType(jobType: JobType)
         
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func actionOnHourly(_ sender: UIButton) {
        if isHourlyAvailableDate == true {
             isHourlyAvailableDate = false
        }else{
             isHourlyAvailableDate = true
        }
        tblview.reloadData()
    }
    func callServiceForJobDetailsAPI() {
      

       // ShowHud()
ShowHud(view: self.view)
       print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "job_id":strJobId]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNPJobDetailsAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
            HideHud(view: self.view)

            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelJobDetails.init(fromDictionary: response as! [String : Any])
                    self.jobDetails = response.details
                if response.details.hourlyJobTime.count > 0 {
                    self.isHourlyAvailableDate = true
                    self.hourlyJobTime = response.details.hourlyJobTime
                    self.tblview.reloadData()
                }
                else{
                    self.viewscheduleHightConstraint.constant = 0
                    self.viewschedule.isHidden = true
                }
                self.setupUI()
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
    func setupUI()  {
        if self.jobDetails.jobType  == "Fixed"{
            lblHours.text = self.jobDetails.timeDuration + " Hours"
            let strJobType = "\(self.jobDetails.jobType!)"
            //lblDuration.text = "   "+strJobType+"   "
            lblDuration.text = strJobType
            lblPrice.text = "$" + self.jobDetails.budgetAmount + "/hr."
            
        }else{
            
        lblDuration.text = (self.jobDetails.jobType!)
        lblPrice.text = "$" + self.jobDetails.budgetAmount + "/hr."
        
        }
        lblDate.text = "Post on " + self.convertDateFormaterFoeOnlyDate(self.jobDetails.created)
        lblJobName.text = self.jobDetails.jobTitle
        lblJob.text =  self.jobDetails.serviceCategory // "   \(self.jobDetails.serviceCategory!)    "
        let stratDate =  self.convertDateFormater(self.jobDetails.jobStartDate) // lblStartDate.text
        let startTime =  self.convertTimeFormater(self.jobDetails.jobStartTime)
        lblStartDate.text = stratDate + " " + startTime
        
        let endDate =  self.convertDateFormater(self.jobDetails.jobEndDate) // lblStartDate.text
        let endTime =  self.convertTimeFormater(self.jobDetails.jobEndTime)
        lblEndDate.text = endDate + " " + endTime
        lblMiles.text = self.jobDetails.distance + "miles"
        lblAddress.text = self.jobDetails.jobLocation
        lblJobDescriptions.text = self.jobDetails.jobDescription
       
    }
    func convertDateFormater(_ strdate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
    func convertDateFormaterFoeOnlyDate(_ strdate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
extension MNPostDetailVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.objIndividual.count
       if self.isHourlyAvailableDate == true{
            return hourlyJobTime.count
       }else{
        return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : PostDetailTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell", for: indexPath) as? PostDetailTableViewCell
        let start = self.convertDateFormater(hourlyJobTime[indexPath.row].date) + " " + hourlyJobTime[indexPath.row].startTime + " "
       let end = self.convertDateFormater(hourlyJobTime[indexPath.row].date) + " " + hourlyJobTime[indexPath.row].endTime + " "
        let startDate = self.convertMMMDDYYYYTOYYYYMMDDWithTime(start)
        let endDate = self.convertMMMDDYYYYTOYYYYMMDDWithTime(end)
        let sDate = self.convertDateFormater24format(startDate)
        let eDate = self.convertDateFormater24format(endDate)
        cell?.lblDates.text = sDate[0] + " " + sDate[1] + " " + " to" + " " + eDate[1]
       return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let details = self.storyboard?.instantiateViewController(withIdentifier: "MNPostDetailVC") as! MNPostDetailVC
//        details.strJobId = self.objIndividual[indexPath.row].id
//        self.navigationController?.pushViewController(details, animated: true)
    }
    func GetAmOrPM(strTime:String) -> String {
       // let dateAsString = "6:35 PM"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
         let date = dateFormatter.date(from: strTime)
        let dateString = dateFormatter.string(from: date!)
        return dateString
    }
    
}

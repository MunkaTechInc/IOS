//
//  MNPostDetailFreelauncerVC.swift
//  Munka
//
//  Created by Amit on 02/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNPostDetailFreelauncerVC: UIViewController {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMiles: UILabel!
    @IBOutlet weak var lblJobDescriptions: UILabel!
    @IBOutlet var heightJobDescription: NSLayoutConstraint!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblJobName: UILabel!
    @IBOutlet weak var BarbtnFavorites: UIBarButtonItem!
     @IBOutlet weak var btnApplied: UIButton!
    @IBOutlet weak var tblView: UITableView!
     @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var viewLocationHight: NSLayoutConstraint!
    var arrayViewDetail = [String]()
    var hourlyJobTime = [ModelHourlyJobTime]()
//    var favoritesBarButtonOn: UIBarButtonItem!
//    var favoritesBarButtonOFF: UIBarButtonItem!

    var isHourlyAvailableDate : Bool = false
   // @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    var jobDetails : ModelJobDetail!
    var strJobId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if  isConnectedToInternet() {
                self.callServiceForJobFrelauncerDetailsAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        self.btnApplied.isHidden = true
        BarbtnFavorites?.image = UIImage(named: "ic_favourite")
        
        // Do any additional setup after loading the view.
//    favoritesBarButtonOn = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_like.png"), style: .plain, target: self, action: #selector(didTapFavoritesBarButtonOn))
//    favoritesBarButtonOFF = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_favourite.png"), style: .plain, target: self, action: #selector(didTapFavoritesBarButtonOFF))

   // self.navigationItem.rightBarButtonItems = [self.favoritesBarButtonOn]

    }
    
    @IBAction func actionOnBack(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    func callServiceForJobFrelauncerDetailsAPI() {

       // ShowHud()
        ShowHud(view: self.view)

//       print(MyDefaults().UserId!)
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
                    self.hourlyJobTime = response.details.hourlyJobTime
                        let string1 = "viewDetail"
                        self.arrayViewDetail.append(string1)
                        _ = "viewDetailData"
                        self.arrayViewDetail.append(string1)
                        self.tblView.reloadData()
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
            lblHours.text = self.jobDetails.timeDuration + " Days"
           // let strJobType = "\(self.jobDetails.jobType!)"
            //lblDuration.text = "   "+strJobType+"   "
            lblDuration.text = jobDetails.jobType
            lblPrice.text = "$" + self.jobDetails.budgetAmount
            
        }else{
            lblHours.text = self.jobDetails.timeDuration + " Hours"
            // let strJobType = "\(self.jobDetails.jobType!)"
             //lblDuration.text = "   "+strJobType+"   "
             lblDuration.text = jobDetails.jobType
             lblPrice.text = "$" + self.jobDetails.budgetAmount + "/hr."
        }
        lblDate.text = "Post on " + self.convertDateFormaterFoeOnlyDate(self.jobDetails.created)
        lblJobName.text = self.jobDetails.jobTitle
        lblMember.text = "Member since " + self.convertDateFormaterFoeOnlyDate(self.jobDetails.joiningDate) 
        lblName.text =  self.jobDetails.jobPostedBy // "   \(self.jobDetails.serviceCategory!)    "
        let stratDate =  self.convertDateFormater(self.jobDetails.jobStartDate) // lblStartDate.text
        let startTime =  self.convertTimeFormater(self.jobDetails.jobStartTime)
        lblStartDate.text = stratDate + " " + startTime
        
        let endDate =  self.convertDateFormater(self.jobDetails.jobEndDate) // lblStartDate.text
        let endTime =  self.convertTimeFormater(self.jobDetails.jobEndTime)
        lblEndDate.text = endDate + " " + endTime
        //lblMiles.text = self.jobDetails.distance + "miles"
        let doubleMiles = Double(self.jobDetails.distance)!
        let get = String(format: "%.2f", doubleMiles)
        lblMiles.text = get + " Miles"
        lblAddress.text = self.jobDetails.jobLocation
        lblJobDescriptions.text = self.jobDetails.jobDescription
        self.imgProfile.sd_setImage(with: URL(string:img_BASE_URL + self.jobDetails.profilePic!), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
        if self.jobDetails.isFavourite == "1"{
            self.BarbtnFavorites?.image = UIImage(named: "ic_like")
        }else{
            self.BarbtnFavorites?.image = UIImage(named: "ic_favourite")
        }
        if self.jobDetails.isApplied == "1"{
            self.btnApplied.isHidden = true
        }else{
           self.btnApplied.isHidden = false
        }
        if self.jobDetails.isPrivate == "1"{
            self.viewLocationHight.constant = 0
            self.viewLocation.isHidden = true
        }else{
            self.viewLocationHight.constant = 74
            self.viewLocation.isHidden = false
        }
       
    }
    @IBAction func actionOnViewProfile(_ sender: UIButton) {
        let details = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNViewProfileVC") as! MNViewProfileVC
          details.isFreelauncer = true
          details.userIdFreelauncer = self.jobDetails.postedBy
            Constant.isIndividual = "freelancer"
        self.navigationController?.pushViewController(details, animated: true)
        }
    @IBAction func actionOnFavorites(_ sender: UIButton) {
        if BarbtnFavorites?.image == UIImage(named: "ic_favourite") {
            BarbtnFavorites?.image = UIImage(named: "ic_like")
            self.callServiceForFavoritesAPI()
        } else {
            BarbtnFavorites?.image = UIImage(named: "ic_favourite")
            self.callServiceForFavoritesAPI()
        }
    }
    func callServiceForFavoritesAPI() {
      

//        ShowHud()
ShowHud(view: self.view)
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "job_id":strJobId]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNFavoritesAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
HideHud(view: self.view)
            if response.count != nil{
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                
                if message == "Favourite Remove successfully." {
                    self.BarbtnFavorites?.image = UIImage(named: "ic_favourite")
                }else{
                    self.BarbtnFavorites?.image = UIImage(named: "ic_like")
                }
                
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
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
    
    @IBAction func actionOnApply(_ sender: UIButton) {
        self.callServiceForJobApplyAPI()
    }
    func callServiceForJobApplyAPI() {
      

        //ShowHud()
ShowHud(view: self.view)
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "job_id":self.jobDetails.id ?? ""]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNJobApplyAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                self.navigationController?.popViewController(animated: true)
                self.alertViewForBacktoController(title: ALERTMESSAGE, message: message)
               
            }else if status == "4"
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
    func convertDateFormaterForAll(_ strdate: String) -> [String]
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let strDate = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "hh:mm a"
        let strTime = dateFormatter.string(from: date!)
        return [strDate,strTime]
    }
}
extension MNPostDetailFreelauncerVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayViewDetail.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.objIndividual.count
       
        if section == 0 {
            return 1
        } else{
            if self.isHourlyAvailableDate == true{
                 return hourlyJobTime.count
            }else{
             return 0
            }
      }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell : ViewdetailsTableViewCell?
                        cell = tableView.dequeueReusableCell(withIdentifier: "ViewdetailsTableViewCell", for: indexPath) as? ViewdetailsTableViewCell
                       return cell!
        }else{
           var cell : PostDetailTableViewCell?
         cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell", for: indexPath) as? PostDetailTableViewCell
            if hourlyJobTime.count > 0 {
            let start = self.convertDateFormater(hourlyJobTime[indexPath.row].date) + " " + hourlyJobTime[indexPath.row].startTime + " "
            // cell?.lblDates.text   = dict["dates"] as? String
             let end = self.convertDateFormater(hourlyJobTime[indexPath.row].date) + " " + hourlyJobTime[indexPath.row].endTime + " "
             let startDate = self.convertMMMDDYYYYTOYYYYMMDDWithTime(start)
             let endDate = self.convertMMMDDYYYYTOYYYYMMDDWithTime(end)

             let sDate = self.convertDateFormater24format(startDate)
             let eDate = self.convertDateFormater24format(endDate)
             cell?.lblDates.text = sDate[0] + " " + sDate[1] + " " + " to" + " " + eDate[1]
        }
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isHourlyAvailableDate == true {
             isHourlyAvailableDate = false
        }else{
             isHourlyAvailableDate = true
        }
        tblView.reloadData()
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

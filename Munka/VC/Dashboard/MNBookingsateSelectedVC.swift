//
//  MNBookingsateSelectedVC.swift
//  Munka
//
//  Created by Amit on 21/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNBookingsateSelectedVC: UIViewController {
    @IBOutlet weak var viewNoInternetConnection:UIView!
    @IBOutlet weak var viewNoDateFound:UIView!
    @IBOutlet weak var tblView:UITableView!
    
    var selectedDate = ""
    var strSelectedDateTitle = ""
    var offersList = [ModelBookedList]()
      var pageNumber: Int = 1
      var isTotalCountReached : Bool = false
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register the Loading Cell XIB for pagination
        self.navigationItem.title = strSelectedDateTitle
        print("selectedDate: \(selectedDate)")
        tblView.isHidden = true
        self.tblView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
        // Do any additional setup after loading the view.
       
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated) // No need for se
        offersList = [ModelBookedList]()
        if  isConnectedToInternet() {
                self.callServiceNotificationHistoryAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    @IBAction func actionOnback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func callServiceNotificationHistoryAPI() {

         //  ShowHud()

          //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
            "user_type":MyDefaults().swiftUserData["user_type"] as!  String,
                                         "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                         "page":pageNumber,
                                         "date":selectedDate
                                         ]
            debugPrint(parameter)
            HTTPService.callForPostApi(url:MNGetCalenderBydateAPI , parameter: parameter) { (response) in
                debugPrint(response)


           //  HideHud()
HideHud(view: self.view)
                if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                   let response = ModelBookedDateSelected.init(fromDictionary: response as! [String : Any])
                    //self.offersList = response.jobList
                     //  self.tblView.isHidden = false
                    //  self.tblView.reloadData()
              
                if response.jobList.count == 0 {
                             self.isTotalCountReached = true
                        }
                        self.offersList += response.jobList
                           if self.offersList.count == 0
                                {
                                    self.isTotalCountReached = true
                                    self.viewNoDateFound.isHidden = false
                                    self.tblView.isHidden = true
                                }else{
                                    if self.offersList.count % 10 != 0
                                    {
                                        self.isTotalCountReached = true
                                    }
                                    self.pageNumber = self.pageNumber + 1
                                    self.viewNoDateFound.isHidden = true
                                    self.tblView.isHidden = false
                                    self.tblView.reloadData()
                                }
                }  else if status == "4"
                              {
                                
                                self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else{
                                if self.offersList.count == 0
                                {
                                    self.viewNoDateFound.isHidden = false
                                    self.tblView.isHidden = true
                                }
                                 self.isTotalCountReached = true
                                 self.tblView.reloadData()
                                 self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}else{
                                
                                 self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
                   
               }
           }
       var isApiCalled: Bool = false

       func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
       {
           let endScrolling: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height + 1
           if endScrolling >= scrollView.contentSize.height && !self.isTotalCountReached
           {
               if !self.isApiCalled {
                   self.isApiCalled = true
                   self.callServiceNotificationHistoryAPI()
               }
           }
       }
       }
   

// MARK: - extension
extension MNBookingsateSelectedVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isTotalCountReached {
            return self.offersList.count
        } else {
            return self.offersList.count + 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.offersList.count
        {
            return 44
        }
        else{
            return 112
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : BookingDtaeSelectedTableViewCell!
       if indexPath.row == self.offersList.count {
           let cell : UITableViewCell = self.tblView.dequeueReusableCell(withIdentifier: "LoadingCell")!
           let activityIndicator : UIActivityIndicatorView = (cell.contentView.viewWithTag(100) as? UIActivityIndicatorView)!
           activityIndicator.startAnimating()
           return cell
       }else if self.offersList.count > 0
       {
        
        cell = tableView.dequeueReusableCell(withIdentifier: "BookingDtaeSelectedTableViewCell", for: indexPath) as? BookingDtaeSelectedTableViewCell
            cell?.imgView.sd_setImage(with: URL(string:img_BASE_URL + self.offersList[indexPath.row].freelancerProfilePic), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
           
        cell?.lblNameStatus?.text = self.offersList[indexPath.row].jobPostedBy
        cell?.lblJobtitle.text = self.offersList[indexPath.row].jobTitle
       
        cell?.lblStartdate.text = self.convertDateFormater1(self.offersList[indexPath.row].jobStartDate)
        cell?.lblEnddate.text = self.convertDateFormater1(self.offersList[indexPath.row].jobEndDate)
        
        if self.offersList[indexPath.row].jobType == "Fixed" {
            cell?.lblFixed.text = "fixed - " + "$" + self.offersList[indexPath.row].budgetAmount
            cell?.lblDays.text =  self.offersList[indexPath.row].timeDuration + " " + "Days"
        }else{
            
        }
        
//        cell?.lblDays.text = self.offersList[indexPath.row].jobDescription
//        cell?.lblFixed.text = self.offersList[indexPath.row].jobDescription
        
      
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNPostDetailVC") as! MNPostDetailVC
        details.strJobId = self.offersList[indexPath.row].id
        self.navigationController?.pushViewController(details, animated: true)
    }
        
    
}

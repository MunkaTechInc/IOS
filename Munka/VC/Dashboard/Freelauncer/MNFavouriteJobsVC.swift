//
//  MNFavouriteJobsVC.swift
//  Munka
//
//  Created by Amit on 21/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit


class MNFavouriteJobsVC: UIViewController {
    
    @IBOutlet weak var viewNoInternetConnection:UIView!
    @IBOutlet weak var viewNoDateFound:UIView!
    // @IBOutlet weak var viewAl:UIView!
   @IBOutlet weak var tblMyjobs:UITableView!
   // @IBOutlet weak var lblTotalEarning:UILabel!
   // @IBOutlet weak var lblNextPayment:UILabel!
    var objIndividual = [ModelFavoritesJobDetail]()
    var pageNumber: Int = 1
    var isTotalCountReached : Bool = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblMyjobs.isHidden = true
        viewNoDateFound.isHidden = true
        if  isConnectedToInternet() {
            self.callServiceForJobListAPI(listType: "All")
        } else {
            viewNoInternetConnection.isHidden = false
           // viewAl.isHidden = true
            self.showErrorPopup(message: internetConnetionError, title: alert)
    }
        self.tblMyjobs.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
    }
    
     @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
     }
//    @IBAction func actionOnGraph(_ sender: UIButton) {
////        let details = self.storyboard?.instantiateViewController(withIdentifier: "MNSaveJobsVC") as! MNSaveJobsVC
////              self.navigationController?.pushViewController(details, animated: true)
//    }
    func delegateJotType(strJob: String) {
        self.callServiceForJobListAPI(listType: strJob)
    }
    var isApiCalled: Bool = false
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let endScrolling: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height + 1
        if endScrolling >= scrollView.contentSize.height && !self.isTotalCountReached
        {
            if !self.isApiCalled {
                self.isApiCalled = true
                self.callServiceForJobListAPI(listType: "All")
            }
        }
    }
    func callServiceForJobListAPI(listType:String) {
       objIndividual = [ModelFavoritesJobDetail]()

       // ShowHud()
ShowHud(view: self.view)
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? ""]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNGetFavoritesJobsAPI , parameter: parameter) { (response) in
             debugPrint(response)

        //  HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelFavoritesJobs.init(fromDictionary: response as! [String : Any])
                // self.objIndividual = response.details
                
             if response.details.count == 0 {
                self.isTotalCountReached = true
                }
                self.objIndividual += response.details
                                       // self.lblTotalAmount.text = "$ " + response.walletAmount
              if self.objIndividual.count == 0
                    {
                       self.isTotalCountReached = true
                       self.viewNoDateFound.isHidden = false
                       self.tblMyjobs.isHidden = true
                   }else{
                       if self.objIndividual.count % 10 != 0
                       {
                           self.isTotalCountReached = true
                       }
                       self.pageNumber = self.pageNumber + 1
                       self.viewNoDateFound.isHidden = true
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
                       self.viewNoDateFound.isHidden = false
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
extension MNFavouriteJobsVC: UITableViewDataSource,UITableViewDelegate{
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
        var cell : FavouriteJobsTableViewCell?
        
        if indexPath.row == self.objIndividual.count {
            let cell : UITableViewCell = self.tblMyjobs.dequeueReusableCell(withIdentifier: "LoadingCell")!
                      let activityIndicator : UIActivityIndicatorView = (cell.contentView.viewWithTag(100) as? UIActivityIndicatorView)!
                      activityIndicator.startAnimating()
                      return cell
        } else{
        cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteJobsTableViewCell", for: indexPath) as? FavouriteJobsTableViewCell
        
//        cell?.imgView.sd_setImage(with: URL(string:img_BASE_URL + self.objIndividual[indexPath.row].profilePic), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
       
        cell?.lblJobtitle.text =  self.objIndividual[indexPath.row].jobTitle
//        cell?.lblJobtitle.text = "Member since " + self.objIndividual [indexPath.row].created.convertDateFormaterFoeOnlyDate1(self.objIndividual[indexPath.row].created)
        cell?.lblStartdate.text =  self.convertDateFormater1(self.objIndividual[indexPath.row].jobStartDate)
        cell?.lblEnddate.text =  self.convertDateFormater1(self.objIndividual[indexPath.row].jobEndDate)
        
         cell?.lblAddress.text = self.objIndividual[indexPath.row].jobLocation
        cell?.lblMiles.text = self.objIndividual[indexPath.row].distance + " Miles"
        cell?.lblPostedDate.text = "Posted Date " + self.objIndividual[indexPath.row].created.convertDateFormaterFoeOnlyDate1(self.objIndividual[indexPath.row].created)
       
        
        if  self.objIndividual[indexPath.row].jobType == "Fixed" {
            cell?.lblFixed.text = "Fixed - " + "$" + self.objIndividual[indexPath.row].budgetAmount
            cell?.lblDays.text = self.objIndividual[indexPath.row].timeDuration + " " + "Days"
        }else{
            cell?.lblFixed.text = "Hourly - " + "$" + self.objIndividual[indexPath.row].budgetAmount  + "/h"
            cell?.lblDays.text = self.objIndividual[indexPath.row].timeDuration + " " + "hr"
        }
        }
         if  self.objIndividual[indexPath.row].isPrivate == "1" {
            cell?.lblAddress.isHidden = true
         }else{
            cell?.lblAddress.isHidden = false
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let details = self.storyboard?.instantiateViewController(withIdentifier: "MNPostDetailVC") as! MNPostDetailVC
//        details.strJobId = self.objIndividual[indexPath.row].id
//        self.navigationController?.pushViewController(details, animated: true)
    
    }
    func convertDateFormater(_ strdate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }

}

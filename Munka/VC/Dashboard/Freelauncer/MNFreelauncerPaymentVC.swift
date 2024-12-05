//
//  MNFreelauncerPaymentVC.swift
//  Munka
//
//  Created by Amit on 09/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNFreelauncerPaymentVC: UIViewController {
       @IBOutlet weak var imgProfile: UIImageView!
       @IBOutlet weak var lblMember: UILabel!
       @IBOutlet weak var lblName: UILabel!
      
       @IBOutlet weak var lblReceivedFrom: UILabel!
       @IBOutlet weak var lblCreatedDate: UILabel!
       @IBOutlet weak var lblPrice: UILabel!
       @IBOutlet weak var lblTransactionID: UILabel!
       @IBOutlet weak var lblMemberID: UILabel!
       var details : ModelPaymentInfoDetail!
       var JobId = ""
        var jobPostedBy = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if  isConnectedToInternet() {
                self.callServiceForPaymentAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func actionOnBack(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOnMacaClaim(_ sender: UIButton) {
      
        let details = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNFreelancerMackClaimVC") as! MNFreelancerMackClaimVC
         //details.isFreelauncer = true
         details.jobId = JobId
        self.navigationController?.pushViewController(details, animated: true)
    }
    @IBAction func actionOnViewProfile(_ sender: UIButton) {
      let details = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNViewProfileVC") as! MNViewProfileVC
       // details.isFreelauncer = false
        Constant.isIndividual = "freelancer"
        details.userIdFreelauncer = jobPostedBy
   self.navigationController?.pushViewController(details, animated: true)
    }
    func callServiceForPaymentAPI() {

       // ShowHud()
        ShowHud(view: self.view)
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "job_id":JobId]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNPaymentInfoAPI , parameter: parameter) { (response) in
             debugPrint(response)

          //HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelPaymentInfo.init(fromDictionary: response as! [String : Any])
                    self.details = response.details
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
    func setupUI() {
        self.imgProfile!.sd_setImage(with: URL(string:img_BASE_URL + self.details.individualProfilePic), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
        
        lblMember.text! =  "Member Since " + self.convertDateFormaterFoeOnlyDate(self.details.individualJoiningDate) //self.details
        lblName.text = self.details.individualName
        lblReceivedFrom.text = self.details.freelancerName
        let Created = self.convertDateFormaterForAll(self.details.created)
        
        lblCreatedDate.text = Created[0] + "-" + Created[1]
        lblPrice.text = "$" + self.details.freelancerGet
        lblTransactionID.text = self.details.transactionId
        lblMemberID.text = self.details.mFreelancerId
       
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

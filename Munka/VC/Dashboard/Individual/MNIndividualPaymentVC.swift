//
//  MNIndividualPaymentVC.swift
//  Munka
//
//  Created by Amit on 14/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNIndividualPaymentVC: UIViewController {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblSinceMember:UILabel!
    @IBOutlet weak var lblTransactionId:UILabel!
    @IBOutlet weak var lblDateTime:UILabel!
    @IBOutlet weak var lblSubTotal:UILabel!
     @IBOutlet weak var lblTotal:UILabel!
     @IBOutlet weak var lblPenalty:UILabel!
    @IBOutlet weak var lblLateComing:UILabel!
    @IBOutlet weak var imgProfile:UIImageView!
    
    var jobid = ""
    var details : ModelIndividualPaymentDetail!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if  isConnectedToInternet() {
            self.callServiceForPaymentInvoiceindividualAPI()
            } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
            }
             // self.viewBottom.roundCornersBottomSide(corners: [.topLeft,.topRight], radius: 8)
          }
    
    @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func callServiceForPaymentInvoiceindividualAPI() {

       // ShowHud()
        ShowHud(view: self.view)
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "job_id":jobid]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNIndividualPaymentDetailsAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
            HideHud(view: self.view)

            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelindividualPaymentDetails.init(fromDictionary: response as! [String : Any])
                    self.details = response.details
                    self.setUI()
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
    func setUI()  {
        self.imgProfile.sd_setImage(with: URL(string:img_BASE_URL + self.details.freelancerProfilePic!), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
   
        lblName.text = self.details.freelancerName
        lblSinceMember.text = "Member Since " + self.details.freelancerJoiningDate.convertDateFormaterFoeOnlyDate1(self.details.freelancerJoiningDate)
        lblTransactionId.text = self.details.transactionId
        let cratedDate = self.details.created.convertDateFormaterForAll1(self.details.created)
        lblDateTime.text = cratedDate[0] + " " + cratedDate[1]
        lblPenalty.text = "$" + self.details.freelancerPenalty
        lblLateComing.text = self.details.penaltyType
        lblTotal.text = "$" + self.details.freelancerGet
        
        
    }
}

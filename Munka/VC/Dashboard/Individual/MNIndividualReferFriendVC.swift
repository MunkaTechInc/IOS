//
//  MNIndividualReferFriendVC.swift
//  Munka
//
//  Created by Amit on 18/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNIndividualReferFriendVC: UIViewController {
    @IBOutlet weak var lblpromocode:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblpromocode.text! = MyDefaults().swiftUserData["referral_code"] as! String
        // Do any additional setup after loading the view.
    if  isConnectedToInternet() {
       // self.callServiceReferFriendAPI()
        } else {
        self.showErrorPopup(message: internetConnetionError, title: alert)
             }
    }
    @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
 /*   func callServiceReferFriendAPI() {
      
        ShowHud(view: self.view)
       print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId!,
                                      "mobile_auth_token":MyDefaults().UDeviceToken!,
                                      "job_id":JobId,
                                      "contract_id":ContractId]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNIndividualProgressDetailJobListAPI , parameter: parameter) { (response) in
             debugPrint(response)
          HideHud(view: self.view)
          let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
//                let response = ModelIndiProgressDetail.init(fromDictionary: response as! [String : Any])
//                    self.details = response.details
//                    self.setUI()
            }
             else
             {
                 self.showErrorPopup(message: message, title: alert)
             }
            
         }
    } */
    
    //MARK:- Share Promo Action Sheet
    func openSharePromoCode(){
        let strPromoToShare = "Your friend just provided you a referral code " + lblpromocode.text! + " on munka. Use this code to get discounts on the Munka app and open the door for experiencing a wide range of services provided by the app."
        
            let vc = UIActivityViewController(activityItems: [strPromoToShare], applicationActivities: [])
            present(vc, animated: true, completion: nil)
    }
    
    //MARK:- Sahre Promocode Action
    @IBAction func btnShareYourCode(_ sender: Any) {
        self.openSharePromoCode()
    }
}

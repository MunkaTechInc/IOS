//
//  MNIndividualPromoCodeOfferVC.swift
//  Munka
//
//  Created by Amit on 18/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNIndividualPromoCodeOfferVC: UIViewController {
    @IBOutlet weak var viewNoInternetConnection:UIView!
        @IBOutlet weak var viewNoDateFound:UIView!
       @IBOutlet weak var tblView:UITableView!
        var offersList = [ModelOffersList]()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        // Do any additional setup after loading the view.
        if  isConnectedToInternet() {
                self.callServicePromoCodeAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    
     @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    func callServicePromoCodeAPI() {
      

       // ShowHud()
ShowHud(view: self.view)
       //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "page":"1",
                                      ]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNIndividualOfferlistAPI , parameter: parameter) { (response) in
             debugPrint(response)

        //  HideHud()
            HideHud(view: self.view)

            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelIndividualPromoCode.init(fromDictionary: response as! [String : Any])
                self.offersList = response.offersList
                    self.tblView.isHidden = false
                   self.tblView.reloadData()
            } else  if status == "4"
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
    func callServiceRedeempointAPI(tagValue:Int) {
      

        //ShowHud()
ShowHud(view: self.view)
       //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "coupon_code":self.offersList[tagValue].code ?? ""
                                      ]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNIndividualApplyOfferAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
HideHud(view: self.view)
          if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                self.navigationController?.popViewController(animated: true)
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }else  if status == "4"
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
    func callServiceTermsConditionsAPI(tagValue:Int) {
      

       // ShowHud()
ShowHud(view: self.view)
       //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "offer_id":self.offersList[tagValue].offerId ?? ""
                                      ]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNGetOffertemsConditiomsAPI , parameter: parameter) { (response) in
             debugPrint(response)

       //   HideHud()
HideHud(view: self.view)
          if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let result = response.value(forKey: "details") as! NSDictionary
               let msg = result["description"] as? String
               self.showErrorPopup(message: msg!, title: ALERTMESSAGE)
            }else  if status == "4"
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
}
// MARK: - extension
extension MNIndividualPromoCodeOfferVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offersList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : PromoOfferTableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "PromoOfferTableViewCell", for: indexPath) as? PromoOfferTableViewCell
       //  cell?.imgMyWallet.sd_setImage(with: URL(string:img_BASE_URL + self.mtWalletdetails[indexPath.row].freelancerProfilePic), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
       
        if self.offersList[indexPath.row].type == "Percent" {
            cell.lblPromocode.text! = self.offersList[indexPath.row].value  + "%"
        } else{
             cell.lblPromocode.text! = self.offersList[indexPath.row].code
        }
        
       
       
        let get =   "Get " + self.offersList[indexPath.row].value  + "%" + " Cashback"
         cell.lblOffers.text! = get
        
        cell.lblDec.text! = self.offersList[indexPath.row].descriptionField
        cell.btnPromo.tag = indexPath.row
        cell.btnPromo.addTarget(self, action: #selector(clickOnRedeem(sender:)), for: .touchUpInside)
        cell.btnTermsconditions.tag = indexPath.row + 1000
        cell.btnTermsconditions.addTarget(self, action: #selector(clickOnTermsConditions(sender:)), for: .touchUpInside)
        
        
        
        return cell
    }
    @objc func clickOnRedeem(sender: UIButton){
        self.callServiceRedeempointAPI(tagValue:sender.tag)
    }
    @objc func clickOnTermsConditions(sender: UIButton){
        self.callServiceTermsConditionsAPI(tagValue:sender.tag - 1000)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let details = self.storyboard?.instantiateViewController(withIdentifier: "MNPostDetailVC") as! MNPostDetailVC
//         self.navigationController?.pushViewController(details, animated: true)
    }
    
}

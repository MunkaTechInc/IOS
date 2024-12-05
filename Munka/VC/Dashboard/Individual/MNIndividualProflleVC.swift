//
//  MNIndividualProflleVC.swift
//  Munka
//
//  Created by Amit on 17/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import SDWebImage
class MNIndividualProflleVC: UIViewController,getStatusOfSwitch {
     var viewDetails : ViewProfileModelDetail!
    var strNotification = ""

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    var arrayProfile = [
//        ["image":"ic_my_wallet","name":"My Wallet"],
//                        ["image":"ic_withdraw","name":"Withdraw Amount"],
                        ["image":"ic_post_job","name":"My Jobs"],
                        ["image":"ic_receive_job","name":"Received Job Request"],
//                        ["image":"ic_promo-code","name":"Promo code offer"],
                        ["image":"ic_password","name":"Change Password"],
                        ["image":"ic_pin","name":"Change PIN"],
                        ["image":"","name":"Notification"],
                        ["image":"ic_faq","name":"FAQ's"],
                        ["image":"ic_terms_condition","name":"Terms & Conditions"],
                        ["image":"ic_privacy_policy","name":"Privacy Policy"],
                        ["image":"ic_contact","name":"Contact us"],
//                        ["image":"ic_refer_friend","name":"Refer a Friends"],
                        ["image":"ic_password","name":"Biometric Authentication"],
                        ["image":"ic_password","name":"Delete Account"],
                        ["image":"ic_signout","name":"Sign Out"]]
                        //["image":"ic_signout","name":"Sign Out"]]
                        //["image":"","name":""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        lblEmail.text = MyDefaults().swiftUserData["email"] as? String
        let fistName = MyDefaults().swiftUserData["first_name"] as? String
        let lastName = MyDefaults().swiftUserData["last_name"] as? String
            lblName.text = "\(fistName!)" + " " + "\(lastName!)"
       let imge = MyDefaults().swiftUserData["profile_pic"] as! String
        imgProfile.sd_setImage(with: URL(string:img_BASE_URL + imge), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile"))
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.actionOnNotificationBell),
        name: NSNotification.Name(rawValue: "ProfileNotification"),
        object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
           self.hidesBottomBarWhenPushed = false
        
        
        if  isConnectedToInternet() {
                self.callServiceForViewProfileAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    func callServiceForViewProfileAPI() {
          //  ShowHud()
        ShowHud(view: self.view)
               let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                             "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                             "other_user_id":MyDefaults().UserId ?? ""]
                debugPrint(parameter)
                HTTPService.callForPostApi(url:MNGetProfileAPI , parameter: parameter) { (response) in
                    debugPrint(response)
                 //  HideHud()
                    HideHud(view: self.view)
                   if response.count != nil{
                   let status = response["status"] as! String
                    let message = response["msg"] as! String
                    if status == "1"
                    {
                       let response = ModelViewProfile.init(fromDictionary: response as! [String : Any])
                       self.viewDetails = response.details
                      // self.strNotification = response.n
                        
                        self.lblEmail.text = self.viewDetails.email
                        MyDefaults().StripeCustomerId = self.viewDetails.stripeCustomerId
                        self.lblName.text = "\(self.viewDetails.firstName!)" + " " + "\(self.viewDetails.lastName!)"
                        self.imgProfile.sd_setImage(with: URL(string:img_BASE_URL + self.viewDetails.profilePic), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile"))
                        self.strNotification = self.viewDetails.sendNotification
                        self.tblProfile.reloadData()
                   }else if status == "4"
                    {
                       self.autoLogout(title: ALERTMESSAGE, message: message)
                       }
                     else if status == "2"
                    {
                       //self.autoLogout(title: ALERTMESSAGE, message: message)
                       }else if status == "0"
                       {
                       //   self.autoLogout(title: ALERTMESSAGE, message: message)
                          }
                  
                    
                   }else
                    {
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                   }
                   
                }
           }
    
    func callDeleteAccountAPI() {
          //  ShowHud()
        ShowHud(view: self.view)
               let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? ""]
                debugPrint(parameter)
                HTTPService.callForPostApi(url:MNDeleteAccountAPI , parameter: parameter) { (response) in
                    debugPrint(response)
                 //  HideHud()
                    HideHud(view: self.view)
                   if response.count != nil{
                       print(response)
                   let status = response["status"] as! String
                    let message = response["msg"] as! String
                    if status == "1"
                    {
                        self.autoLogout(title: ALERTMESSAGE, message: message)
                   }else if status == "4"
                    {
                       self.autoLogout(title: ALERTMESSAGE, message: message)
                       }
                     else if status == "2"
                    {
                       //self.autoLogout(title: ALERTMESSAGE, message: message)
                       }else if status == "0"
                       {
                       //   self.autoLogout(title: ALERTMESSAGE, message: message)
                          }
                  
                    
                   }else
                    {
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                   }
                   
                }
           }
    
    @objc private func actionOnNotificationBell(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        let vc = storyBoard.Main.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionOnViewProfile(_ sender: UIButton) {
        let viewProfile = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNViewProfileVC") as! MNViewProfileVC
        viewProfile.hidesBottomBarWhenPushed = true
       // viewProfile.isFreelauncer = false
        Constant.isIndividual = "Individual"
        viewProfile.userIdFreelauncer = MyDefaults().UserId
        self.navigationController?.pushViewController(viewProfile, animated: true)
 }
    @IBAction func actionOnEdit(_ sender: UIButton) {
    let viewProfile = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNEditProfileVC") as! MNEditProfileVC
    //viewProfile.isFreelauncer = false
    self.navigationController?.pushViewController(viewProfile, animated: true)
    }
    func didChangeSwitchState(sender: ProfileTableViewCell, isOn: Bool) {
        print(isOn)
        self.NotificationOff(status: isOn)
    }
}
// MARK: - extension
extension MNIndividualProflleVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayProfile.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ProfileTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell
        let dict = self.arrayProfile[indexPath.row]
        cell?.lblName.text = dict["name"]!
        let imag = dict["image"]!
        cell?.img?.image = UIImage(named: imag)
        
        switch indexPath.row {
        case 4:
            cell?.switchNotification.isHidden = false
            if self.strNotification == "0" {
                cell?.switchNotification.isOn = false
            }else{
                cell?.switchNotification.isOn = true
            }
            cell?.img?.isHidden = true
            cell?.switchNotification.tag = 1
            cell?.switchTag = 1
            cell?.delegate = self
        case 9:
            cell?.switchNotification.isHidden = false
            cell?.switchNotification.isOn = false
            if MyDefaults().isBeiometicsAuthOn == true {
                cell?.switchNotification.isOn = true
                MyDefaults().isBeiometicsAuthOn = true
            }else{
                cell?.switchNotification.isOn = false
                MyDefaults().isBeiometicsAuthOn = false
            }
            cell?.img?.isHidden = true
            cell?.switchNotification.tag = 2
            cell?.switchTag = 2
            cell?.delegate = self
        case 11:
              cell?.lblName.textColor = UIColor.hexStringToUIColor(hex: "#C7481A")
              cell?.switchNotification.isHidden = true
              cell?.img?.isHidden = false
        default:
            cell?.lblName.textColor = UIColor.hexStringToUIColor(hex: "#7E8290")
            cell?.switchNotification.isHidden = true
            cell?.img?.isHidden = false
        }
    return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.gettableViewindex(Tag: indexPath.row)
    
    }
    
    func gettableViewindex(Tag:Int) {
//        if Tag == 0 {
//        let myJob = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNMyWalletVC") as! MNMyWalletVC
//           myJob.hidesBottomBarWhenPushed = true
//           self.navigationController?.pushViewController(myJob, animated: true)
//        }
//        if Tag == 0 {
//            let myJob = storyBoard.Individual.instantiateViewController(withIdentifier: "MNIndividualWithdrawMoneyVC") as! MNIndividualWithdrawMoneyVC
//        myJob.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(myJob, animated: true)
//               }
        if Tag == 0 {
        let myJob = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNMyJobsVC") as! MNMyJobsVC
        myJob.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myJob, animated: true)
               }
        if Tag == 1 {
            let myJob = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNReceiveJobRequestVC") as! MNReceiveJobRequestVC
        myJob.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myJob, animated: true)
               }
//        if Tag == 2 {
//               let myJob = storyBoard.Individual.instantiateViewController(withIdentifier: "MNIndividualPromoCodeOfferVC") as! MNIndividualPromoCodeOfferVC
//        myJob.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(myJob, animated: true)
//            }
        if Tag == 2 {
            let profilePassword = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNProfilePasswordVC") as! MNProfilePasswordVC
           profilePassword.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(profilePassword, animated: true)
        }
        if Tag == 3 {
             let accessPin = storyBoard.Main.instantiateViewController(withIdentifier: "MNChangePinVC") as! MNChangePinVC
                 accessPin.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(accessPin, animated: true)
        }
        if Tag == 4 {
//             let accessPin = storyBoard.Main.instantiateViewController(withIdentifier: "MNChangePinVC") as! MNChangePinVC
//                       self.navigationController?.pushViewController(accessPin, animated: true)
        }
        if Tag == 5 {
                   let profilePassword = storyBoard.Main.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
                  profilePassword.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profilePassword, animated: true)
               }
        if Tag == 6 {
                          let profilePassword = storyBoard.Main.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
                profilePassword.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profilePassword, animated: true)
                      }
        if Tag == 7 {
            let profilePassword = storyBoard.Main.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
           profilePassword.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profilePassword, animated: true)
        }
        if Tag == 8 {
            let ContactusVC = storyBoard.Main.instantiateViewController(withIdentifier: "ContactusVC") as! ContactusVC
           ContactusVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(ContactusVC, animated: true)
        }
        
//        if Tag == 10 {
//            let profilePassword = storyBoard.Individual.instantiateViewController(withIdentifier: "MNIndividualReferFriendVC") as! MNIndividualReferFriendVC
//           profilePassword.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(profilePassword, animated: true)
//        }
        if Tag == 9 {

        }
        if Tag == 10 {
            let alertController = UIAlertController(title: "", message: "Do you want to delete your account?", preferredStyle: .alert)
            // Create the actions
            let okAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) {
                UIAlertAction in
               // self.clickOnYesAlert()
            }
            let cancelAction = UIAlertAction(title: "YES",style: UIAlertAction.Style.destructive) {
                UIAlertAction in
                // self.clickOnNoAlert()
//                 self.clickOnYesAlert()
                self.callDeleteAccountAPI()
            }
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
        if Tag == 11 {
            self.FuncationLogout(title: "", message: "Do you want sure logout.")
        }
    }
    func NotificationOff(status:Bool) {
       var strStatus = ""
        if !status{
             strStatus = "0"
        }else{
            strStatus = "1"
        }
           
      //  ShowHud()
        ShowHud(view: self.view)
           print(MyDefaults().UserId ?? "")
            let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                          "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                          "action":strStatus]
             debugPrint(parameter)
             HTTPService.callForPostApi(url:MNGetNotificationSettingAPI , parameter: parameter) { (response) in
                 debugPrint(response)
            //  HideHud()
                HideHud(view: self.view)
                if response.count != nil {
                let status = response["status"] as! String
                 let message = response["msg"] as! String
                 if status == "1"
                 {
                   // let response = ModelFavoritesJobs.init(fromDictionary: response as! [String : Any])
                   } else  if status == "4"
                    {
                        self.autoLogout(title: ALERTMESSAGE, message: message)
                 }
                 else
                 {
                   
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                 }
                
             }else{
                self.showErrorPopup(message:serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
}

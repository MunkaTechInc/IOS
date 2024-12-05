//
//  StripePaymentViewController.swift
//  Travelouder
//
//  Created by Namit on 05/07/17.
//  Copyright © 2017 Harish Patel. All rights reserved.
//

import UIKit
//import Stripe

class StripePaymentViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var enterCardNumber: UITextField!
    @IBOutlet weak var enterMonth: UITextField!
    @IBOutlet weak var enterYear: UITextField!
    @IBOutlet weak var enterCVC: UITextField!
    
    @IBOutlet weak var btnPayNow: UIButton!
    /// Property
    // Boolean variable to check card type
    var isAmExCard: Bool = false
    
    // To get selected page id
    var pageId: String = ""
    var isFromPageSetting: Bool = false
    var planId: String = ""
    var bookingId : String = ""
    var couponCode : String = ""
    
    // To get tapped button of last view for check segue
    var buttonType: String = ""
    var rechageAmmount = ""
    var totalAmmount = ""
    //MARK:- View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Set delegate of textfields to check validations
        self.enterCardNumber.delegate = self
        self.enterMonth.delegate = self
        self.enterYear.delegate = self
        self.enterCVC.delegate = self
        
        // Set textChange Method for getting typed text
        self.enterCardNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //btnPayNow.layer.borderColor = Global.hexStringToUIColor(GlobalConstant.kkGreenColor).cgColor
        
        self.cardImageView.image = #imageLiteral(resourceName: "card_unknown")
        isAmExCard = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    @IBAction func actionOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func payNowButtonTap(sender: AnyObject)
    {
        if !isStripeValidation() {
        if  isConnectedToInternet() {
             //self.callStripeAPIServer()
            
            } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    }
    func isStripeValidation() -> Bool {
        
        guard let budget = enterCardNumber.text , budget != ""
               else {showAlert(title: ALERTMESSAGE, message: "Please enter card number.")
                   return true}
       guard let startDate = enterMonth.text , startDate != ""
              else {showAlert(title: ALERTMESSAGE, message: "Please enter month.")
                  return true}
       guard let endDate = enterYear.text , endDate != ""
               else {showAlert(title: ALERTMESSAGE, message: "Please enter year.")
                   return true}
        guard let startTime = enterCVC.text , startTime != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter cvc.")
            return true}
       return false
    }
  
    func callStripeAPIServer() {
//        self.view.endEditing(true)
//           let card: STPCardParams = STPCardParams()
//           card.number = enterCardNumber.text
//           card.expMonth = UInt(enterMonth.text!)!
//           card.expYear = UInt(enterYear.text!)!
//           card.cvc = enterCVC.text
//          
//           
//           if STPCardValidator.validationState(forCard: card) == .valid {
//               // the card is valid.
//               STPAPIClient.shared().createToken(withCard: card) { (token, error) in
//                   if let error = error {
//                       print(error)
//                       //Global.showAlertMessage(Constants.APP_NAME, andMessage: "Please try again", GlobalAlert: false)
//                    self.showErrorPopup(message:  "Please try again", title: ALERTMESSAGE)
//                   } else{
//                       print(token!)
//                       /// API Call for payment
//                      // self.postDataForMakePayment(token!.tokenId)
//                    self.callServiceForrechargeWalletAPI(token: token!.tokenId)
//                }
//               }
//           }
//           else
//           {
////               Global.showAlertMessage("Oops!", andMessage: "We could not successfully authorize the card given", GlobalAlert: false)
////               DispatchQueue.main.async(execute: {
////                   Global.dismissGlobalLoader()
////               })
//        self.showErrorPopup(message: "We could not successfully authorize the card given", title: "Oops!")
//        }
    }
    
    
    
    
    // MARK: - API Calling
    func callServiceForrechargeWalletAPI(token:String) {
      

      //  ShowHud()
ShowHud(view: self.view)
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "token":token,
                                     "recharge_amount":rechageAmmount,
                                     "total_amount":totalAmmount]
         debugPrint(parameter)
       HTTPService.callForPostApi(url:MNRechargeWalletAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
        HideHud(view: self.view)

        if response.count != nil {
        let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
//                let response = ModelReceivedJobRequest.init(fromDictionary: response as! [String : Any])
//                self.requestList = response.requestList
//                self.tblView.isHidden = false
//                self.tblView.reloadData()
               
               for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: MNMyWalletVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                 self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }
            } else if status == "4"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)
             }
             else
             {
//                self.viewNoDataFound.isHidden = false
//                self.view.bringSubviewToFront(self.viewNoDataFound)
//                self.showErrorPopup(message: message, title: alert)
        }}else
                     {
        //                self.viewNoDataFound.isHidden = false
        //                self.view.bringSubviewToFront(self.viewNoDataFound)
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                     }
            
         }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == enterCardNumber
        {
            if ((enterCardNumber.text?.count)! >= 16 && range.length == 0)
            {
                return false
                
                return true
            }
        }
        else if textField == enterMonth
        {
            if ((enterMonth.text?.count)! >= 2 && range.length == 0)
            {
                return false
            }
            return true
        }
        else if textField == enterYear
        {
            if ((enterYear.text?.count)! >= 4 && range.length == 0)
            {
                return false
            }
            return true
        }
        else if textField == enterCVC
        {
            if isAmExCard
            {
                if ((self.enterCVC.text?.count)! >= 4 && range.length == 0)
                {
                    return false
                }
            }
            else
            {
                if ((self.enterCVC.text?.count)! >= 3 && range.length == 0)
                {
                    return false
                }
            }
        }
        return true
    }
    
    
    @IBAction func textFieldDidChange(_ textField: UITextField)
    {
        if (self.enterCardNumber.text?.hasPrefix("34"))! || (self.enterCardNumber.text?.hasPrefix("37"))!
        {
            cardImageView.image = #imageLiteral(resourceName: "card_american")
            isAmExCard = true
        }
        else if (self.enterCardNumber.text?.hasPrefix("4"))!
        {
            cardImageView.image = #imageLiteral(resourceName: "card_visa")
            isAmExCard = false
        }
        else if (self.enterCardNumber.text?.hasPrefix("60"))! || (self.enterCardNumber.text?.hasPrefix("62"))! || (self.enterCardNumber.text?.hasPrefix("64"))! || (self.enterCardNumber.text?.hasPrefix("65"))!
        {
            cardImageView.image = #imageLiteral(resourceName: "card_discover")
            isAmExCard = false
        }
        else if (self.enterCardNumber.text?.hasPrefix("50"))! || (self.enterCardNumber.text?.hasPrefix("51"))! || (self.enterCardNumber.text?.hasPrefix("52"))! || (self.enterCardNumber.text?.hasPrefix("53"))! || (self.enterCardNumber.text?.hasPrefix("54"))! || (self.enterCardNumber.text?.hasPrefix("55"))!
        {
            cardImageView.image = #imageLiteral(resourceName: "card_mastercard")
            isAmExCard = false
        }
        else if (self.enterCardNumber.text?.hasPrefix("35"))!
        {
            cardImageView.image = #imageLiteral(resourceName: "card_jcb")
            isAmExCard = false
        }
        else if (self.enterCardNumber.text?.hasPrefix("300"))! || (self.enterCardNumber.text?.hasPrefix("301"))! || (self.enterCardNumber.text?.hasPrefix("302"))! || (self.enterCardNumber.text?.hasPrefix("303"))! || (self.enterCardNumber.text?.hasPrefix("304"))! || (self.enterCardNumber.text?.hasPrefix("305"))! || (self.enterCardNumber.text?.hasPrefix("309"))! || (self.enterCardNumber.text?.hasPrefix("36"))! || (self.enterCardNumber.text?.hasPrefix("38"))! || (self.enterCardNumber.text?.hasPrefix("39"))!
        {
            cardImageView.image = #imageLiteral(resourceName: "card_diners")
            isAmExCard = false
        }
        else
        {
            cardImageView.image = #imageLiteral(resourceName: "card_unknown")
            isAmExCard = false
            if self.enterCardNumber.text == ""
            {
                self.enterCVC.text = ""
            }
        }
    }
}

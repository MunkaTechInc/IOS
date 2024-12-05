//
//  MNAddMoneyVC.swift
//  Munka
//
//  Created by Amit on 04/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
//import Braintree
//import BraintreeDropIn
//import BraintreeDropIn
import WebKit
import Stripe

class MNAddMoneyVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var vwPayment: UIView!
    @IBOutlet weak var webKitPayment: WKWebView!
  
    //MARK: - MNRechargeWalletAPI
    func callServiceForrechargeWalletAPI() {
        
        //ShowHud()
        ShowHud(view: self.view)
        print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",//1
            "mobile_auth_token":MyDefaults().UDeviceToken ?? "",//2
            "job_id":"", //optional//3
            "recharge_amount":Ammount,//4
            "total_amount":NetPaybleAmmount]//5
        debugPrint("-------------",parameter)
        HTTPService.callForPostApi(url:MNMakePaymentAPI , parameter: parameter) { (response) in
            // debugPrint("-------------",response)
            print("MNMakePaymentAPI API-----",response)
            //   HideHud()
            HideHud(view: self.view)
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    let detailspay = response["details"] as! NSDictionary
                    
                    let strpayurl = detailspay.value(forKey: "payment_url") as! String
                    self.vwPayment.isHidden = false
                    let request = URLRequest(url: URL(string: strpayurl)!)
                    self.webKitPayment?.load(request)
                    
                    //self.alertViewForBacktoController(title: ALERTMESSAGE, message: message)
                }
                else if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    //                self.viewNoDataFound.isHidden = false
                    //                self.view.bringSubviewToFront(self.viewNoDataFound)
                    //                self.showErrorPopup(message: message, title: alert)
                }
            }else
            {
                //                self.viewNoDataFound.isHidden = false
                //                self.view.bringSubviewToFront(self.viewNoDataFound)
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<8).map{ _ in letters.randomElement()! })
    }
    
    func callServiceForCreateStripeIntent() {
        if MyDefaults().StripeCustomerId == ""{
            MyDefaults().StripeCustomerId = "cus_PRdKhaFhweBUSU"
        }
        ShowHud(view: self.view)
        print(MyDefaults().UserId ?? "")
        let amount = Int(50) * 100
        let parameter: [String: Any] = ["userId":MyDefaults().UserId ?? "",
                                        "stripeAmount" : "\(amount)" ]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNCreateStripeIntentAPI , parameter: parameter) { (response) in
            debugPrint(response)
            
            //  HideHud()
            HideHud(view: self.view)
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String

                if status == "1" {
                    print("callServiceForCreateStripeIntent API response = ",message)
                    let paymentIntent = response["paymentIntent"] as! String
                    self.presentPaymentSheet(clientSecret: paymentIntent)
                }else  if status == "4"{
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }else{
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }
            }else{
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
    
    //MARK: - MNAdmincommisionAPI
    func callServiceForCommisionApiAPI() {
        
        ShowHud(view: self.view)
        
        //  ShowHud()
        //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken ?? ""]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNAdmincommisionAPI , parameter: parameter) { (response) in
            debugPrint(response)
            // HideHud
            // HideHud()
            HideHud(view: self.view)
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    let dict = response["details"] as! [String : Any]
                    
                    self.adminCommision = dict["admin_commission"] as! String
                    let intCommision = Double(self.adminCommision)
                    
                    let commisionagent = String(format:"%.0f", intCommision!)
                    print(commisionagent)
                    let commision = commisionagent + " " + "%"
                    self.lblCommision.text = "Charges (\((commision)))"
                    
                } else if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                } }else
            {
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
    
    // MARK: - paymentDriverDelegate
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - webView
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print("didStartProvisionalNavigation ------ start :")
        print(#function)
        print("didStartProvisionalNavigation ------ end :")
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit ------ start :")
        print(#function)
        print("didCommit ------ end :")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("navigation ------ start :")
        print(#function)
        print("navigation ------ end :")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation ------ start :")
        print(#function)
        print("didReceiveServerRedirectForProvisionalNavigation ------ end :")
    }
    
    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {
            print("observeValue-------- \(key)") // url value
        }
    }
    
    // MARK: - BTAppSwitchDelegate
     
    // Optional - display and hide loading indicator UI
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        showLoadingUI()
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        hideLoadingUI()
    }
    
//    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
//
//    }
    
    // MARK: - Private methods
    func showLoadingUI() {
        
    }
    
    @objc func hideLoadingUI() {
        
    }
 
    
    #if HAS_CARDIO
    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
    // for more details.
    var acceptCreditCards: Bool = true
    {
        didSet {
        // payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    #else
    var acceptCreditCards: Bool = true {
        didSet {
        // payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    #endif
    
    var resultText = "" // empty
    // var payPalConfig = PayPalConfiguration() // default
    @IBOutlet weak var txtAmount:UITextField!
    @IBOutlet weak var lblTotalAmount:UILabel!
    @IBOutlet weak var lblCommision:UILabel!
    @IBOutlet weak var lblCharges:UILabel!
    @IBOutlet weak var lblNetPayble:UILabel!
    @IBOutlet weak var viewHeight:NSLayoutConstraint!
    var adminCommision = ""
    var commission : Double = 0
    var transactionID : String = ""
    //var commission : Double = 0
    var NetPaybleAmmount = ""
    var Ammount = ""
    var ephemeralSecretKey = ""
    var PaymentIntendClientSecret = ""
    var TransactionID = ""
    var intendpaymentMethod = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //Paypal configure
  
        viewHeight.constant = 52
        if  isConnectedToInternet() {
            self.callServiceForCommisionApiAPI()
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        // Do any additional setup after loading the view.
        txtAmount.addTarget(self, action: #selector(MNAddMoneyVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
 
        // Add observer
        webKitPayment.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        viewHeight.constant = 52
        lblCharges.text = "$0.0"
        lblNetPayble.text = "$0.0"
        lblTotalAmount.text = "$0.0"
        txtAmount.text = ""
        // PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let admincommision = Double(adminCommision)!
        if textField.text!.count > 0 {
            viewHeight.constant = 72
            if textField.text!.first! == "."{
                txtAmount.text = ""
            }else{
                if let ammount = Double(textField.text!) {
                    let res = (ammount/100.0) * admincommision
                    lblCharges.text = "$" + String(format:"%.2f", res)
                    let add = ammount + res
                    NetPaybleAmmount = String(add)
                     
                    lblNetPayble.text = "$" + String(format:"%.2f", add)
                    lblTotalAmount.text = "$" + textField.text!
                    Ammount = textField.text!
                }
            }
        }else{
            viewHeight.constant = 52
            lblCharges.text = "$0.0"
            lblNetPayble.text = "$0.0"
            lblTotalAmount.text = "$0.0"
        }
    }
    
    func extractPaymentIntentID(from clientSecret: String) -> String? {
        // Decode the base64-encoded client secret
        guard let decodedData = Data(base64Encoded: clientSecret),
              let decodedString = String(data: decodedData, encoding: .utf8) else {
            print("Error decoding client secret")
            return nil
        }

        // The decoded string should be in JSON format
        guard let jsonData = decodedString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            print("Error parsing JSON")
            return nil
        }

        // Extract the Payment Intent ID from the JSON
        if let paymentIntentID = json["payment_intent"] as? String {
            return paymentIntentID
        } else {
            print("Payment Intent ID not found in JSON")
            return nil
        }
    }

    // Function to present PaymentSheet with 3D Secure support
   
      func presentPaymentSheet(clientSecret: String) {

          var configuration = PaymentSheet.Configuration()
          configuration.merchantDisplayName = "Munka"

          let paymentSheet = PaymentSheet(
              paymentIntentClientSecret: clientSecret,
              configuration: configuration)
          
          paymentSheet.present(from: self) { [weak self] paymentResult in
              guard let self = self else { return }
              
              switch paymentResult {
              case .completed:
                  if let paymentIntentID = self.extractPaymentIntentID(from: self.PaymentIntendClientSecret) {
                      self.getPymentMethidAPI(paymentIntentID: paymentIntentID)
                  } else {
                      print("Failed to extract Payment Intent ID")
                  }
              case .canceled:
                  print("Payment canceled!")
                  // Handle cancellation
              case .failed(let error):
                  print("Payment failed:", error.localizedDescription)
                  // Handle failure
              }
          }
      }
    
    func pay() {
        
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Munka"
        configuration.customer = .init(id: MyDefaults().StripeCustomerId, ephemeralKeySecret: ephemeralSecretKey)
        let paymentSheet = PaymentSheet(
            paymentIntentClientSecret: PaymentIntendClientSecret,
            configuration: configuration)
        
        paymentSheet.present(from: self) { [weak self] (paymentResult) in
            print(paymentResult)
            switch paymentResult {
            case .completed:
                print("paymentResult is : ", paymentResult)
                if #available(iOS 13.0, *) {
//                    self!.getPymentMethidAPI()
                } else {
                    // Fallback on earlier versions
                }
            case .canceled:
                print("Payment canceled!")
            case .failed(let error):
                print(error.localizedDescription)
            }
        }
    }
     
    func getPymentMethidAPI(paymentIntentID: String){
        var request = URLRequest(url: URL(string: "https://api.stripe.com/v1/payment_intents/\(paymentIntentID ?? "")")!,timeoutInterval: Double.infinity)
//        request.addValue("Bearer sk_test_51HCXi0AWuQkXhibTKF0FM6mGjonhmQyMuLzR14N5R6DVazbTpkq7a2D6TY9BcAnlx3ZaqBFeSoWIDBi4rTaDoT5Q00v781QCpe", forHTTPHeaderField: "Authorization")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("responseData = ",responseData)
                    if let paymentMethod = responseData["payment_method"] as? String {
                        print("Payment Method: \(paymentMethod)")
                        self.intendpaymentMethod = paymentMethod
                    } else {
                        print("Payment method not found in response")
                    }
                } else {
                    print("Unable to parse response data")
                }
            } catch {
                print("Error parsing response: \(error)")
            }
        }
        
        //        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        //            guard let data = data else {
        //                print(String(describing: error))
        //                return
        //            }
        //
        //            print(data)
        //            let responseData = data as! [String:AnyObject]
        //            let paymentMethod = responseData["payment_method"] as? String ?? ""
        //            print(paymentMethod)
        //            if paymentMethod != "" {
        //                self.intendpaymentMethod = paymentMethod
        //            }
        //
        //        }
        
        task.resume()
    }
    
    @IBAction func actionOnAddMoney(_ sender: Any) {
        
        if !isAddWalletValidation() {
            if  isConnectedToInternet() {
                //  self.callStripePayment()
                if txtAmount.text!  != "0.0" && txtAmount.text! != "0" && txtAmount.text! != "0.00" && txtAmount.text! != "0.000" &&
                    self.txtAmount.text!  != "00" && self.txtAmount.text!  != "000" &&
                    self.txtAmount.text!  != "0000" &&
                    self.txtAmount.text!  != "00000"{
                    self.callServiceForCreateStripeIntent()
//                    callServiceForrechargeWalletAPI()
              
                }else{
                    self.showErrorPopup(message: "Please enter valid amount.", title: ALERTMESSAGE)
                }
            }else {
                self.showErrorPopup(message: internetConnetionError, title: ALERTMESSAGE)
            }
        }
    }
    @IBAction func TfAction(_ sender: Any) {
        if txtAmount.text?.first == "."{
            txtAmount.text = ""
        }
    }
    
    @IBAction func actionOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func isAddWalletValidation() -> Bool {
        guard let ammount = txtAmount.text , ammount != ""
            else {showAlert(title: ALERTMESSAGE, message: "Please enter amount.")
                return true}
        
        return false
    }
    
    func callStripePayment()  {
        if let viewController = UIStoryboard(name: "Tab", bundle: nil).instantiateViewController(withIdentifier: "StripePaymentViewController") as? StripePaymentViewController{
            //   viewController.modalPresentationStyle = .fullScreen
            // self.present(viewController, animated: true, completion: nil)
            viewController.totalAmmount = lblNetPayble.text! 
            viewController.rechageAmmount = lblTotalAmount.text!
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension MNAddMoneyVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if txtAmount == textField {
            if textField.text?.count == 0 && string == "."
            {
                return false
            }
            
            if textField.text == "0" && string == "0"
            {
                return false
            }
            
            let amountString: NSString = textField.text! as NSString
            let newString: NSString = amountString.replacingCharacters(in: range, with: string) as NSString
            let regex = "\\d{0,5}(\\.\\d{0,2})?"
            
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return predicate.evaluate(with:newString)
        }
        else{
            return true
        }
    }
}

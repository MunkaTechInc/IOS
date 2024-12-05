//
//  MNIndividualWithdrawMoneyVC.swift
//  Munka
//
//  Created by Amit on 17/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNIndividualWithdrawMoneyVC: UIViewController {
    @IBOutlet weak var viewNoInternetConnection:UIView!
     @IBOutlet weak var viewNoDateFound:UIView!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var txtAmmount:UITextField!
    var list = [ModelWithdrawListDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
        txtAmmount.delegate = self
        // Do any additional setup after loading the view.
    if  isConnectedToInternet() {
            self.callServicewithrequestListAPI()
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
    }
    
    }
   
    
    func isLoginValidation() -> Bool {
        guard let ammount = txtAmmount.text , ammount != ""
            else {showAlert(title:ALERTMESSAGE, message: "Please enter amount.")
                return true}
       return false
    }
    func callServicewithrequestListAPI() {

        //ShowHud()
        ShowHud(view: self.view)

       //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "page":"1",
                                      ]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNIndividualWalletRequestListAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
            HideHud(view: self.view)

            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelIndividualWithdrawlist.init(fromDictionary: response as! [String : Any])
                    self.list = response.details
                    self.tblView.isHidden = false
                   self.tblView.reloadData()
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

    @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOnProceed(_ sender: UIButton) {
        if !isLoginValidation() {
            if  isConnectedToInternet() {
                 if self.txtAmmount.text! != "0" &&
                     self.txtAmmount.text!  != "00" && self.txtAmmount.text!  != "000" &&
                    self.txtAmmount.text!  != "0000" &&
                    self.txtAmmount.text!  != "00000" && self.txtAmmount.text!  != "0.0" &&  self.txtAmmount.text! != "0.00" && self.txtAmmount.text! != "0.000" && self.txtAmmount.text! != " " && self.txtAmmount.text! != "." && self.txtAmmount.text! != ".0" && self.txtAmmount.text! != ".00" && self.txtAmmount.text! != ".000" && self.txtAmmount.text! != ".0000"{
                    self.callServiceAddWithdrawListAPI()
                }
                 else{
                    self.showErrorPopup(message: "Please enter valid amount.", title: alert)
                }
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    func callServiceAddWithdrawListAPI() {
      

      //  ShowHud()
ShowHud(view: self.view)
       //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "amount":self.txtAmmount.text!,
                                      ]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNIndividualAddWithdrawequestAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
               // self.showErrorPopup(message: message, title: ALERTMESSAGE)
                self.getAlertview(msz: message, Tit: ALERTMESSAGE)
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
    func getAlertview(msz:String,Tit:String) {
        let alertController = UIAlertController(title: Tit, message: msz, preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.PopUpview()
        }
        
        // Add the actions
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func PopUpview()  {
        self.navigationController?.popViewController(animated: true)
        
    }
}
// MARK: - extension
extension MNIndividualWithdrawMoneyVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : WithDrawMoneyTableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "WithDrawMoneyTableViewCell", for: indexPath) as? WithDrawMoneyTableViewCell
       //  cell?.imgMyWallet.sd_setImage(with: URL(string:img_BASE_URL + self.mtWalletdetails[indexPath.row].freelancerProfilePic), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
        let createdDate = self.list[indexPath.row].created.convertDateFormaterForAll1(self.list[indexPath.row].created)
        
         cell.lblCreatedDate.text! = createdDate[0] + " "
        cell.lblCreatedTime.text! =  createdDate[1]
        if self.list[indexPath.row].status == "Completed"{
            cell.lblStatus.text! = self.list[indexPath.row].status
            cell.lblStatus.backgroundColor = UIColor.hexStringToUIColor(hex: "#3B9A6E")
        }else{
             cell.lblStatus.text! = self.list[indexPath.row].status
             cell.lblStatus.backgroundColor = UIColor.hexStringToUIColor(hex: "#E5983E")
        }
        cell.lblAmmount.text! =  "$" + self.list[indexPath.row].amount
        cell.lblDescriptions.text! = "Withdraw money to bank"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let details = self.storyboard?.instantiateViewController(withIdentifier: "MNPostDetailVC") as! MNPostDetailVC
//         self.navigationController?.pushViewController(details, animated: true)
    }
    
}

extension MNIndividualWithdrawMoneyVC: UITextFieldDelegate {
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
    if txtAmmount == textField {
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

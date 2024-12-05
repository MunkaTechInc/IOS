//
//  SelectReasonVC.swift
//  Munka
//
//  Created by Amit on 10/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import Toaster
protocol GetSelectReason {
    
    func delegateCancelReasonType(Model:ModelReasonDetail)
}

class SelectReasonVC: UIViewController {
 @IBOutlet weak var tblViewCategory:UITableView!
     var Categorydetails = [ModelReasonDetail]()
    var delagate: GetSelectReason!
    override func viewDidLoad() {
        super.viewDidLoad()
        if  isConnectedToInternet() {
                   CallServiceForSelectReasonAPI()
               } else {
                   self.showErrorPopup(message: internetConnetionError, title: alert)
               }
        // Do any additional setup after loading the view.
    }
    @IBAction func actionOnTouchUp(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func CallServiceForSelectReasonAPI() {

       // ShowHud()
        ShowHud(view: self.view)

        let parameter: [String: Any] = ["user_id":MyDefaults().UserId!,
        "mobile_auth_token":MyDefaults().UDeviceToken!]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNClaimreasonAPI , parameter: parameter) { (response) in
            debugPrint(response)

          //  HideHud()
            HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                 let response = ModelReasonList.init(fromDictionary: response as! [String : Any])
                 self.Categorydetails = response.details
                Toast(text: message).show()
                self.tblViewCategory?.reloadData()
            }else if status == "4"
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
extension SelectReasonVC: UITableViewDataSource,UITableViewDelegate{
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.Categorydetails.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectReasonTableViewCell") as! SelectReasonTableViewCell
            cell.lblReason.text! = self.Categorydetails[indexPath.row].name
            return cell
    
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if self.delagate != nil {
         self.dismiss(animated: true, completion: nil)
        let obj = self.Categorydetails[indexPath.row]
        self.delagate.delegateCancelReasonType(Model: obj)
        }
    }
}

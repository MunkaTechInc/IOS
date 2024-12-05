//
//  MNMyEarningVC.swift
//  Munka
//
//  Created by Amit on 21/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit



class MNMyEarningVC: UIViewController {
    @IBOutlet weak var viewNoInternetConnection:UIView!
    @IBOutlet weak var viewNoDateFound:UIView!
     @IBOutlet weak var viewAl:UIView!
    @IBOutlet weak var tblMyjobs:UITableView!
    @IBOutlet weak var lblTotalEarning:UILabel!
    @IBOutlet weak var lblNextPayment:UILabel!
    var objIndividual = [ModelMyEarnDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblMyjobs.isHidden = true
        viewNoDateFound.isHidden = true
        if  isConnectedToInternet() {
            self.callServiceForJobListAPI(listType: "All")
        } else {
            viewNoInternetConnection.isHidden = false
            viewAl.isHidden = true
            self.showErrorPopup(message: internetConnetionError, title: alert)
    }
    }
    
     @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
     }
    @IBAction func actionOnGraph(_ sender: UIButton) {
        let details = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNGraphVC") as! MNGraphVC
        self.navigationController?.pushViewController(details, animated: true)
    }
    func delegateJotType(strJob: String) {
        self.callServiceForJobListAPI(listType: strJob)
    }
    func callServiceForJobListAPI(listType:String) {
     //  objIndividual = [ModelMyEarnDetail]()
//<<<<<<< Updated upstream
     //   ShowHud()
//=======
     //   ShowHud()
//>>>>>>> Stashed changes
        ShowHud(view: self.view)
        
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? ""]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNGetFreelauncerEarningAPI , parameter: parameter) { (response) in
             debugPrint(response)
//<<<<<<< Updated upstream
       //   HideHud()
//=======
          //HideHud()
            HideHud(view: self.view)
//>>>>>>> Stashed changes
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelMyEarning.init(fromDictionary: response as! [String : Any])
                 self.objIndividual = response.details
                
                if let number = response.nextPayment {
                    print("Contains a value! It is \(number)!")
                    self.lblNextPayment.text = "$" + number
                } else {
                    print("Doesn’t contain a number")
                    self.lblNextPayment.text = "$" + "00.0"
                }
                if let totalearning = response.totalEarning {
                    //print("Contains a value! It is \(number)!")
                    self.lblTotalEarning.text = "$" + totalearning
                } else {
                    print("Doesn’t contain a number")
                    self.lblTotalEarning.text = "$" + "00.0"
                }
                
                
                //self.lblTotalEarning.text = "$" + response.totalEarning
                 self.tblMyjobs.isHidden = false
                 self.tblMyjobs.reloadData()
            }
             else
             {
                self.tblMyjobs.isHidden = true
                 self.tblMyjobs.reloadData()
                self.showErrorPopup(message: message, title: alert)
             }
            
         }else{
            self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
        }
    }
    }
}
// MARK: - extension
extension MNMyEarningVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objIndividual.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : MyEarningTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "MyEarningTableViewCell", for: indexPath) as? MyEarningTableViewCell
        
        cell?.imgView.sd_setImage(with: URL(string:img_BASE_URL + self.objIndividual[indexPath.row].profilePic), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
        cell?.lblNameStatus.text =  self.objIndividual[indexPath.row].name
        cell?.lblJobtitle.text =  self.objIndividual[indexPath.row].jobTitle
        cell?.lblScienceMember.text = "Member since " + self.objIndividual [indexPath.row].joiningDate.convertDateFormaterFoeOnlyDate1(self.objIndividual[indexPath.row].joiningDate)
        cell?.lblStartdate.text =  self.convertDateFormater1(self.objIndividual[indexPath.row].jobStartDate)
       // cell?.lblEnddate.text =  self.convertDateFormater1(self.objIndividual[indexPath.row].jobEndDate)
     cell?.lblEnddate.text =   Global.convertDateFormat(self.objIndividual[indexPath.row].jobEndDate, sourceFormate: "yyyy-MM-dd", targetFormate: "MMM dd, yyyy")
        
        if  self.objIndividual[indexPath.row].jobType == "Fixed" {
            cell?.lblAmount.text = "$" + self.objIndividual[indexPath.row].earnAmount
            cell?.lblDays.text = self.objIndividual[indexPath.row].timeDuration + " " + "Days"
        }else{
            cell?.lblDays.text = "Hourly - " + "$" + self.objIndividual[indexPath.row].earnAmount  + "/hr."
            cell?.lblDays.text = self.objIndividual[indexPath.row].timeDuration + " " + "hr."
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

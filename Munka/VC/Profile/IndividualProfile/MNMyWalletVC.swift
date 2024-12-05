//
//  MNMyWalletVC.swift
//  Munka
//
//  Created by Amit on 29/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNMyWalletVC: UIViewController {
    @IBOutlet weak var tblMyWallet:UITableView!
    @IBOutlet weak var lblTotalAmount:UILabel!
    var mtWalletdetails = [ModelMyWalletDetail]()
    var pageNumber: Int = 1
         var isTotalCountReached : Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Your Code Here...
    self.tblMyWallet.isHidden = true
    if  isConnectedToInternet() {
        
        self.pageNumber = 1
            self.callServiceForMyWalletAPI()
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tblMyWallet.isHidden = true
//        if  isConnectedToInternet() {
//                self.callServiceForMyWalletAPI()
//            } else {
//                self.showErrorPopup(message: internetConnetionError, title: alert)
//        }
        // Do any additional setup after loading the view.
      self.tblMyWallet.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
    }
    
    var isApiCalled: Bool = false
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
           {
               let endScrolling: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height + 1
               if endScrolling >= scrollView.contentSize.height && !self.isTotalCountReached
               {
                   if !self.isApiCalled {
                       self.isApiCalled = true
                    self.callServiceForMyWalletAPI()
                   }
               }
           }
    func callServiceForMyWalletAPI() {
        
        
        // ShowHud()
        ShowHud(view: self.view)
        
        //print(MyDefaults().UserId!)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                        "page":pageNumber,
        ]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNWalletHistoryAPI , parameter: parameter) { (response) in
            debugPrint(response)
            self.isApiCalled = false
            
            // HideHud()
            HideHud(view: self.view)
            
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    let response = ModelMyWallet.init(fromDictionary: response as! [String : Any])
                    // self.mtWalletdetails = response.details
                    self.lblTotalAmount.text = "$ " + response.walletAmount
                    self.tblMyWallet.isHidden = false
                    self.tblMyWallet.reloadData()
                    if response.details.count == 0 {
                        self.isTotalCountReached = true
                    }
                    if self.pageNumber == 1{
                        self.mtWalletdetails = response.details
                    }else{
                        self.mtWalletdetails += response.details
                    }
                    // self.lblTotalAmount.text = "$ " + response.walletAmount
                    if self.mtWalletdetails.count == 0
                    {
                        self.isTotalCountReached = true
                        // self.view.isHidden = false
                        self.tblMyWallet.isHidden = true
                    }else{
                        if self.mtWalletdetails.count % 10 != 0
                        {
                            self.isTotalCountReached = true
                        }
                        self.pageNumber = self.pageNumber + 1
                        //self.viewNoDataFound.isHidden = true
                        self.tblMyWallet.isHidden = false
                        self.tblMyWallet.reloadData()
                    }
                }else if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}else{
                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
            
        }
    }
    
    @IBAction func actionOnBack(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionOnAddmoney(_ sender: UIButton) {
       let details = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNAddMoneyVC") as! MNAddMoneyVC
        self.navigationController?.pushViewController(details, animated: true)
    
    }
    
    @IBAction func actionOnwithdrawmoney(_ sender: UIButton) {
        let details = storyBoard.Individual.instantiateViewController(withIdentifier: "MNIndividualWithdrawMoneyVC") as! MNIndividualWithdrawMoneyVC
        self.navigationController?.pushViewController(details, animated: true)
    }
    
}
// MARK: - extension
extension MNMyWalletVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    if self.isTotalCountReached {
        return self.mtWalletdetails.count
    } else {
        return self.mtWalletdetails.count + 1
    }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.mtWalletdetails.count{
            
            let cell : UITableViewCell = self.tblMyWallet.dequeueReusableCell(withIdentifier: "LoadingCell")!
            let activityIndicator : UIActivityIndicatorView = (cell.contentView.viewWithTag(100) as? UIActivityIndicatorView)!
                      activityIndicator.startAnimating()
            return cell
            
        }
        else{
        
        var cell : MyWalletTableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "MyWalletTableViewCell", for: indexPath) as? MyWalletTableViewCell
       //  cell?.imgMyWallet.sd_setImage(with: URL(string:img_BASE_URL + self.mtWalletdetails[indexPath.row].freelancerProfilePic), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
        cell?.imgMyWallet.image = UIImage.init(named: "ic_add_money")
        if self.mtWalletdetails[indexPath.row].amountType == "Reduce" {
            cell?.lblBudget.text = "- $ " + self.mtWalletdetails[indexPath.row].amount
            cell?.lblBudget.textColor = UIColor.hexStringToUIColor(hex: "#E30100")
        }else{
            cell?.lblBudget.text = "+ $ " + self.mtWalletdetails[indexPath.row].amount
            cell?.lblBudget.textColor = UIColor.hexStringToUIColor(hex: "#30A057")
        }
        cell?.lblTitle.text = self.mtWalletdetails[indexPath.row].jobTitle
        cell?.lblMessage.text = self.mtWalletdetails[indexPath.row].message
        
        let createdDate = self.convertDateFormaterForAll(self.mtWalletdetails[indexPath.row].created)
        print(createdDate)
        let startDate = createdDate[0]
        let startTime = createdDate[1]
        cell?.lblDate.text = startDate
        cell?.lblTime.text = startTime
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let details = self.storyboard?.instantiateViewController(withIdentifier: "MNPostDetailVC") as! MNPostDetailVC
//         self.navigationController?.pushViewController(details, animated: true)
    }
    func convertDateFormaterForAll(_ strdate: String) -> [String]
    {
        if strdate != "0000-00-00 00:00:00"{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: strdate)
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let strDate = dateFormatter.string(from: date!)
            dateFormatter.dateFormat = "hh:mm a"
            let strTime = dateFormatter.string(from: date!)
            return [strDate,strTime]
        }else{
            return ["Feb 26, 2024","12:04 AM"]
        }
    }
}

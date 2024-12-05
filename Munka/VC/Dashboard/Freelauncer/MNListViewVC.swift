//
//  MNListViewVC.swift
//  Munka
//
//  Created by Amit on 30/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNListViewVC: UIViewController {
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var viewNojob:UIView!
     @IBOutlet weak var viewInternetConnection:UIView!
   
    @IBOutlet weak var txtSearch: UITextField!
    
    var userType = ""
    
    var listdetails = [ModelListViewDetail]()
    var pageNumber: Int = 1
    var isTotalCountReached : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtSearch.delegate = self
       self.tblView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
        tblView.isHidden = true
        viewInternetConnection.isHidden = true
//        tblView.rowHeight = UITableView.automaticDimension
//        tblView.estimatedRowHeight = 122
        userType =  MyDefaults().swiftUserData["user_type"] as! String
        print(userType)
//        if  isConnectedToInternet() {
//            viewInternetConnection.isHidden = false
//                self.callServiceForListViewAPI()
//            } else {
//                self.showErrorPopup(message: internetConnetionError, title: alert)
//        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
      //  listdetails = [ModelListViewDetail]()
        txtSearch.resignFirstResponder()
        if  isConnectedToInternet() {
                 self.pageNumber = 1
                 self.isTotalCountReached = false
                self.callServiceForListViewAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    
    func callServiceForListViewAPI() {
        // ShowHud()
        ShowHud(view: self.view)
        print(MyDefaults().UserId)
        
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                        "list_type":"New",
                                        "user_type":userType,
                                        "page":pageNumber,
                                        "limit":""]
        debugPrint(parameter)
        listdetails.removeAll()
        HTTPService.callForPostApi(url:MNPIndividualHomeAPI , parameter: parameter) { (response) in
            debugPrint(response)
            
            // HideHud()
            HideHud(view: self.view)
            self.isApiCalled = false
            if response.count != nil{
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    let response = ModelListView.init(fromDictionary: response as! [String : Any])
                    MyDefaults().maplist = response.details
                    if response.details.count == 0 {
                        self.isTotalCountReached = true
                    }
                    self.listdetails += response.details
                    if self.listdetails.count == 0
                    {
                        self.isTotalCountReached = true
                        self.viewNojob.isHidden = false
                        self.tblView.isHidden = true
                    }else{
                        if self.listdetails.count % 10 != 0
                        {
                            self.isTotalCountReached = true
                        }
                        self.pageNumber = self.pageNumber + 1
                        self.viewNojob.isHidden = true
                        self.tblView.isHidden = false
                        self.tblView.reloadData()
                    }
                } else  if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    if self.listdetails.count == 0
                    {
                        self.viewNojob.isHidden = false
                        self.tblView.isHidden = true
                    }
                    
                }
                self.isTotalCountReached = true
                self.tblView.reloadData()
                // self.showErrorPopup(message: message, title: alert)
            }else{
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
    
    func callServiceForSearchListViewAPI() {
        
        
        // ShowHud()
        ShowHud(view: self.view)
        print(MyDefaults().UserId)
        
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                        "searchKeyword": "\(txtSearch.text!)",//"All",
                                        "user_type":userType,
                                        "page":pageNumber,
                                        "limit":""]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNPIndividualSearchApiHomeAPI , parameter: parameter) { (response) in
            debugPrint(response)
            
            // HideHud()
            HideHud(view: self.view)
            self.isApiCalled = false
            self.listdetails.removeAll()
            if response.count != nil{
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    let response = ModelListView.init(fromDictionary: response as! [String : Any])
                    MyDefaults().maplist = response.details
                    if response.details.count == 0 {
                        self.isTotalCountReached = true
                    }
                    self.listdetails += response.details
                    if self.listdetails.count == 0
                    {
                        self.isTotalCountReached = true
                        self.viewNojob.isHidden = false
                        self.tblView.isHidden = true
                    }else{
                        if self.listdetails.count % 10 != 0
                        {
                            self.isTotalCountReached = true
                        }
                        self.pageNumber = self.pageNumber + 1
                        self.viewNojob.isHidden = true
                        self.tblView.isHidden = false
                        DispatchQueue.main.async {
                            self.tblView.reloadData()
                        }
                    }
                } else  if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    if self.listdetails.count == 0
                    {
                        self.viewNojob.isHidden = false
                        self.tblView.isHidden = true
                    }
                    
                }
                self.isTotalCountReached = true
                self.tblView.reloadData()
                // self.showErrorPopup(message: message, title: alert)
            }else{
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
    // MARK: - UIScrollView Delegate and DataSource
    
    var isApiCalled: Bool = false

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let endScrolling: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height + 1
        if endScrolling >= scrollView.contentSize.height && !self.isTotalCountReached
        {
            if !self.isApiCalled {
                self.isApiCalled = true
                self.callServiceForListViewAPI()
            }
        }
    }
    
    
}

extension MNListViewVC : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        print("TextEdit:\(textField.text!) ")

        if  isConnectedToInternet() {
            self.pageNumber = 1
            self.isTotalCountReached = false
            if txtSearch.text! != ""{
                callServiceForSearchListViewAPI()
            }
        } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if  isConnectedToInternet() {
            self.pageNumber = 1
            self.isTotalCountReached = false
            self.callServiceForListViewAPI()
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        
        return  true
    }
    
}
// MARK: - extension
extension MNListViewVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == self.contractlist.count
//        {
//            return 44
//        }
//        else{
//            return 148
//        }
//        
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return listdetails.count
        if self.isTotalCountReached {
            return self.listdetails.count
        } else {
            return self.listdetails.count + 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           if indexPath.row == self.listdetails.count {
               let cell : UITableViewCell = self.tblView.dequeueReusableCell(withIdentifier: "LoadingCell")!
               let activityIndicator : UIActivityIndicatorView = (cell.contentView.viewWithTag(100) as? UIActivityIndicatorView)!
               activityIndicator.startAnimating()
               return cell
           }else{
        
            var cell : ListviewTableViewCell!
            cell = tableView.dequeueReusableCell(withIdentifier: "ListviewTableViewCell", for: indexPath) as? ListviewTableViewCell
            if  self.listdetails[indexPath.row].jobType == "Fixed" {
                cell?.lblFix.text = "Fixed - " + "$" +  self.listdetails[indexPath.row].budgetAmount 
                cell?.lblHour.text = self.listdetails[indexPath.row].timeDuration + " " + "Days"
            }else{
                cell?.lblFix.text = "Hourly - " + self.listdetails[indexPath.row].budgetAmount  + "/hr."
                cell?.lblHour.text = self.listdetails[indexPath.row].timeDuration + " " + "hr."
            }
        if self.listdetails[indexPath.row].isPrivate == "1" {
             cell?.lblAddress.text = ""
            cell?.lblMiles.text = ""
            cell?.milesDecimal.isHidden = true
        }else{
             cell?.lblAddress.text = self.listdetails[indexPath.row].jobLocation
            let doubleMiles = Double(self.listdetails[indexPath.row].distance) ?? 0
            let get = String(format: "%.2f", doubleMiles)
            cell.lblMiles.text = get + " Miles"
            cell?.milesDecimal.isHidden = false
        }
            let startDate =  Global.convertDateFormat(self.listdetails[indexPath.row].jobStartDate, sourceFormate: "yyyy-MM-dd", targetFormate: "MMM dd, yyyy")
           
            
           // let startDate = self.convertDateFormater(self.listdetails[indexPath.row].jobStartDate)
            let startTime = self.convertTimeFormater(self.listdetails[indexPath.row].jobStartTime)
            cell?.lblStartDate.text = startDate + "  " + startTime
            
           //let EndDateDate = self.convertDateFormater(self.listdetails[indexPath.row].jobEndDate)
           let EndDateDate =  Global.convertDateFormat(self.listdetails[indexPath.row].jobEndDate, sourceFormate: "yyyy-MM-dd", targetFormate: "MMM dd, yyyy")
            
            
            let endTime = self.convertTimeFormater(self.listdetails[indexPath.row].jobEndTime)
              cell?.lblEndDate.text = EndDateDate + "  " + endTime
            cell?.lblTitle.text = self.listdetails[indexPath.row].jobTitle
           
            let createdDate = self.convertDateFormaterForAll(self.listdetails[indexPath.row].created)
           // let createdDate = self.convertDateFormaterForAll(self.listdetails[indexPath.row].created)
            let date = createdDate[0]
            let time = createdDate[1]
            
            cell?.lblPostedDate.text = "Posted " + date
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNPostDetailFreelauncerVC") as! MNPostDetailFreelauncerVC
        details.strJobId = self.listdetails[indexPath.row].id
        self.navigationController?.pushViewController(details, animated: true)
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    
//    func convertDateFormater(_ strdate: String) -> String
//    {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let date = dateFormatter.date(from: strdate)
//        dateFormatter.dateFormat = "MMM dd, yyyy"
//        return  dateFormatter.string(from: date!)
//    }
    func convertTimeFormater(_ dateAsString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "hh:mm a"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
    }
    
    
    func convertDateFormaterForAll(_ strdate: String) -> [String]
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let strDate = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "hh:mm a"
        let strTime = dateFormatter.string(from: date!)
        return [strDate,strTime]
    }
}


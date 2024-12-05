//
//  SavedjobInfodetailVC.swift
//  Munka
//
//  Created by Amit on 04/01/20.
//  Copyright © 2020 Amit. All rights reserved.
//

import UIKit
class SavedjobInfodetailVC: UIViewController {
    @IBOutlet weak var txtJobId : UITextField!
    @IBOutlet weak var txtCategoryName : UITextField!
    @IBOutlet weak var txtFixedPrice : UITextField!
    @IBOutlet weak var txtview : UITextView!
    @IBOutlet weak var txtStartDate : UITextField!
    @IBOutlet weak var txtEndDate : UITextField!
    @IBOutlet weak var txtEndTime : UITextField!
    @IBOutlet weak var txtStartTime : UITextField!
    
    @IBOutlet weak var btnHourly : UIButton!
     @IBOutlet weak var btnurgetFill : UIButton!
     @IBOutlet weak var btnIsPrivateLocation : UIButton!
    @IBOutlet weak var btnFixed : UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var hourlyJobTime = [ModelHourlyJobTime]()
       var isHourlyAvailableDate : Bool = false
       var arrayForSection =  [[String:Any]]()
       var isCheckDataContent : Bool = false
    @IBOutlet weak var tblView: UITableView!
    
    var details : ModelJobDetail!
    var jobId  = ""
    var applyid  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
        txtStartDate.inputView = datePicker
        txtEndDate.inputView = datePicker
        txtStartTime.inputView = datePicker
        txtEndTime.inputView = datePicker
               
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: +1, to: Date())
              
//        self.btnFixed.isEnabled = false
//        self.btnHourly.isEnabled = false
        self.txtview.isEditable = false
        self.txtEndDate.isEnabled = false
        self.txtStartDate.isEnabled = false
        self.txtEndTime.isEnabled = false
        self.txtStartTime.isEnabled = false
        self.txtFixedPrice.isEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        if  isConnectedToInternet() {
            self.callServiceForContractAPI()
            } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    @IBAction func actionOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
     @IBAction func actionOnHouly(_ sender: Any) {
        if btnHourly.isSelected {
            self.btnHourly.isSelected = false
            self.btnFixed.isSelected = false
            self.btnHourly.isSelected = true
            }else {
            self.btnHourly.isSelected = true
            self.btnFixed.isSelected = false
                
          }
    }
    @IBAction func actionOnFixed(_ sender: Any) {
        if btnFixed.isSelected {
              self.btnFixed.isSelected = false
              self.btnHourly.isSelected = false
              self.btnFixed.isSelected = true
            }else {
              self.btnFixed.isSelected = true
              self.btnHourly.isSelected = false
                
          }
    }
    @IBAction func actionOnSendContract(_ sender: Any) {
        if !isPostJobValidation() {
                   if  isConnectedToInternet() {
                        self.callPostContractAPI()
                       
                       } else {
                       self.showErrorPopup(message: internetConnetionError, title: alert)
                   }
               }
    }
//    @IBAction func actionOnDate(_ sender: Any) {
//
//    }
    func callServiceForContractAPI() {
      hourlyJobTime = [ModelHourlyJobTime]()

       // ShowHud()
ShowHud(view: self.view)
        print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["job_id":jobId,
                                        "user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken ?? ""]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNJobDetailAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
            HideHud(view: self.view)

            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelJobDetails.init(fromDictionary: response as! [String : Any])
                self.details = response.details
                if response.details.hourlyJobTime.count > 0 {
                    self.hourlyJobTime   = response.details.hourlyJobTime
                    self.isHourlyAvailableDate = true
                    var dictionary =  [String:Any]()
                    dictionary["status"] = "data"
                    self.arrayForSection.append(dictionary)
                    var dictionary1 =  [String:Any]()
                    dictionary1["viewdetails"] = "data"
                    self.arrayForSection.append(dictionary1)
                }
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
                self.setUI()
            } else if status == "4"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)
             }
             else
             {
//                self.viewNoDataFound.isHidden = false
//                self.view.bringSubviewToFront(self.viewNoDataFound)
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }}else
                     {
        //                self.viewNoDataFound.isHidden = false
        //                self.view.bringSubviewToFront(self.viewNoDataFound)
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                     }
            
         }
    }
    func setUI(){
        txtJobId.text = self.details.jobTitle
        txtCategoryName.text = self.details.serviceCategory
        txtFixedPrice.text = "$ " + self.details.budgetAmount
        txtview.text = self.details.jobDescription
        txtStartDate.text =  self.convertDateFormater(self.details.jobStartDate!)
        txtEndDate.text = self.convertDateFormater(self.details.jobEndDate!)
        txtEndTime.text = self.convertTimeFormater(self.details.jobEndTime!)
        txtStartTime.text = self.convertTimeFormater(self.details.jobStartTime!)
        if self.details.jobType == "Fixed" {
            self.btnFixed.isSelected = true
        }else{
            self.btnHourly.isSelected = true
        }
       // self.btnFixed.isUserInteractionEnabled = false
       // self.btnHourly.isUserInteractionEnabled = false
        self.txtview.isEditable = false
        self.txtEndDate.isEnabled = false
        self.txtStartDate.isEnabled = false
        self.txtEndTime.isEnabled = false
        self.txtStartTime.isEnabled = false
        self.txtFixedPrice.isEnabled = false
        if self.details.urgentFill == "1" {
            self.btnurgetFill.isSelected = true
        }else{
           self.btnurgetFill.isSelected = false
        }
        if self.details.isPrivate == "1" {
            self.btnIsPrivateLocation.isSelected = true
        }else{
            self.btnIsPrivateLocation.isSelected = false
        }
    }
    func callPostContractAPI() {
          var arrayD = [String]()
          var arraySTime = [String]()
          var arrayETime = [String]()
            for items in self.hourlyJobTime {
            arrayD.append(items.date)
            arraySTime.append(items.startTime)
            arrayETime.append(items.endTime)
        
        }
            
        

//        ShowHud()
ShowHud(view: self.view)
            print(MyDefaults().UserId ?? "")
            let parameter: [String: Any] = ["id":jobId,
                                            "user_id":MyDefaults().UserId ?? "",
                                            "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                "applied_by":applyid,
                "job_title":self.details.jobTitle ?? "",
                "job_description":txtview.text ?? "",
                "job_type":self.details.jobType ?? "",
                "service_catagory":self.details.serviceCatagory ?? "",
                "job_location":self.details.jobLocation ?? "",
                "latitude":self.details.latitude ?? "",
                "longitude":self.details.longitude ?? "",
                "job_start_date":self.convertMMMDDYYYYTOYYYYMMDD(txtStartDate.text!),
                "job_end_date":self.convertMMMDDYYYYTOYYYYMMDD(txtEndDate.text!),
                "job_start_time":txtStartTime.text!,
                "job_end_time":txtEndTime.text!,
                "budget_amount":txtEndTime.text!,
                "is_professional":self.details.isProfessional ?? "",
                "is_publish":"1",
                "is_private":self.details.isPrivate ?? "",
                "urgent_fill":self.details.urgentFill ?? "",
                "hourly_date":arrayD,
                "hourly_start_time":arraySTime,
                "hourly_end_time":arrayETime,
                "state":self.details.state ?? ""]
             debugPrint(parameter)
             HTTPService.callForPostApi(url:MNGetEditJobAPI , parameter: parameter) { (response) in
                 debugPrint(response)

            //  HideHud()
HideHud(view: self.view)
                if response.count != nil {
                let status = response["status"] as! String
                 let message = response["msg"] as! String
                 if status == "1"
                 {
//                    let response = ModelJobDetails.init(fromDictionary: response as! [String : Any])
//                    self.details = response.details
//                    self.setUI()
                    self.navigationController?.popViewController(animated: true)
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
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
    func isPostJobValidation() -> Bool {
        
        guard let budget = txtFixedPrice.text , budget != ""
               else {showAlert(title: ALERTMESSAGE, message: "Please enter price.")
                   return true}
        guard let desc = txtview.text , desc != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter job description...")
            return true}
        
       guard let startDate = txtStartDate.text , startDate != ""
              else {showAlert(title: ALERTMESSAGE, message: "Please enter start date.")
                  return true}
       
        guard let endDate = txtEndDate.text , endDate != ""
               else {showAlert(title: ALERTMESSAGE, message: "Please enter end date.")
                   return true}
        guard let startTime = txtStartTime.text , startTime != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter start time.")
            return true}
        guard let endTime = txtEndTime.text , endTime != ""
               else {showAlert(title: ALERTMESSAGE, message: "Please enter end time.")
                   return true}
        return false
    }
    func convertDateFormater(_ strdate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
    func convertDateFormaterFoeOnlyDate(_ strdate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
    func convertTimeFormater(_ dateAsString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "hh:mm a"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
    }
}
extension SavedjobInfodetailVC:UITextViewDelegate,UITextFieldDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.hexStringToUIColor(hex: "B1B1B1") {
            textView.text = nil
            textView.textColor = UIColor.hexStringToUIColor(hex: "7E8290")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Job Description…"
            textView.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 150
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtStartDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            txtStartDate.text = formatter.string(from: datePicker.date)
        }
        else if textField == txtEndDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            txtEndDate.text = formatter.string(from: datePicker.date)
        }
        else if textField == txtStartTime {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            txtStartTime.text = formatter.string(from: datePicker.date)
            print(txtStartTime.text!)
        }
        else if textField == txtEndTime {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            txtEndTime.text = formatter.string(from: datePicker.date)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtStartDate {
            datePicker.datePickerMode = UIDatePicker.Mode.date
        }else if textField == txtEndDate {
            datePicker.datePickerMode = UIDatePicker.Mode.date
        }else if textField == txtStartTime {
            datePicker.datePickerMode = UIDatePicker.Mode.time}
        else if textField == txtEndTime {
            datePicker.datePickerMode = UIDatePicker.Mode.time}
    }
}
    

extension SavedjobInfodetailVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayForSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.objIndividual.count
       if section == 0 {
            return 1
        }
       else {
        if self.isHourlyAvailableDate == true{
             return hourlyJobTime.count
        }else{
         return 0
         }
    }
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 41.5
        } else
        {
            return 44
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            if indexPath.section == 0 {
                let cell  = tableView.dequeueReusableCell(withIdentifier: "StartTableViewCell", for: indexPath) as? StartTableViewCell
            return cell!
            }  else {
            var cell : ContractHourTableViewCell?
             cell = tableView.dequeueReusableCell(withIdentifier: "ContractHourTableViewCell", for: indexPath) as? ContractHourTableViewCell
             let start = self.convertDateFormater(hourlyJobTime[indexPath.row].date) + " " + hourlyJobTime[indexPath.row].startTime + " "
            // cell?.lblDates.text   = dict["dates"] as? String
                let startfullDate = self.convertDateFormater(hourlyJobTime[indexPath.row].date)
            let end = self.convertDateFormater(hourlyJobTime[indexPath.row].date) + " " + hourlyJobTime[indexPath.row].endTime + " "
             let startDate = self.convertMMMDDYYYYTOYYYYMMDDWithTime(start)
             let endDate = self.convertMMMDDYYYYTOYYYYMMDDWithTime(end)
             let sDate = self.convertDateFormater24format(startDate)
             let eDate = self.convertDateFormater24format(endDate)
             cell?.lblDate.text = startfullDate
             cell?.lblStartTime.text = sDate[1]
             cell?.lblEndTime.text = eDate[1]
                 return cell!
        }
    }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       /*    if isHourlyAvailableDate == true {
                isHourlyAvailableDate = false
           }else{
                isHourlyAvailableDate = true
           }
           tblView.reloadData() */
       }
    func GetAmOrPM(strTime:String) -> String {
       // let dateAsString = "6:35 PM"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
         let date = dateFormatter.date(from: strTime)
        let dateString = dateFormatter.string(from: date!)
        return dateString
    }
    
}

//
//  EditJobVC.swift
//  Munka
//
//  Created by Amit on 22/05/20.
//  Copyright © 2020 Amit. All rights reserved.
//



import UIKit
import GooglePlaces
class EditJobVC: UIViewController {
 
    
    @IBOutlet weak var lblNote: UILabel!
    
    @IBOutlet weak var btnProfessional: UIButton!
    @IBOutlet weak var btnboth: UIButton!
    @IBOutlet weak var btnFreelancer: UIButton!
    @IBOutlet weak var btnHourly: UIButton!
    @IBOutlet weak var btnFixed: UIButton!
    @IBOutlet weak var btnUrgentFill: UIButton!
    @IBOutlet weak var btnIsPrivateLocation: UIButton!
    
    @IBOutlet weak var txtJoTitle: UITextField!
    @IBOutlet weak var txtSelectCategory: UITextField!
    @IBOutlet weak var txtViewJobDescriptions: UITextView!
    //@IBOutlet weak var txtJobLocation: UITextField!
    
    @IBOutlet weak var lblJobLocation: UILabel!
    @IBOutlet weak var txtFixedPrice: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tbleView: UITableView!
    var arraySetId = [String]()
    //// Mark : Only Start date, End Date, Start Time,End Time
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    var name = ""
   // var strCategoryId = ""
    
    
    @IBOutlet weak var btnStartTime: UIButton!
    @IBOutlet weak var btnEndTime: UIButton!
    
    private var startTime:String = ""
    private var endTime:String = ""
    private var startDate:String = "2020-01-26 18:30:00 +0000"
    private var endDate:String = "2020-01-27 18:30:00 +0000"
    
    
    private var startDateWithTime = Date()
    private var endDateWithTime = Date()
    
    var stateId = ""
    var isFixedSelected = false
    var isPaymentThrough = false
    var isPaymentType = false
    var isStartDate  = false
    var isResetData  = false
  
    var isProfessional = ""
    var isLocationPrivate = ""
    var isUrgentFill = ""
    var serviceCategory = ""
    var jobType = ""
    var strLatitude = ""
    var strLongitude = ""
    var startDate1 = Date()
    var endDate1 = Date()
    var stratTime = Date()
    var arrayDates = [[String:Any]]()
    //var arrayEditJob = [[String:Any]]()
    var jobId = ""
    var checkStartDate = ""
    var checkEndTime = ""
    var timeDatePicker = UIDatePicker()
   // var objIndividual = [ModelIndividualDetail]()
    var hourlyJobTime = [ModelHourlyEditJobTime]()
    
    var details : ModelEditJobDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        btnProfessional.isSelected = true
        // Do any additional setup after loading the view.
        txtViewJobDescriptions.text = "Job Description…"
        txtViewJobDescriptions.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
        txtStartDate.inputView = datePicker
        txtEndDate.inputView = datePicker
        txtStartTime.inputView = datePicker
        txtEndTime.inputView = datePicker
        self.navigationItem.title = "Edit Job"
        self.txtViewJobDescriptions.delegate = self
        self.setEdutJobUI()
    }
    
    func setEdutJobUI()  {
        if  isConnectedToInternet() {
            self.callServiceForJobFrelauncerDetailsAPI()
            } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    
    func callServiceForJobFrelauncerDetailsAPI() {

       // ShowHud()
        ShowHud(view: self.view)

       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "job_id":jobId]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNPJobDetailsAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()
            HideHud(view: self.view)

            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelEditJob.init(fromDictionary: response as! [String : Any])
                self.details = response.details
                self.hourlyJobTime = response.details.hourlyJobTime
                 
                 if self.hourlyJobTime.count > 0{
                     let obj = self.hourlyJobTime[0]
                     print("job : \(obj)")
                     var dict = [String:Any]()
                     for each in self.hourlyJobTime{
                         dict["startTime"] = each.startTime
                         dict["endTime"] = each.endTime
                         dict["dates"] = each.date
                         dict["fullformat"] = ""
                         self.arrayDates.append(dict)
                     }
                 }
                self.setupUI()
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
    
    func setupUI()  {
        txtSelectCategory.delegate = self
        txtJoTitle.isUserInteractionEnabled = true
        isFixedSelected = true
        
        print("serviceCatagory: \(self.details.serviceCatagory!)")
        if self.details.isProfessional == "1" {
            self.btnProfessional.isSelected = true
            self.btnFreelancer.isSelected = false
            self.btnboth.isSelected = false
            self.isProfessional = "1"
            
        } else if self.details.isProfessional == "2" {
            
            self.btnProfessional.isSelected = false
            self.btnFreelancer.isSelected = true
            self.btnboth.isSelected = false
            self.isProfessional = "2"
        
        } else if self.details.isProfessional == "3" {
            self.btnProfessional.isSelected = false
            self.btnFreelancer.isSelected = false
            self.btnboth.isSelected = true
            self.isProfessional = "3"
        }
   
        self.txtJoTitle.text = self.details.jobTitle
        self.txtSelectCategory.text = self.details.serviceCategory
        
        if self.details.jobType == "Hourly" {
            self.btnHourly.isSelected = true
            self.btnFixed.isSelected = false
            self.isPaymentThrough = false
            self.jobType = "Hourly"
            
        } else{
            self.btnHourly.isSelected = false
            self.btnFixed.isSelected = true
            self.isPaymentThrough = true
            self.jobType = "Fixed"
        }
        self.txtState.text = self.details.stateName
        self.lblJobLocation.text = self.details.jobLocation
        self.txtFixedPrice.text = self.details.budgetAmount
    
        self.txtStartDate.text = self.convertDateFormater1(self.details.jobStartDate) //
        self.txtEndDate.text = self.convertDateFormater1(self.details.jobEndDate)
        isStartDate = true
        self.txtStartTime.text = self.details.jobStartTime.self.convertTimeFormater1(self.details.jobStartTime) //
        
        self.txtEndTime.text = self.details.jobEndTime.self.convertTimeFormater1(self.details.jobEndTime)
       
        startTime = txtStartTime.text!
        endTime = txtEndTime.text!

        startDate = txtStartDate.text!
        endDate = txtEndDate.text!
        print("startTime: \(startTime), endTime: \(endTime)")
        print("StartDate :\(startDate), EndDate: \(endDate)")
        
        if self.details.urgentFill == "1" {
            self.btnUrgentFill.isSelected = true
            self.isUrgentFill = "1"
        
        } else{
            self.btnUrgentFill.isSelected = false
            self.isUrgentFill = "0"
        
        }
        if self.details.isPrivate == "1" {
            self.btnIsPrivateLocation.isSelected = true
            self.isLocationPrivate = "1"
        
        } else{
            self.btnIsPrivateLocation.isSelected = false
            self.isLocationPrivate = "0"
        
        }
        if self.details.jobDescription.isEmpty {
            print("Nothing to see here")
            self.txtViewJobDescriptions.text = self.details.jobDescription
            
        }else{
            self.txtViewJobDescriptions.text = self.details.jobDescription
            self.txtViewJobDescriptions.textColor = .black
        }
        self.strLatitude = self.details.latitude
        self.strLongitude = self.details.longitude
        self.stateId = self.details.state
        self.serviceCategory = self.details.serviceCatagory
        print("self.serviceCategory: \(self.serviceCategory)")
        self.tbleView.delegate = self
        self.tbleView.dataSource = self
        self.tbleView.reloadData()
    }
    
    @IBAction func btnJobTypeTap(_ sender: UIButton) {
        
        if sender == btnProfessional{
            btnProfessional.isSelected = true
            btnFreelancer.isSelected = false
            btnboth.isSelected = false
            self.isProfessional = "1"

        }else if sender == btnFreelancer{
            btnProfessional.isSelected = false
            btnFreelancer.isSelected = true
            btnboth.isSelected = false
            self.isProfessional = "2"

        }else if sender == btnboth{
            btnProfessional.isSelected = false
            btnFreelancer.isSelected = false
            btnboth.isSelected = true
            self.isProfessional = "3"
        }
    }
    


    @IBAction func btnpaymentOtionTap(_ sender: UIButton) {
        
        if sender == btnHourly{
            btnHourly.isSelected = true
            btnFixed.isSelected = false
            self.isPaymentThrough = false
            self.jobType = "Hourly"
        }else {
            btnHourly.isSelected = false
            btnFixed.isSelected = true
            self.isPaymentThrough = true
            self.jobType = "Fixed"
        }
    }
    
    @IBAction func actionOnPostJobs(_ sender: UIButton) {
        if !isPostJobValidation() {
            if  isConnectedToInternet() {
                if ((self.txtFixedPrice.text! == "0") || (self.txtFixedPrice.text! == "0.00") || (self.txtFixedPrice.text! == "00") || (self.txtFixedPrice.text! == ".0") || (self.txtFixedPrice.text! == ".00") || (self.txtFixedPrice.text! == "0.0") || (self.txtFixedPrice.text! == ".")) {
                    self.showErrorPopup(message: "Please enter valid amount.", title: alert)
                    }else{
                        self.callPostJobAPI()
                   }
                
                } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    
    func callPostJobAPI() {
       
        //print(arrayD)
        //     print(arraySTime)
        //                print(arrayETime)
        let parameter: [String: Any]
        if !isPaymentThrough {
            var arrayD = [String]()
            var arraySTime = [String]()
            var arrayETime = [String]()
            for items in self.hourlyJobTime {
                //let dict = items
                let dates = items.date!
                let start = items.startTime!
                let end = items.endTime!
                arrayD.append(dates)
                arraySTime.append(start)
                arrayETime.append(end)
//                print(arrayD)
//                print(arraySTime)
//                print(arrayETime)
                
            }

           // ShowHud()
            ShowHud(view: self.view)
            parameter = ["user_id":MyDefaults().UserId ?? "",
                         "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                         "job_title":self.txtJoTitle.text!,
                         "job_description":self.txtViewJobDescriptions.text!,
                         "job_type":jobType,
                         "service_catagory":serviceCategory,
                         "job_location":self.lblJobLocation.text!,
                         "latitude":strLatitude,
                         "longitude":strLongitude,
                         "job_start_date":self.details.jobStartDate!,
                         "job_end_date":self.details.jobEndDate!,
                         "job_start_time":self.txtStartTime.text!,
                         "job_end_time":self.txtEndTime.text!,
                         "budget_amount":self.txtFixedPrice.text!,
                         "is_professional":isProfessional,
                         "is_publish":"1",
                         "urgent_fill":isUrgentFill,
                         "hourly_date":arrayD,
                         "hourly_start_time":arraySTime,
                         "hourly_end_time":arrayETime,
                         "is_private" : isLocationPrivate,
                         "state":self.stateId,
                         "id":self.details.id ?? ""
            ]
               
        }else{

            //ShowHud()
                parameter = ["user_id":MyDefaults().UserId ?? "",
               "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
               "job_title":self.txtJoTitle.text!,
               "job_description":self.txtViewJobDescriptions.text!,
               "job_type":jobType,
               "service_catagory":serviceCategory,
               "job_location":self.lblJobLocation.text!,
               "latitude":strLatitude,
               "longitude":strLongitude,
               "job_start_date":self.details.jobStartDate!,
               "job_end_date":self.details.jobEndDate!,
               "job_start_time":self.txtStartTime.text!,
               "job_end_time":self.txtEndTime.text!,
               "budget_amount":self.txtFixedPrice.text!,
               "is_professional":isProfessional,
               "is_publish":"1",
               "urgent_fill":isUrgentFill,
               "is_private" : isLocationPrivate,
               "state":self.stateId,
               "id":self.details.id ?? ""
            ]
        }
        
        debugPrint(parameter)
         HTTPService.callForPostApi(url:MNGetEditJobAPI , parameter: parameter) { (response) in
             debugPrint(response)
            print(response)

        //  HideHud()
            HideHud(view: self.view)
            if response.count != nil
            {
                let status = response["status"] as! String
           if status == "1"
             {
                let message = response["msg"] as! String
                self.navigationController?.popViewController(animated: true)
                //self.showAlert(title: ALERTMESSAGE, message: message)
                self.alertViewForBacktoController(title: ALERTMESSAGE, message: message)
           } else if status == "4"
            {
                let message = response["msg"] as! String
                self.autoLogout(title: ALERTMESSAGE, message: message)
           }
             else
             {
                let message = response["msg"] as! String
                 self.showErrorPopup(message: message, title: ALERTMESSAGE)
             }
              
        }  else{
            self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
        
            }
        }
    }
    
   
    @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionOnJobLocation(_ sender: UIButton) {
        let placePickerController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
              filter.type = .noFilter  //suitable filter type
//              filter.country = "USA"  //appropriate country code
              placePickerController.autocompleteFilter = filter
        let searchBarTextAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white, NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
                       placePickerController.delegate = self
                       present(placePickerController, animated: true, completion: nil)
                       self.popupAlert(title: "Title", message: " Oops, xxxx ", actionTitles: ["Option1","Option2","Option3"], actions:[{action1 in
               
                           },{action2 in
               
                           }, nil])
    }
    
    @IBAction func actionOnState(_ sender: UIButton) {
        let CountryVC = storyBoard.Main.instantiateViewController(withIdentifier: "MNCountryListVC") as! MNCountryListVC
        CountryVC.isCountryList = false
        CountryVC.isTown = false
        CountryVC.CountryId = "231"
        CountryVC.delagate = self
       // txtTown.text = ""
        self.navigationController?.pushViewController(CountryVC, animated: true)
        
    }
//    func delegatePostJob(array:[[String:Any]]){
//        let dict = array[0]
//        self.txtSelectCategory.text = dict["name"] as? String
//        serviceCategory = dict["id"] as! String
//        self.txtViewJobDescriptions.becomeFirstResponder()
//
//    }
   
    func isPostJobValidation() -> Bool {
        guard let jobTitle = txtJoTitle.text , jobTitle != ""
            else {showAlert(title: ALERTMESSAGE, message: "Please enter job title.")
                return true}
        guard let selectCategory = txtJoTitle.text , selectCategory != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter category.")
            return true}
        guard let jobDescriptions = txtViewJobDescriptions.text , jobDescriptions != ""
               else {showAlert(title: ALERTMESSAGE, message: "Please enter job description.")
                   return true}
        guard let state = txtState.text , state != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter state.")
            return true}
        guard let jobLocation = lblJobLocation.text , jobLocation != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter job location.")
            return true}
         
       guard let enterFixedPrice = txtFixedPrice.text , enterFixedPrice != ""
              else {showAlert(title: ALERTMESSAGE, message: "Please enter price.")
                  return true}
        guard let startDate = txtStartDate.text , startDate != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter date.")
            return true}
        guard let endDate = txtEndDate.text , endDate != ""
               else {showAlert(title:ALERTMESSAGE, message: "Please enter date.")
                   return true}
        guard let startTime = txtStartTime.text , startTime != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter time.")
            return true}
        guard let endTime = txtEndTime.text , endTime != ""
               else {showAlert(title: ALERTMESSAGE, message: "Please enter time.")
                   return true}
        return false
    }
}

extension EditJobVC: GetCallDelegateOfTextField, GetSelectCategory,GetCountrylist{
    
    func delegateSelectedWorkingDay(array: [String]) {
        print("Select Working Day")
    }
    
    func delegateSelectedShifts(array: [DayShiftDetail]) {
        print("Select Shift ")

    }
    
    //#MARK: Delegate
    func DelegateCountryList(CountryName: String, CountryId: String, isCountry: Bool, isTown: Bool) {
        self.txtState.text = CountryName
        self.stateId = CountryId
        
    }
    func delegatePostJobcategory(array:[[String:Any]]){
        
    }
    
    func delegateCategoryType(array: [[String : String]]) {
        var arrayName = [String]()
        var arrayCategoryId = [String]()
        arraySetId = [String]()
        print("Array : \(array)")
        for dict in array {
            //isSelectCategory = true
//            let dict = item
            let name = dict["name"]!
            let catId = dict["id"]!
            arrayName.append(name)
            arrayCategoryId.append(catId)
        }
        arraySetId = arrayCategoryId
        txtSelectCategory.text = arrayName.map{String($0)}.joined(separator: ",")
        serviceCategory = arrayCategoryId.map{String($0)}.joined(separator: ",")
        
        print("arraySetId: \(arraySetId),text : \(txtSelectCategory.text), serviceCategory: \(serviceCategory) ")
     }
    
    
      func delegateDidBeginEditing(strData: String, index: Int) {
     
//          var startTime = Date()
//          var endTime = Date()
//
          var dict = [String:Any]()
          let formatter = DateFormatter()
          formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "time")
          formatter.locale = Locale(identifier: "en_US_POSIX")
          formatter.amSymbol = "AM"
          formatter.pmSymbol = "PM"
          if strData == "Start" {

              DatePickerDialog().show(controller: self, "Start Time",doneButtonTitle:  "Done", cancelButtonTitle: "Cancel",datePickerMode: .time) { [self] date in
                  print("date: \(date)")
                  
                  if let date = date{
                      startTime = "\(date ?? Date())"
                      let dictall = self.arrayDates[index]
                      let dateFormatter = DateFormatter()
                      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

                      let time = formatter.string(from: date ?? Date())
                        print("time: \(time)")
                        
                      print("start time valid")
                      
                      dict["startTime"] = time
                      let dates = dictall["dates"] as! String
                      let end = dictall["endTime"] as! String
                      let dateString = dictall["fullformat"] as! String
                      dict["startTime"] = time
                      dict["endTime"] = ""
                      dict["dates"] = dates
                      dict["fullformat"] = dateString
                      let addDates1 = dates + " " + time
                      let addDates2 = dates +  " " + end
                      
                      print(addDates1)
                      print(addDates2)
      //                  let dateFormatter = DateFormatter()
                      dateFormatter.dateFormat = "dd/M/yyyy, HH:mm"
                      // let s = dateFormatter.date(from: addDates1)
                    print("dict: \(dict)")

                      self.arrayDates[index] = dict
                      let indexPath = IndexPath(item: index, section: 0)
                      self.tbleView.reloadRows(at: [indexPath], with: .fade)
                      
                  }else {
                      print("date picker Cancle")
                  }
              }
          }else{
          
              DatePickerDialog().show(controller: self, "End Time",doneButtonTitle:  "Done", cancelButtonTitle: "Cancel",datePickerMode: .time) { [self] date in
                  print("date: \(date)")
                  if let date = date{
                      endTime = "\(date ?? Date())"
                      print("self.arrayDates: \(self.arrayDates.count)")
                      let dictall = self.arrayDates[index]
                      
                      let dateFormatter = DateFormatter()
                      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                      
                      let time = formatter.string(from: date ?? Date())
                      print("time: \(time)")
                      
                      //for compare only 2 times
                      let dateFormatter1 = DateFormatter()
                      dateFormatter1.dateFormat = "h:mm a"
                      let cStartTime = dictall["startTime"] as! String
                      let cEndTime = time
                      print("cStartTime = ",cStartTime)
                      print("cEndTime = ",cEndTime)
                      if let time1 = dateFormatter1.date(from: cStartTime), let time2 = dateFormatter1.date(from: cEndTime) {
                          let comparisonResult = time1.compare(time2)
                          if comparisonResult == .orderedAscending {
                              let dates = dictall["dates"] as! String
                              let start = dictall["startTime"] as! String
                              let dateString = dictall["fullformat"] as! String
                              dict["startTime"] = start
                              dict["endTime"] = time
                              dict["dates"] = dates
                              dict["fullformat"] = dateString
                              
                              print("dict: \(dict)")
                              self.arrayDates[index] = dict
                              let indexPath = IndexPath(item: index, section: 0)
                              self.tbleView.reloadRows(at: [indexPath], with: .fade)
                          } else if comparisonResult == .orderedDescending {
                              print("End time invalid")
                              self.showAlert(title: ALERTMESSAGE, message: "Please Select Valid End time.")
                          } else {
                              print("End time invalid")
                              self.showAlert(title: ALERTMESSAGE, message: "Please Select Valid End time.")
                          }
                      } else {
                          print("Error parsing times")
                      }
                  }else{
                      print("date picker Cancle")

                  }
              }
          }
      }
}


extension EditJobVC:UITextViewDelegate,UITextFieldDelegate{
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
        print(textView)
            textView.textColor = UIColor.hexStringToUIColor(hex: "7E8290")
        return textView.text.count + (text.count - range.length) <= 150
        }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("select categaroy ")
     
        if textField == txtSelectCategory{
            let popup : SelectCategoryPopupVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "SelectCategoryPopupVC") as! SelectCategoryPopupVC
                popup.delagate = self
                self.presentOnRoot(with: popup)
            textField.resignFirstResponder()
        }else if txtStartDate == textField{
            
            startDateSelect()
        }else if txtEndDate == textField{
            endDateSelect()
        }else if txtStartTime ==  textField{

            startTimeSelect()
        }else if txtEndTime == textField{

            endTimeSelect()
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if isPaymentThrough {
        if txtFixedPrice == textField
            {
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
                let regex = "\\d{0,4}(\\.\\d{0,2})?"
                
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                return predicate.evaluate(with:newString)
            }
         }else{
            if txtFixedPrice == textField
            {
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
                let regex = "\\d{0,2}(\\.\\d{0,2})?"
                
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                return predicate.evaluate(with:newString)
            }
        }
//       if !isPaymentThrough {
//        if let text = textField.text as NSString? {
//            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
//            let regex = try? NSRegularExpression(pattern: "^\\d{0,2}(\\.\\d{0,2})?$", options: [])
//                        return regex?.firstMatch(in: txtAfterUpdate, options: [], range: NSRange(location: 0, length: txtAfterUpdate.count)) != nil
//
//                    }
//                    return true
//        }else
//            if isPaymentThrough {
//            if let text = textField.text as NSString? {
//            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
//            let regex = try? NSRegularExpression(pattern: "^\\d{0,4}(\\.\\d{0,2})?$", options: [])
//            return regex?.firstMatch(in: txtAfterUpdate, options: [], range: NSRange(location: 0, length: txtAfterUpdate.count)) != nil
//                }
//            return true
//        }
        return true
    
    }
}
extension EditJobVC{
    
    func startDateSelect(){
        if !isFixedSelected{
            //textField.resignFirstResponder()
            self.showAlert(title: "Please Select payment.", message: ALERTMESSAGE)
            //                self.showAlert(title: "Please Select payment through.", message: ALERTMESSAGE)
        }else{
            var components = DateComponents()
            components.day = 0
            let startDateWithTimePlusOne = Calendar.current.date(byAdding: components, to:  Date())
            DatePickerDialog().show(controller: self, "Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: startDateWithTimePlusOne, datePickerMode: .date) { [self]
                (date) -> Void in
                if let dt = date {
                    isResetData = true
                    hourlyJobTime.removeAll()
                    tbleView.reloadData()
                    let formatter = DateFormatter()
                    formatter.dateFormat = self.getDateTimeFormat(param: "date")
                    //sender.setAttributedTitle(NSAttributedString(string: formatter.string(from: dt)), for: .normal)
                    self.txtStartDate.text = formatter.string(from: dt)
                    self.txtStartDate.inputView = self.timeDatePicker
                    
                 
                    self.startDate = self.txtStartDate.text!
                    formatter.dateFormat = self.getDateTimeFormat(param: "server")
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    self.startDate = formatter.string(from: dt)
                    self.isStartDate = true
                    //  print(dt)
                    //  print(formatter.string(from: dt))
                    //  print(self.startTime)
                    // self.startDate1 = formatter.date(from: self.startTime) ?? dt
                    //  print(self.startDate1)
                    // print(self.txtEndDate.text!)
                }
            }
        }
        
    }
    
    func endDateSelect(){
        if !isFixedSelected{
            self.showAlert(title: "Please Select payment.", message: ALERTMESSAGE)
            //            self.showAlert(title: "Please Select payment through.", message: ALERTMESSAGE)
        }else{
            if !isStartDate {
                self.showAlert(title: "Please Select start date.", message: ALERTMESSAGE)
            }
            else{
                var startDate = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = self.getDateTimeFormat(param: "server")
                formatter.locale = Locale(identifier: "en_US_POSIX")
                if let sDate = formatter.date(from:self.startDate){
                    startDate = sDate
                }
           
                print("startDate: \(self.startDate)")
                var components = DateComponents()
                // components.day = 1
                let newDate = Calendar.current.date(byAdding: components, to: startDate)
                components = DateComponents()
                let afteroneYearDate = Calendar.current.date(byAdding: components, to: startDate)
                
                components = DateComponents()
                if isPaymentType == true {
                    components.day = 60
                }else{
                    components.day = 30
                }
                let maximumDate = Calendar.current.date(byAdding: components, to: startDate) // 15 day
                DatePickerDialog().show(controller: self, "End Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate:afteroneYearDate!, minimumDate:newDate,maximumDate:maximumDate, datePickerMode:.date) { [self]
                    (date) -> Void in
                    
                    isResetData = true

                    if let dt = date {
                        hourlyJobTime.removeAll()
                        tbleView.reloadData()
                        let formatter = DateFormatter()
                        formatter.dateFormat = self.getDateTimeFormat(param: "date")
                        // sender.setAttributedTitle(NSAttributedString(string: formatter.string(from: dt)), for: .normal)
                        self.txtEndDate.text = formatter.string(from: dt)
                        formatter.dateFormat = self.getDateTimeFormat(param: "server")
                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        self.endDate = formatter.string(from: dt)
                        self.endTime = self.txtEndDate.text!
                        self.endDate1 = dt
                        print(dt)
                        print(formatter.string(from: dt))
                        print(self.startTime)
                        self.arrayDates = [[String:Any]]()
                        self.tbleView.reloadData()
                        self.refershCal()
                        
                    }
                }
            }
        }
        
    }
    
    func startTimeSelect(){
        if !isFixedSelected{
            self.showAlert(title: "Please Select payment.", message: ALERTMESSAGE)
            //                 self.showAlert(title: "Please Select payment through.", message: ALERTMESSAGE)
        }else{
            if startDate != "" && endDate != ""{
                if startDate == self.getCurrentDate(){
                    
                    DatePickerDialog().show(controller:self,"Start Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: Date(), datePickerMode: .time) {
                        (date) -> Void in
                        if let dt = date {
                            var formatter = DateFormatter()
                            formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "time")
                            formatter.locale = Locale(identifier: "en_US_POSIX")
                            formatter.amSymbol = "AM"
                            formatter.pmSymbol = "PM"
                            //                          sender.setTitle(formatter.string(from: dt), for: .normal) //#DR
                            self.startTime = formatter.string(from: dt)
                            formatter = DateFormatter()
                            formatter.amSymbol = "AM"
                            formatter.pmSymbol = "PM"
                            formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "dateTime12")
                            formatter.locale = Locale(identifier: "en_US_POSIX")
                            self.startDateWithTime = dt//formatter.string(from: dt)
                            self.endTime = ""
                            self.btnEndTime.setTitle("End Time", for: .normal)
                            self.arrayDates = [[String:Any]]()
                            self.tbleView.reloadData()
                        }
                    }
                }else{
                    
                    if self.startDateWithTime.compare(Date()) == .orderedSame{
                        DatePickerDialog().show(controller:self,"Start Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: Date(), datePickerMode: .time) {
                            (date) -> Void in
                            if let dt = date {
                                var formatter = DateFormatter()
                                formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "time")
                                formatter.locale = Locale(identifier: "en_US_POSIX")
                                formatter.amSymbol = "AM"
                                formatter.pmSymbol = "PM"
                                //                              sender.setTitle(formatter.string(from: dt), for: .normal)//#DR
                                self.startTime = formatter.string(from: dt)
                                formatter = DateFormatter()
                                formatter.amSymbol = "AM"
                                formatter.pmSymbol = "PM"
                                formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "dateTime12")
                                formatter.locale = Locale(identifier: "en_US_POSIX")
                                self.startDateWithTime = dt//formatter.string(from: dt)
                                self.endTime = ""
                                self.btnEndTime.setTitle("End Time", for: .normal)
                            }
                            
                        }
                    }else{
                        DatePickerDialog().show(controller:self,"Start Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: nil, datePickerMode: .time) {
                            (date) -> Void in
                            if let dt = date {
                                
                                var formatter = DateFormatter()
                                formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "time")
                                formatter.locale = Locale(identifier: "en_US_POSIX")
                                formatter.amSymbol = "AM"
                                formatter.pmSymbol = "PM"
                                //sender.setTitle(formatter.string(from: dt), for: .normal)
                                self.txtStartTime.text = (formatter.string(from: dt))
                                self.startTime = formatter.string(from: dt)
                                formatter = DateFormatter()
                                formatter.amSymbol = "AM"
                                formatter.pmSymbol = "PM"
                                formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "dateTime12")
                                formatter.locale = Locale(identifier: "en_US_POSIX")
                                self.startDateWithTime = dt//formatter.string(from: dt)
                                self.endTime = ""
                                // self.btnEndTime.setTitle("End Time", for: .normal)
                                self.txtEndTime.text = ""
                                self.arrayDates = [[String:Any]]()
                                DispatchQueue.main.async {
                                    
                                    var arr = [[String:Any]]()
                                    print("arrayDates:\(self.hourlyJobTime.count)")
                                    for each in self.arrayDates{
                                        
                                        var dict = [String:Any]()
                                        dict["dates"] =  each["dates"]
                                        dict["startTime"] = self.timeCovert12To24(strDate: self.startTime)
                                        dict["endTime"] =  each["endTime"]
                
                                        dict["fullformat"] = each["fullformat"]
                                        arr.append(dict)
                                    }
                                    self.arrayDates = arr
                                    
                                    for each in self.hourlyJobTime{
                                        each.startTime = self.timeCovert12To24(strDate: self.startTime)//
                                    }
                                    self.tbleView.reloadData()
                                }
                            }
                            
                        }
                    }
                }
            }else{
                
                self.refershCal()
                print("Select satrt and end date first.")
                
            }
            
        }
    }
    
    func endTimeSelect(){
        if !isFixedSelected{
            self.showAlert(title: "Please Select payment.", message: ALERTMESSAGE)
            //        self.showAlert(title: "Please Select payment through.", message: ALERTMESSAGE)
        }else{
            if startDate != "" && endDate != ""{
                let days = 1
                if startTime != ""{
                    
                    if days == 1
                    {
                        var components = DateComponents()
                        components.minute = 2
                        let startDateWithTimePlusOne = Calendar.current.date(byAdding: components, to: startDateWithTime)
                        
                        print("startDateWithTimePlusOne: \(startDateWithTimePlusOne)")
                        DatePickerDialog().show(controller: self, "End Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel" ,minimumDate: startDateWithTimePlusOne, datePickerMode: .time) {
                            (date) -> Void in
                            if let dt = date {
                                var formatter = DateFormatter()
                                formatter = DateFormatter()
                                formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "time")
                                formatter.locale = Locale(identifier: "en_US_POSIX")
                                formatter.amSymbol = "AM"
                                formatter.pmSymbol = "PM"
                                //sender.setTitle(formatter.string(from: dt), for: .normal)
                                self.txtEndTime.text = (formatter.string(from: dt))
                                self.endTime = formatter.string(from: dt)
                                //  self.getMultipleDates()
                                
                                print("isPaymentThrough: \(self.isPaymentThrough),isResetData: \(self.isResetData) ")
                                if  !self.isPaymentThrough  && self.isResetData{
                                    self.getMultipleDates()
                                }else{
                                    
                                    DispatchQueue.main.async {
                                        
                                        var arr = [[String:Any]]()
                                        print("arrayDates:\(self.hourlyJobTime.count)")
                                        for each in self.arrayDates{
                                            
                                            var dict = [String:Any]()
                                            dict["dates"] =  each["dates"]
                                            dict["startTime"] = each["startTime"]
                                            dict["endTime"] = self.timeCovert12To24(strDate: self.endTime)//self.endTime
                                            dict["fullformat"] = each["fullformat"]
                                            arr.append(dict)
                                        }
                                        self.arrayDates = arr
                                        
                                        print("time: \(self.timeCompare(strDate: self.startTime, endTime: self.endTime))")
                                        
                                        if self.timeCompare(strDate: self.startTime, endTime: self.endTime){
                                            for each in self.hourlyJobTime{
                                                each.endTime = self.timeCovert12To24(strDate: self.endTime)//
                                            }
                                        }else {
                                            print("please select vaild end time")
                                            
                                            if self.txtStartTime.text == ""{
                                                self.showAlert(title: ALERTMESSAGE, message: "Please select Start Time")
                                            }else {
                                                self.isResetData = true

                                                self.txtStartTime.text = ""
                                                self.txtEndTime.text = ""
                                                self.arrayDates.removeAll()
                                                self.hourlyJobTime.removeAll()
                                                self.tbleView.reloadData()
                                            }
                                            
                                        }
 
                                        self.tbleView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        /*DatePickerDialog().show(controller: self, "End Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel" ,minimumDate: nil, datePickerMode: .time) {
                            (date) -> Void in
                            if let dt = date {
                                var formatter = DateFormatter()
                                formatter = DateFormatter()
                                formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "time")
                                formatter.locale = Locale(identifier: "en_US_POSIX")
                                formatter.amSymbol = "AM"
                                formatter.pmSymbol = "PM"
                                // sender.setTitle(formatter.string(from: dt), for: .normal)
                                self.txtEndTime.text = (formatter.string(from: dt))
                                self.endTime = formatter.string(from: dt)
                            }
                        }*/
                    }
                }else{
                    print("Please select start time first.")
                    self.showAlert(title: "Please select start time first.", message: ALERTMESSAGE)
                    self.endTime = ""
                }
            }else{
                print("Select satrt and end date first.")
            }
        }
    }
    
    func refershCal() {
        
        self.txtStartDate.placeholder = "MM/DD/YYYY"
        self.txtEndDate.placeholder = "MM/DD/YYYY"
        self.txtStartTime.placeholder = "HH:MM"
        self.txtEndTime.placeholder = "HH:MM"
        
    }
    
    func timeCompare(strDate: String, endTime: String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let sTime = dateFormatter.date(from: strDate)
        let eTime = dateFormatter.date(from: endTime)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let s_Time = dateFormatter.string(from: sTime!)
        let e_Time = dateFormatter.string(from: eTime!)
        
        if s_Time < e_Time{
            return true
        }else{
            return false
        }
    }
    
    func timeCovert12To24(strDate: String) -> String{
        let dateAsString = strDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "HH:mm:ss"

        let Date24 = dateFormatter.string(from: date!)
        print("24 hour formatted Date:",Date24)
        return Date24
    }
    
    // MARK: - Get Date Time Format
    func getDateTimeFormat(param:String) -> String{
        
        if param == "date" {
            return "MMM d, yyyy"
        }else if param == "time"{
            return "h:mm a"//"HH:mm a"
            
        }else if param == "dateTime"{
            return "MMM dd, yyyy h:mm a"
        }else if param == "server"{
            //2018-05-17T05:24:18.576Z
            //"2018-05-20T12:28:05.000Z"
            //2018-05-14T12:32:00.127Z
            return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        }else if param == "isolocal"{
            let locale = NSLocale.current
            let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
            if formatter.contains("a") {
                //phone is set to 12 hours
                return  "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
            } else {
                //phone is set to 24 hours
                return  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            }
        }
        return "MMM d, yyyy"
    }
    func getCurrentDate() -> String{
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = self.getDateTimeFormat(param: "date")
         let strDate = dateFormatter.string(from: Date())
         return strDate
     }
   // MARK: - Get Date Time Format 12 Hours
   
    func checkDateFiled(){
        
        if  txtStartDate.text! != "" && txtEndDate.text! != "" && txtStartTime.text! != "" && txtEndTime.text! != ""{
            startDate = txtStartDate.text!
            endDate = txtEndDate.text!
            
            startTime = txtStartTime.text!
            endTime = txtEndTime.text!
        }else {
            showAlert(title: ALERTMESSAGE, message: "Please select Date and Time filed")
        }
        
       
    }
    
    func getMultipleDates() {
        
        arrayDates = [[String:Any]]()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        print("startDate :\(self.startDate), endDate: \(endDate) ")

        var sdate1 = Date()
        var edate2 = Date()
        if let sdate = dateFormatter.date(from:"\(self.startDate)"), let edate =   dateFormatter.date(from: self.endDate){
            
             sdate1 = sdate
             edate2 = edate
        }else {
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

            if let sdate = dateFormatter.date(from:"\(self.startDate)"), let edate =   dateFormatter.date(from: self.endDate){
                
                 sdate1 = sdate
                 edate2 = edate
            }else{
                print("startDate :\(self.startDate), endDate: \(endDate) ")
                dateFormatter.dateFormat = "MMM dd, YYYY"

                if let sdate = dateFormatter.date(from:"\(self.startDate)"), let edate =   dateFormatter.date(from: self.endDate){
                    
                     sdate1 = sdate
                     edate2 = edate
                }
            }
        }
        
        print("sdate1: \(sdate1),edate2: \(edate2) ")
        
        let datesBetweenArray = Date.dates(from: sdate1, to: edate2)
        
        print("datesBetweenArray: \(datesBetweenArray)")
        
        for i in 0..<datesBetweenArray.count{
            var dict = [String:Any]()
            let getDate = datesBetweenArray[i]
            print(getDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let dateString = dateFormatter.string(from: getDate)
            let newDates = self.extensionChangeDateFormat(dateString)
            print(newDates)
            dict["dates"] = newDates
            dict["startTime"] = startTime
            dict["endTime"] = endTime
            dict["fullformat"] = dateString
            print("newDates: \(newDates), startTime:\(startTime),endTime: \(endTime) ,dateString: \(dateString)")
            arrayDates.append(dict)
        }
        tbleView.reloadData()

    }

}
extension EditJobVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        var dLatitude = place.coordinate.latitude
        var dLongitude = place.coordinate.longitude
        strLatitude = String(dLatitude)
        strLongitude = String(dLongitude)
        self.lblJobLocation.text = place.name!
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension EditJobVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayDates.count > 0{
            return arrayDates.count
        }
        return self.hourlyJobTime.count
       //
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayDates.count > 0{
            var cell : PostJobHourlyTableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "PostJobHourlyTableViewCell", for: indexPath) as? PostJobHourlyTableViewCell
            if arrayDates.count > 0{
                let dict = arrayDates[indexPath.row]
                print("dict: \(dict)")
                cell?.txtStartTime.isHidden = true
                cell?.txtEndTime.isHidden = true
                
                if dict["startTime"] as? String == ""{
                    cell?.txtStartTime.isHidden = false
                }
                if dict["endTime"] as? String == ""{
                    cell?.txtEndTime.isHidden = false
                }

                cell?.lblDates.text   = dict["dates"] as? String
                print("Start Time: \(dict["startTime"]),endTime: \(dict["endTime"])")
                cell?.btnStartTime.setTitle(dict["startTime"] as? String, for: .normal)
                cell?.btnEndTime.setTitle(dict["endTime"] as? String, for: .normal)
                cell?.btnStartTime.tag = indexPath.row
                cell?.btnEndTime.tag = indexPath.row
                cell?.delagate = self

            }
            return cell!
            
        }else{
            
            var cell : PostJobHourlyTableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "PostJobHourlyTableViewCell", for: indexPath) as? PostJobHourlyTableViewCell
            //t dict = arrayDates[indexPath.row]
            cell?.lblDates.text   = self.hourlyJobTime[indexPath.row].date
            cell?.txtStartTime.text   = self.hourlyJobTime[indexPath.row].startTime
            //cell?.txtStartTime.inputView = datePicker
            cell?.txtEndTime.text   = self.hourlyJobTime[indexPath.row].endTime
            cell?.txtEndTime.inputView = datePicker
            
            cell?.btnStartTime.setTitle(self.hourlyJobTime[indexPath.row].startTime, for: .normal)
            cell?.btnEndTime.setTitle(self.hourlyJobTime[indexPath.row].endTime, for: .normal)
            cell?.btnStartTime.tag = indexPath.row
            cell?.btnEndTime.tag = indexPath.row
            cell?.delagate = self

            //      cell?.txtEndTime.addTarget(self, action: #selector(MNPostJobVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            return cell!
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //         let details = self.storyboard?.instantiateViewController(withIdentifier: "MNPostDetailVC") as! MNPostDetailVC
        //        details.strJobId = self.objIndividual[indexPath.row].id
        //        self.navigationController?.pushViewController(details, animated: true)
        
    }
    
    
    
    func comaperTime(time1:Date,time2:Date,rowNumber:Int) {
        let difference = Calendar.current.dateComponents([.hour, .minute], from: time1, to: time2)
        let formattedString = String(format: "%02ld%02ld", difference.hour!, difference.minute!)
        print(formattedString)
    }
    func getAllTimes() {
//        let currentDate: String = Global.stringFromNSDate(Date(), dateFormate: "yyyy-MM-dd hh:mm a")
//        self.datePicker.minimumDate = Global.nsdateFromString(currentDate, dateFormate: "yyyy-MM-dd hh:mm a")
//        self.view.endEditing(true)
        
//        var calendar:NSCalendar = Calendar.current as NSCalendar
//        let components = calendar.components(NSCalendar.Unit.HourCalendarUnit | NSCalendar.Unit.MinuteCalendarUnit, fromDate: NSDate() as Date)
//        components.hour = 5
//        components.minute = 50
//        datePicker.setDate(calendar.dateFromComponents(components)!, animated: true)
    }
     
       
       
       
    
    
    
    
}

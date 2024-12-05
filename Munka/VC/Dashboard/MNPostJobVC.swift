//
//  MNPostJobVC.swift
//  Munka
//
//  Created by Amit on 26/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import GooglePlaces
import Stripe

class MNPostJobVC: UIViewController,GetSelectCategory,GetCountrylist {
  
    
    
    @IBOutlet weak var txtPersonOfContact: IBTextField!
    
    @IBOutlet weak var txtDressCode: IBTextField!
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
    @IBOutlet weak var txtJobLocation: UITextField!
    @IBOutlet weak var txtFixedPrice: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtStartDate: UITextField!
     @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tbleView: UITableView!
    
    @IBOutlet weak var vwPayment: UIView!
    @IBOutlet weak var topVwPayment: NSLayoutConstraint!
    @IBOutlet weak var btnVolunteer: UIButton!
    
    var arraySetId = [String]()
    //// Mark : Only Start date, End Date, Start Time,End Time
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    var name = ""
   // var strCategoryId = ""
    
    @IBOutlet weak var txtShift: UITextField!
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
    //var isHourlySelected = false
//    var startTime = ""
//    var endTime = ""
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
    
    var checkStartDate = ""
    var checkEndTime = ""
    var timeDatePicker = UIDatePicker()

    var strCity = ""
    var strCountry = ""
    var strZipCode = ""
    var arrSelectedShift = [DayShiftDetail]()
    var strSelectedShiftTime = String ()
    
    var PaymentIntendClientSecret = ""
    var intendpaymentMethod = ""
    
    var selectedDaysWeekDays = [String]()
    var selectedShiftDays = [[String:String]]()
    var finalDays = [[String:String]]()
    var totalHours = 0
    
    var customerId = String()
    var ephemeralKey_secret = String()
    var payment_IntentId = String()
    
    var amount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNote.text = "for jobs where licenses or certificates are required"
        btnProfessional.isSelected = true
        // Do any additional setup after loading the view.
        txtViewJobDescriptions.text = "Job Description…"
        txtViewJobDescriptions.textColor = UIColor.hexStringToUIColor(hex: "B1B1B1")
        txtStartDate.inputView = timeDatePicker
        txtEndDate.inputView = timeDatePicker
        txtStartTime.inputView = timeDatePicker
        txtEndTime.inputView = timeDatePicker
        
        self.txtViewJobDescriptions.delegate = self
//        datePicker.datePickerMode = UIDatePicker.Mode.date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMMM yyyy"
//        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: +1, to: Date())
        
        isProfessional = "1"
        isLocationPrivate = "0"
        isUrgentFill = "0"
//         txtFixedPrice.addTarget(self, action: #selector(MNPostJobVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
      
    }

    func callpaymentSheet() {
        if  isConnectedToInternet() {
            //  self.callStripePayment()
//            if txtAmount.text!  != "0.0" && txtAmount.text! != "0" && txtAmount.text! != "0.00" && txtAmount.text! != "0.000" &&
//                self.txtAmount.text!  != "00" && self.txtAmount.text!  != "000" &&
//                self.txtAmount.text!  != "0000" &&
//                self.txtAmount.text!  != "00000"{
                self.callServiceForCreateStripeIntent()
//                    callServiceForrechargeWalletAPI()
          
//            }else{
//                self.showErrorPopup(message: "Please enter valid amount.", title: ALERTMESSAGE)
//            }
        }else {
            self.showErrorPopup(message: internetConnetionError, title: ALERTMESSAGE)
        }
    }
    
    func callServiceForCreateStripeIntent() {
        if MyDefaults().StripeCustomerId == ""{
            MyDefaults().StripeCustomerId = "cus_PRdKhaFhweBUSU"
        }
        ShowHud(view: self.view)
        print(MyDefaults().UserId ?? "")
        if jobType == "Hourly"{
            amount = Int(txtFixedPrice.text ?? "0")! * Int(totalHours) * 100
        }else{
            amount = Int(txtFixedPrice.text ?? "0")! * 100
        }
        print(amount)
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
                    self.payment_IntentId = response["paymentIntent"] as! String
                    self.customerId = response["stripe_customer_id"] as! String
                    self.ephemeralKey_secret = response["ephemeralKey_secret"] as! String
                    print(paymentIntent)
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
    
    func presentPaymentSheet(clientSecret: String) {

        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Munka"
        configuration.customer = .init(id: customerId, ephemeralKeySecret: ephemeralKey_secret)
//        fetchCustomerPaymentMethods()
        let paymentSheet = PaymentSheet(
            paymentIntentClientSecret: clientSecret,
            configuration: configuration)
        
        paymentSheet.present(from: self) { [weak self] paymentResult in
            guard let self = self else { return }
            
            switch paymentResult {
            case .completed:
                print(clientSecret)
                if let paymentIntentID = self.extractPaymentIntentID(from: clientSecret) {
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
    
    func fetchCustomerPaymentMethods() {
        let customerContext = STPCustomerContext(keyProvider: ephemeralKey_secret as! STPCustomerEphemeralKeyProvider)
        customerContext.listPaymentMethodsForCustomer { paymentMethods, error in
            if let error = error {
                print("Error fetching payment methods: \(error.localizedDescription)")
                // Handle error
            } else {
                // Unwrap the optional paymentMethods array
                if let paymentMethods = paymentMethods {
                    // paymentMethods is now [STPPaymentMethod]
                    for paymentMethod in paymentMethods {
                        print("Payment Method: \(paymentMethod)")
                        // Display payment method details in your UI
                    }
                } else {
                    print("No payment methods found")
                    // Handle case where paymentMethods is nil
                }
            }
        }
    }
    
//    func extractPaymentIntentID(from clientSecret: String) -> String? {
//        // Decode the base64-encoded client secret
//        guard let decodedData = Data(base64Encoded: clientSecret),
//              let decodedString = String(data: decodedData, encoding: .utf8) else {
//            print("Error decoding client secret")
//            return nil
//        }
//
//        // The decoded string should be in JSON format
//        guard let jsonData = decodedString.data(using: .utf8),
//              let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
//            print("Error parsing JSON")
//            return nil
//        }
//
//        // Extract the Payment Intent ID from the JSON
//        if let paymentIntentID = json["payment_intent"] as? String {
//            return paymentIntentID
//        } else {
//            print("Payment Intent ID not found in JSON")
//            return nil
//        }
//    }
    
    func extractPaymentIntentID(from clientSecret: String) -> String? {
        // Stripe client secret format: "pi_<PaymentIntentID>_secret_<Secret>"
        let components = clientSecret.split(separator: "_")
        
        guard components.count >= 3, components[0] == "pi" else {
            print("Invalid client secret format")
            return nil
        }
        
        return String(components[0]) + "_" + String(components[1])
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
                    if let paymentMethod = responseData["id"] as? String {
                        print("Payment Method: \(paymentMethod)")
                        print("Payment Intent: \(responseData["id"] as? String)")
                        self.intendpaymentMethod = paymentMethod
                        DispatchQueue.main.async {
                            self.callPostJobAPI()
                        }
                        
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
        
        task.resume()
    }
    
    func getWeekdayName(from dateString: String, withFormat format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        return getWeekdayName(from: date)
    }
    
    func getWeekdayName(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Full weekday name
        return dateFormatter.string(from: date)
    }
    
    func hoursDifference(from startDate: Date, to endDate: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: startDate, to: endDate)
        return components.hour
    }
    
    @IBAction func actionOnProfessoinal(_ sender: UIButton) {
        if btnProfessional.isSelected {
            btnProfessional.isSelected = false
            if btnFreelancer.isSelected {
                btnFreelancer.isSelected = true
                btnVolunteer.isSelected = false
                isProfessional = "2"
                vwPayment.isHidden = false
                topVwPayment.constant = 170
                lblNote.text = "for jobs anyone can do"
            }else{
                btnFreelancer.isSelected = false
                btnVolunteer.isSelected = true
                isProfessional = "4"
                vwPayment.isHidden = true
                topVwPayment.constant = 20
                lblNote.text = "for jobs volunteer can do"
            }
            btnboth.isSelected = false
            
            
            
            
        }else{
            btnProfessional.isSelected = true
            if btnFreelancer.isSelected {
                btnFreelancer.isSelected = true
                btnVolunteer.isSelected = false
                isProfessional = "3"
                vwPayment.isHidden = false
                topVwPayment.constant = 170
                lblNote.text = ""
            }else{
                btnFreelancer.isSelected = false
                btnVolunteer.isSelected = false
                isProfessional = "1"
                vwPayment.isHidden = false
                topVwPayment.constant = 170
                lblNote.text = "for jobs where licenses or certificates are ;"
            }
            btnboth.isSelected = false
        }
        
    }
    
    @IBAction func actionOnFreelauncer(_ sender: UIButton) {
        
        if btnFreelancer.isSelected {
            btnFreelancer.isSelected = false
            if btnProfessional.isSelected {
                btnProfessional.isSelected = true
                btnVolunteer.isSelected = false
                isProfessional = "1"
                vwPayment.isHidden = false
                topVwPayment.constant = 170
                lblNote.text = "for jobs where licenses or certificates are ;"
            }else{
                btnProfessional.isSelected = false
                btnVolunteer.isSelected = true
                isProfessional = "4"
                vwPayment.isHidden = true
                topVwPayment.constant = 20
                lblNote.text = "for jobs volunteer can do"
            }
            btnboth.isSelected = false
            
            
            
//            lblNote.text = "for jobs where licenses or certificates are ;"
        }else{
            btnFreelancer.isSelected = true
            if btnProfessional.isSelected {
                btnProfessional.isSelected = true
                btnVolunteer.isSelected = false
                isProfessional = "3"
                vwPayment.isHidden = false
                topVwPayment.constant = 170
                lblNote.text = ""
            }else{
                btnProfessional.isSelected = false
                btnVolunteer.isSelected = false
                isProfessional = "2"
                vwPayment.isHidden = false
                topVwPayment.constant = 170
                lblNote.text = "for jobs anyone can do"
            }
            btnboth.isSelected = false
        }
        
//        btnProfessional.isSelected = false
//        btnFreelancer.isSelected = true
//        btnboth.isSelected = false
//        btnVolunteer.isSelected = false
//        isProfessional = "2"
//        lblNote.text = "for jobs anyone can do"
    }
    
    @IBAction func btnSelectDayAndShiftTap(_ sender: Any) {
        let popup : SelectCategoryPopupVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "SelectCategoryPopupVC") as! SelectCategoryPopupVC
        popup.delagate = self
        popup.isShiftSelected = true
        if arrSelectedShift.count > 0{
            popup.arrSelectedShift = arrSelectedShift
        }
        self.presentOnRoot(with: popup)
    }
    
    @IBAction func actionOnBoth(_ sender: UIButton) {
        btnProfessional.isSelected = false
        btnFreelancer.isSelected = false
        btnboth.isSelected = true
        isProfessional = "3"
        lblNote.text = ""
    }
    
    @IBAction func actionOnVolunteer(_ sender: UIButton) {
        btnProfessional.isSelected = false
        btnFreelancer.isSelected = false
        btnboth.isSelected = false
        btnVolunteer.isSelected = true
        vwPayment.isHidden = true
        topVwPayment.constant = 20
        isProfessional = "4"
        lblNote.text = ""
    }
    
    @IBAction func actionOnPaymentThrough(_ sender: UIButton) {
       txtStartDate.isEnabled = true
       txtEndDate.isEnabled = true
       txtEndTime.isEnabled = true
       txtStartTime.isEnabled = true
        switch sender.tag {
                case -98:
                    self.btnHourly.isSelected = true
                    self.btnFixed.isSelected = false
                    isPaymentThrough = false
                   // isHourlySelected = true
                    self.stratTime = Date()
                    self.stratTime = Date()
                    self.endDate1 = Date()
                    self.startDate1 = Date()
                    self.txtStartDate.text = ""
                    self.txtEndDate.text = ""
                    self.txtStartTime.text = ""
                    self.txtEndTime.text = ""
                    self.btnHourly.layer.borderColor = UIColor.hexStringToUIColor(hex: "13C1B3").cgColor
                    self.txtFixedPrice.placeholder = "Enter hourly price"
                    self.btnFixed.layer.borderColor = UIColor.hexStringToUIColor(hex: "B1B1B1").cgColor
                    isFixedSelected =  true
                   
                    jobType = "Hourly"
                    txtFixedPrice.text! = ""
                    txtFixedPrice.becomeFirstResponder()
//                    txtStartDate.becomeFirstResponder()
//                    txtEndDate.becomeFirstResponder()
//                    txtStartTime.becomeFirstResponder()
//                    txtEndTime.becomeFirstResponder()
                    self.isPaymentType = false
        case -99:
                   self.btnHourly.isSelected = false
                   self.btnFixed.isSelected = true
                  
                   //isHourlySelected = false
                   isFixedSelected =  true
                   self.txtFixedPrice.placeholder = "Enter fixed price"
                   self.stratTime = Date()
                   self.stratTime = Date()
                   self.endDate1 = Date()
                   self.startDate1 = Date()
                   self.txtStartDate.text = ""
                   self.txtEndDate.text = ""
                   self.txtStartTime.text = ""
                   self.txtEndTime.text = ""
                   isPaymentThrough = true
                   self.btnFixed.layer.borderColor = UIColor.hexStringToUIColor(hex: "13C1B3").cgColor
                   self.btnHourly.layer.borderColor = UIColor.hexStringToUIColor(hex: "B1B1B1").cgColor
                   self.arrayDates = [[String:Any]]()
                   self.tbleView.reloadData()
                   isFixedSelected =  true
                   self.isPaymentType = true
                    txtFixedPrice.text! = ""
                   jobType = "Fixed"
                   arrayDates = [[String:Any]]()
                   txtFixedPrice.becomeFirstResponder()
//                   txtStartDate.becomeFirstResponder()
//                   txtEndDate.becomeFirstResponder()
//                   txtStartTime.becomeFirstResponder()
//                   txtEndTime.becomeFirstResponder()
                default:
                    break
                }
    }
    @IBAction func actionOnPostJobs(_ sender: UIButton) {
        print(arrayDates)
//        selectedDaysWeekDays.removeAll()
//        for i in 0..<arrayDates.count{
//            if let weekdayName = getWeekdayName(from: arrayDates[i]["dates"] as! String, withFormat: "MMM dd, yyyy") {
//                print("The weekday name is: \(weekdayName)")
////                if !selectedDaysWeekDays.contains(weekdayName){
//                    selectedDaysWeekDays.append(weekdayName)
////                }
//                
//            } else {
//                print("Invalid date format")
//            }
//        }
        
        print(selectedDaysWeekDays)
        print(selectedShiftDays)
        
        
        if !isPostJobValidation() {
            if  isConnectedToInternet() {
                if ((self.txtFixedPrice.text! == "0") || (self.txtFixedPrice.text! == "0.00") || (self.txtFixedPrice.text! == "00") || (self.txtFixedPrice.text! == ".0") || (self.txtFixedPrice.text! == ".00") || (self.txtFixedPrice.text! == "0.0") || (self.txtFixedPrice.text! == ".")) {
                    self.showErrorPopup(message: "Please enter valid amount.", title: alert)
                    }else{
//                        self.callPostJobAPI()
//                        totalHours = 0
//                        print(selectedDaysWeekDays)
//                        print(selectedShiftDays)
//                        print(arrayDates)
//                        for dayString in arrayDates{
////                            for dayDataString in selectedShiftDays{
//                            print(dayString)
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "h:mm a"
//
//                            if let start = dateFormatter.date(from: "\(dayString["startTime"] ?? "")"),
//                               let end = dateFormatter.date(from: "\(dayString["endTime"] ?? "")") {
//                                if let hours = hoursDifference(from: start, to: end) {
//                                    print("Hours difference: \(hours)")
//                                    totalHours += hours
//                                }
//                            }
//                            
////                                if dayString == dayDataString["day"]{
////                                    if dayDataString["shift"] == "Overnight"{
////                                        totalHours += 7
////                                    }else{
////                                        totalHours += 8
////                                    }
////                                }
////                            }
//                        }
                         print(totalHours)
//                        self.callpaymentSheet()
                        self.callPostJobAPI()
                   }

                } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
//        self.callpaymentSheet()
    }
    @IBAction func actionOnSaveJobs(_ sender: UIButton) {
       if !isPostJobValidation() {
           if  isConnectedToInternet() {
            
           if ((self.txtFixedPrice.text! == "0") || (self.txtFixedPrice.text! == "0.00") || (self.txtFixedPrice.text! == "00") || (self.txtFixedPrice.text! == ".0") || (self.txtFixedPrice.text! == ".00") || (self.txtFixedPrice.text! == "0.0") || (self.txtFixedPrice.text! == ".")) {
               self.showErrorPopup(message: "Please enter valid amount.", title: alert)
            }else{
               self.callSaveJobAPI()
            }
        } else {
               self.showErrorPopup(message: internetConnetionError, title: alert)
           }
       }
       }
    func callPostJobAPI() {
        let parameter: [String: Any]
        if !isPaymentThrough {
            var arrayD = [String]()
            var arraySTime = [String]()
            var arrayETime = [String]()
            for items in self.arrayDates {
                let dict = items
                let dates = dict["dates"] as! String
                let start = dict["startTime"] as! String
                let end = dict["endTime"] as! String
                arrayD.append(self.convertMMMDDYYYYTOYYYYMMDD(dates))
                arraySTime.append(start)
                arrayETime.append(end)
                print(arrayD)
                print(arraySTime)
                print(arrayETime)
                
            }
            
            // ShowHud()
            ShowHud(view: self.view)
            parameter = ["user_id":MyDefaults().UserId ?? "",
                         "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                         "job_title":self.txtJoTitle.text!,
                         "job_description":self.txtViewJobDescriptions.text!,
                         "job_type":jobType,
                         "service_catagory":serviceCategory,
                         "job_location":self.txtJobLocation.text!,
                         "latitude":strLatitude,
                         "longitude":strLongitude,
                         "job_start_date":(self.convertMMMDDYYYYTOYYYYMMDD(self.txtStartDate.text!)),
                         "job_end_date":(self.convertMMMDDYYYYTOYYYYMMDD(self.txtEndDate.text!)),
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
                         "contactPerson": self.txtPersonOfContact.text!,
                         "dressCode": self.txtDressCode.text!,
                         "country":strCountry,
                         "city": "In",
                         "zipcode": "252225",
                         "shiftList": strSelectedShiftTime,
                         "transaction_id": intendpaymentMethod

            ]
            
        }else{
            
            parameter = ["user_id":MyDefaults().UserId ?? "",
                         "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                         "job_title":self.txtJoTitle.text!,
                         "job_description":self.txtViewJobDescriptions.text!,
                         "job_type":jobType,
                         "service_catagory":serviceCategory,
                         "job_location":self.txtJobLocation.text!,
                         "latitude":strLatitude,
                         "longitude":strLongitude,
                         "job_start_date":self.txtStartDate.text!,
                         "job_end_date":self.txtEndDate.text!,
                         "job_start_time":self.txtStartTime.text!,
                         "job_end_time":self.txtEndTime.text!,
                         "budget_amount":self.txtFixedPrice.text!,
                         "is_professional":isProfessional,
                         "is_publish":"1",
                         "urgent_fill":isUrgentFill,
                         "is_private" : isLocationPrivate,
                         "state":self.stateId,
                         "contactPerson": self.txtPersonOfContact.text!,
                         "dressCode": self.txtDressCode.text!,
                         "country":strCountry,
                         "city": "In",
                         "zipcode": "252225",
                         "shiftList": strSelectedShiftTime,
                         "transaction_id": intendpaymentMethod

                         
            ]
        }
        
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNPJobPostAPI, parameter: parameter) { (response) in
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
    func callSaveJobAPI() {
        let parameter: [String: Any]
        if !isPaymentThrough {
            var arrayD = [String]()
            var arraySTime = [String]()
            var arrayETime = [String]()
            for items in self.arrayDates {
                let dict = items
                let dates = dict["dates"] as! String
                let start = dict["startTime"] as! String
                let end = dict["endTime"] as! String
                // arrayD.append(dates)
                arrayD.append(self.convertMMMDDYYYYTOYYYYMMDD(dates))
                arraySTime.append(start)
                arrayETime.append(end)
                
            }
            
            
            // ShowHud()
            ShowHud(view: self.view)
            parameter = ["user_id":MyDefaults().UserId ?? "",
                         "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                         "job_title":self.txtJoTitle.text!,
                         "job_description":self.txtViewJobDescriptions.text!,
                         "job_type":jobType,
                         "service_catagory":serviceCategory,
                         "job_location":self.txtJobLocation.text!,
                         "latitude":strLatitude,
                         "longitude":strLongitude,
                         "job_start_date":self.txtStartDate.text!,
                         "job_end_date":self.txtEndDate.text!,
                         "job_start_time":self.txtStartTime.text!,
                         "job_end_time":self.txtEndTime.text!,
                         "budget_amount":self.txtFixedPrice.text!,
                         "is_professional":isProfessional,
                         "is_publish":"2",
                         "urgent_fill":isUrgentFill,
                         "hourly_date":arrayD,
                         "hourly_start_time":arraySTime,
                         "hourly_end_time":arrayETime,
                         "is_private" : isLocationPrivate,
                         "state":self.stateId,
                         "contactPerson": self.txtPersonOfContact.text!,
                         "dressCode": self.txtDressCode.text!,
                         "shiftList": strSelectedShiftTime

            ]
            
        }else{
            
            //  ShowHud()
            
            parameter = ["user_id":MyDefaults().UserId ?? "",
                         "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                         "job_title":self.txtJoTitle.text!,
                         "job_description":self.txtViewJobDescriptions.text!,
                         "job_type":jobType,
                         "service_catagory":serviceCategory,
                         "job_location":self.txtJobLocation.text!,
                         "latitude":strLatitude,
                         "longitude":strLongitude,
                         "job_start_date":self.txtStartDate.text!,
                         "job_end_date":self.txtEndDate.text!,
                         "job_start_time":self.txtStartTime.text!,
                         "job_end_time":self.txtEndTime.text!,
                         "budget_amount":self.txtFixedPrice.text!,
                         "is_professional":isProfessional,
                         "is_publish":"2",
                         "urgent_fill":isUrgentFill,
                         "is_private" : isLocationPrivate,
                         "state":self.stateId,
                         "contactPerson": self.txtPersonOfContact.text!,
                         "dressCode": self.txtDressCode.text!,
                         "shiftList": strSelectedShiftTime

                         // "user_type":MyDefaults().swiftUserData!["user_type"]!
            ]
        }
        
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNPJobPostAPI , parameter: parameter) { (response) in
            debugPrint(response)
            
            // HideHud()
            HideHud(view: self.view)
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    
                    self.navigationController?.popViewController(animated: true)
                    self.alertViewForBacktoController(title: ALERTMESSAGE, message: message)
                } else if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }
            }else
                {
                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
        }
    }
   
    @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOnUrgentFill(_ sender: UIButton) {
        if btnUrgentFill.isSelected {
              self.btnUrgentFill.isSelected = false
                isUrgentFill = "0"
          }else {
        self.btnUrgentFill.isSelected = true
                isUrgentFill = "1"
          }
    }
    @IBAction func actionOnIsprivateLocation(_ sender: UIButton) {
       if btnIsPrivateLocation.isSelected {
              self.btnIsPrivateLocation.isSelected = false
        print("false")
            isLocationPrivate = "0"
          }else {
        self.btnIsPrivateLocation.isSelected = true
             print("true")
            isLocationPrivate = "1"
          }
    }
    @IBAction func actionOnJobLocation(_ sender: UIButton) {
        let placePickerController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
              filter.type = .noFilter  //suitable filter type
              //filter.country = "USA"  //appropriate country code
              placePickerController.autocompleteFilter = filter
        let searchBarTextAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white, NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
                       placePickerController.delegate = self
                       present(placePickerController, animated: true, completion: nil)
                       self.popupAlert(title: "Title", message: " Oops, xxxx ", actionTitles: ["Option1","Option2","Option3"], actions:[{action1 in
               
                           },{action2 in
               
                           }, nil])
    }
    @IBAction func actionOnSelectCategory(_ sender: UIButton) {
//        let popup : PostJobCategoryPopUp = storyBoard.PopUp.instantiateViewController(withIdentifier: "PostJobCategoryPopUp") as! PostJobCategoryPopUp
//                    popup.delagate = self
//        //        popup.isClickOnSignUp = false
//                self.presentOnRoot(with: popup)
   
//    let popup : SelectCategoryPopupVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "SelectCategoryPopupVC") as! SelectCategoryPopupVC
//        popup.delagate = self
//        self.presentOnRoot(with: popup)
//        
        
        let popup : SelectCategoryPopupVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "SelectCategoryPopupVC") as! SelectCategoryPopupVC
        popup.delagate = self
        popup.isCategorySelected = true
        self.presentOnRoot(with: popup)
        
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
    
    func delegateSelectedWorkingDay(array: [String]) {
        print("Select Working Day \(array)")
    }
    

    func delegateSelectedShifts(array: [DayShiftDetail]) {
        print("Select Shift \(array)")
        arrSelectedShift = array
         
        var arrTitle = [String]()
        
        for str in array{
            
            arrTitle.append(str.headerTitle)
        }
        arrTitle = Array(Set(arrTitle))

        txtShift.text! = arrTitle.map{String($0)}.joined(separator: ",")
        
        convertArrayIntoString()

   
    }
    
    
    func convertArrayIntoString(){
        selectedShiftDays.removeAll()
        for data in  arrSelectedShift{
            
            var strDay = String()
            var strShift = String()
            var strStartTime = String()
            var strEndTime = String()
           
            strDay = "\"day\"" + ":" + "\"\(data.headerTitle)\""
            strShift = "\"shift\"" + ":" + "\"\(data.shift ?? "")\""
            strStartTime = "\"start_time\"" + ":" + "\"\(data.StartTime ?? "")\""
            strEndTime = "\"end_time\"" + ":" + "\"\(data.EndTime ?? "")\""
            
            selectedShiftDays.append(["day":"\(data.headerTitle)","shift":"\(data.shift ?? "")"])
            
            if strSelectedShiftTime == ""{
          

                strSelectedShiftTime = "{\(strDay),\(strShift),\(strStartTime),\(strEndTime)}"
            }else{
                strSelectedShiftTime = "\(strSelectedShiftTime)," + "{\(strDay),\(strShift),\(strStartTime),\(strEndTime)}"
            }
        }
        
        strSelectedShiftTime = "[\(strSelectedShiftTime)]"
        
        print("strShiftData: \(strSelectedShiftTime)")
        print("sssssssss: \(selectedShiftDays)")
    }
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

     /*   if array.count == 1 {
            let first = arrayName[0]
            let firstId = arrayCategoryId[0]
            serviceCategory =  "\(firstId),"
            txtSelectCategory.text = first
            //arraySetId.append(firstId)
        }else if arrayName.count == 2 {
            let first = arrayName[0]
            let second = arrayName[1]
            let firstId = arrayCategoryId[0]
            let SecondId = arrayCategoryId[1]
            serviceCategory = "\(firstId)" + "," + "\(SecondId)"
            txtSelectCategory.text = first + "," + second
            arraySetId.append(firstId)
            arraySetId.append(SecondId)
        }else if arrayName.count == 3 {
            let first = arrayName[0]
            let second = arrayName[1]
            let third = arrayName[2]
            
            let firstId = arrayCategoryId[0]
            let SecondId = arrayCategoryId[1]
            let thirdId = arrayCategoryId[2]
            arraySetId.append(firstId)
            arraySetId.append(SecondId)
            arraySetId.append(thirdId)
            
            serviceCategory = "\("\(firstId)")" + "," + "\("\(SecondId)")" + "," + "\("\(thirdId)")"
            txtSelectCategory.text = first + "," + second + "," + third
        }*/
    }
         
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
        guard let jobLocation = txtJobLocation.text , jobLocation != ""
        else {showAlert(title: ALERTMESSAGE, message: "Please enter job location.")
            return true}
        
        
        guard arrSelectedShift.count > 0
        else {showAlert(title: ALERTMESSAGE, message: "Please Select day and shift.")
            return true}
//         guard isFixedSelected == true || isHourlySelected == true else {showAlert(title:ALERTMESSAGE, message: "Please select payment through.")
//                     return true
//                 }
//       guard let enterFixedPrice = txtFixedPrice.text , enterFixedPrice != ""
//              else {showAlert(title: ALERTMESSAGE, message: "Please enter price.")
//                  return true}
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

extension MNPostJobVC{
    
    func startDateSelect(){
        // Set the style to compact
        if #available(iOS 14.0, *) {
            timeDatePicker.preferredDatePickerStyle = .compact
        }
//        if !isFixedSelected{
//            //textField.resignFirstResponder()
//            self.showAlert(title: "Please Select payment.", message: ALERTMESSAGE)
//            //                self.showAlert(title: "Please Select payment through.", message: ALERTMESSAGE)
//        }else{
            var components = DateComponents()
            components.day = 0
            let startDateWithTimePlusOne = Calendar.current.date(byAdding: components, to:  Date())
            DatePickerDialog().show(controller: self, "Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: startDateWithTimePlusOne, datePickerMode: .date) {
                (date) -> Void in
                if let dt = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = self.getDateTimeFormat(param: "date")
                    //sender.setAttributedTitle(NSAttributedString(string: formatter.string(from: dt)), for: .normal)
                    self.txtStartDate.text = formatter.string(from: dt)
                    
                    
                    
                    self.txtStartDate.inputView = self.timeDatePicker
                    
                    
                    self.startTime = self.txtEndDate.text!
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
//        }
        
    }
    
    func endDateSelect(){
        // Set the style to compact
        if #available(iOS 14.0, *) {
            timeDatePicker.preferredDatePickerStyle = .compact
        }
//        if !isFixedSelected{
//         self.showAlert(title: "Please Select payment.", message: ALERTMESSAGE)
////            self.showAlert(title: "Please Select payment through.", message: ALERTMESSAGE)
//        }else{
         if !isStartDate {
             self.showAlert(title: "Please Select start date.", message: ALERTMESSAGE)
         }
         else{
              let startDate : Date?
                let formatter = DateFormatter()
                formatter.dateFormat = self.getDateTimeFormat(param: "server")
                formatter.locale = Locale(identifier: "en_US_POSIX")
                startDate = formatter.date(from:self.startDate)
                
                var components = DateComponents()
               // components.day = 1
                let newDate = Calendar.current.date(byAdding: components, to: startDate!)
                components = DateComponents()
                let afteroneYearDate = Calendar.current.date(byAdding: components, to: startDate!)
               
                components = DateComponents()
                 if isPaymentType == true {
                     components.day = 60
                 }else{
                     components.day = 30
                 }
                 let maximumDate = Calendar.current.date(byAdding: components, to: startDate!) // 15 day
             DatePickerDialog().show(controller: self, "End Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate:afteroneYearDate!, minimumDate:newDate,maximumDate:maximumDate, datePickerMode:.date) { [self]
                    (date) -> Void in
                    if let dt = date {
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
                      
                        txtStartTime.text! = ""
                        txtEndTime.text! = ""
                        startTime = ""
                        endTime = ""
                        
                     self.arrayDates = [[String:Any]]()
//                        if  !self.isPaymentThrough {
//                         self.getMultipleDates()
//                        }
                     self.tbleView.reloadData()
                     self.refershCal()
                     
                    }
                }
             }
//         }

    }
    
    func startTimeSelect(){
        if #available(iOS 13.4, *) {
            timeDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
//        if !isFixedSelected{
//                   self.showAlert(title: "Please Select payment.", message: ALERTMESSAGE)
//  //                 self.showAlert(title: "Please Select payment through.", message: ALERTMESSAGE)
//                  }else{
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
                              self.tbleView.reloadData()
                          }
                          
                      }
                  }
                  
              }
          }else{
              
              self.refershCal()
              print("Select satrt and end date first.")
              
          }
          
//          }
    }
    
    func endTimeSelect(){
        if #available(iOS 13.4, *) {
            timeDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

//        if !isFixedSelected{
//          self.showAlert(title: "Please Select payment.", message: ALERTMESSAGE)
//  //        self.showAlert(title: "Please Select payment through.", message: ALERTMESSAGE)
//          }else{
          if startDate != "" && endDate != ""{
                   let days = 1
                   if startTime != ""{
                       
                       if days == 1
                       {
                           var components = DateComponents()
                           components.minute = 2
                           let startDateWithTimePlusOne = Calendar.current.date(byAdding: components, to: startDateWithTime)
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
                                  if  !self.isPaymentThrough {
                                      
                                   self.getMultipleDates()
                                      
                                  }
                                  
                               }
                           }
                       }
                       else
                       {
                           DatePickerDialog().show(controller: self, "End Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel" ,minimumDate: nil, datePickerMode: .time) {
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
                           }
                       }
                   }else{
                       print("Please select start time first.")
                       self.showAlert(title: "Please select start time first.", message: ALERTMESSAGE)
                      self.endTime = ""
                   }
               }else{
                   print("Select satrt and end date first.")
               }
//          }
    }
}

extension MNPostJobVC:UITextViewDelegate,UITextFieldDelegate,GetCallDelegateOfTextField{
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
        print(textField)
        //        textField.resignFirstResponder()
        /*if txtStartDate == textField{
            startDateSelect()
        }else if txtEndDate == textField{
            endDateSelect()
        }else if txtStartTime == textField{
            startTimeSelect()
        }else if txtEndTime == textField{
            endTimeSelect()
        }*/
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
    
extension MNPostJobVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        var dLatitude = place.coordinate.latitude
        var dLongitude = place.coordinate.longitude
        
        let arrays : NSArray = place.addressComponents as! NSArray
     
       
        
        for i in 0..<arrays.count {
            
            let dics : GMSAddressComponent = arrays[i] as! GMSAddressComponent
            let str : NSString = dics.type as NSString
        
            if (str == "country") {
                print("Country: \(dics.name)")
                
                strCountry = dics.name

            }
            else if (str == "administrative_area_level_1") {
                print("State: \(dics.name)")

            }
            else if (str == "locality") {
                print("City: \(dics.name)")
                strCity = dics.name
            }else if (str == "postal_code") {
                print("postal_code: \(dics.name)")
                strZipCode = dics.name
            }
        }
        
        
      /*  if let addressComponents = place.addressComponents {
            for component in addressComponents {
                
                print("\(component.types.contains("postal_code"))")
                print("\(component.types.contains("locality"))")
                print("\(component.types.contains("country"))")
                  
                }
            }*/
        
        
        
        strLatitude = String(dLatitude)
        strLongitude = String(dLongitude)
        self.txtJobLocation.text = place.name!
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

extension MNPostJobVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.objIndividual.count
        return arrayDates.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : PostJobHourlyTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "PostJobHourlyTableViewCell", for: indexPath) as? PostJobHourlyTableViewCell
        let dict = arrayDates[indexPath.row]
        
        cell?.txtStartTime.isHidden = true
        cell?.txtEndTime.isHidden = true

        if dict["startTime"] as? String == ""{
            cell?.txtStartTime.isHidden = false
        }
        if dict["endTime"] as? String == ""{
            cell?.txtEndTime.isHidden = false
        }
//
        cell?.lblPrice.text = "$\((Int(dict["price"] as? String ?? "0") ?? 0) * (Int(self.txtFixedPrice.text ?? "0") ?? 0))"
        cell?.lblDates.text   = dict["dates"] as? String
        cell?.btnStartTime.setTitle(dict["startTime"] as? String, for: .normal)
        cell?.btnEndTime.setTitle(dict["endTime"] as? String, for: .normal)
        cell?.btnStartTime.tag = indexPath.row
        cell?.btnEndTime.tag = indexPath.row
        
        
//        cell?.txtEndTime.tag = indexPath.row + 1000
//        cell?.txtStartTime.tag = indexPath.row
//        cell?.txtEndTime.tag = indexPath.row + 1000
//        cell?.txtStartTime.text   = dict["startTime"] as? String
//        cell?.txtStartTime.inputView = timeDatePicker
//        cell?.txtEndTime.text   = dict["endTime"] as? String
//        cell?.txtEndTime.inputView = timeDatePicker
       
//        cell?.txtEndTime.isUserInteractionEnabled = true
//        cell?.txtStartTime.isUserInteractionEnabled = true
        
        //      cell?.txtEndTime.addTarget(self, action: #selector(MNPostJobVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        cell?.delagate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //         let details = self.storyboard?.instantiateViewController(withIdentifier: "MNPostDetailVC") as! MNPostDetailVC
        //        details.strJobId = self.objIndividual[indexPath.row].id
        //        self.navigationController?.pushViewController(details, animated: true)
        
    }

  
    func delegateDidBeginEditing(strData: String, index: Int) {
   
        var startTime = Date()
        var endTime = Date()
        
        var dict = [String:Any]()
//        timeDatePicker.datePickerMode = UIDatePicker.Mode.time
        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
        formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "time")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        if strData == "Start" {

            DatePickerDialog().show(controller: self, "Start Time",doneButtonTitle:  "Done", cancelButtonTitle: "Cancel",datePickerMode: .time) { date in
                print("date: \(date)")
                
              startTime = date ?? Date()
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
                
           /*    let strEndTime = "\(dictall["dates"] as! String) \(dictall["endTime"] as! String)"
               let strStartTime = "\(dictall["dates"] as! String) \(time)"
                print("string: \(strEndTime)")
                dateFormatter.dateFormat = "MMM d, yyyy HH:mm a"
               if let fullEndDate = dateFormatter.date(from: strEndTime),
                  let fullStartDate = dateFormatter.date(from: strStartTime){
                   print(" fullSDAte: \(fullStartDate), fullEDate: \(fullEndDate)")

                   if fullStartDate < fullEndDate{
                    
                   }else{
                       print("start time invalid")
                       self.showAlert(title: ALERTMESSAGE, message: "Please Select Valid Start time.")
                   }
                   
               }*/
            }
           
            /*
             if txtFiled == "Start" {
                 let time = formatter.string(from: datePicker.date)
                 dict["startTime"] = time
                 let dictall = self.arrayDates[TagTextFiled]
                 let dates = dictall["dates"] as! String
                 let end = dictall["endTime"] as! String
                 let dateString = dictall["fullformat"] as! String
                 dict["startTime"] = time
                 dict["endTime"] = end
                 dict["dates"] = dates
                 dict["fullformat"] = dateString
                 let addDates1 = dates + " " + time
                 let addDates2 = dates +  " " + end
                 
                 print(addDates1)
                 print(addDates2)
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "dd/M/yyyy, HH:mm"
                 // let s = dateFormatter.date(from: addDates1)
                 self.arrayDates[TagTextFiled] = dict
             */
            
          
        }else{
            /*let end = formatter.string(from: timeDatePicker.date)
            let dictall = self.arrayDates[index]
            let dates = dictall["dates"] as! String
            let start = dictall["startTime"] as! String
            let dateString = dictall["fullformat"] as! String
            dict["startTime"] = start
            dict["endTime"] = end
            dict["dates"] = dates
            dict["fullformat"] = dateString
            self.arrayDates[index] = dict*/

          //  var components = DateComponents()
         //  components.minute = 2
            
//            let startDateWithTimePlusOne = Calendar.current.date(byAdding: components, to: startTime)
            DatePickerDialog().show(controller: self, "End Time",doneButtonTitle:  "Done", cancelButtonTitle: "Cancel",datePickerMode: .time) { date in
                print("date: \(date)")
                endTime = date ?? Date()
                
                
                
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

                
//                let strStartTime = "\(dictall["dates"] as! String) \(dictall["startTime"] as! String)"
//                let strEndTime = "\(dictall["dates"] as! String) \(time)"
//                print("string: \(strEndTime)")
//                dateFormatter.dateFormat = "MMM d, yyyy HH:mm a"
//                if let fullEndDate = dateFormatter.date(from: strEndTime),
//                   let fullStartDate = dateFormatter.date(from: strStartTime){
//                    print(" fullSDAte: \(fullStartDate), fullEDate: \(fullEndDate)")
//
//
//                    if fullStartDate.isSmallerThan(fullEndDate){
//                        print("End time valid")
//
//                        let dates = dictall["dates"] as! String
//                        let start = dictall["startTime"] as! String
//                        let dateString = dictall["fullformat"] as! String
//                        dict["startTime"] = start
//                        dict["endTime"] = time
//                        dict["dates"] = dates
//                        dict["fullformat"] = dateString
//
//                        print("dict: \(dict)")
//                        self.arrayDates[index] = dict
//                        let indexPath = IndexPath(item: index, section: 0)
//                        self.tbleView.reloadRows(at: [indexPath], with: .fade)
//                    }else{
//                        print("End time invalid")
//
//                        self.showAlert(title: ALERTMESSAGE, message: "Please Select Valid End time.")
//
//                    }
//                }
            }

        }
        

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
     @IBAction func startDateClick(_ sender: UIButton) {
         
         startDateSelect()
           //#DR remove code
     /*       if !isFixedSelected{
                       //textField.resignFirstResponder()
                self.showAlert(title: "Please Select payment.", message: ALERTMESSAGE)
//                self.showAlert(title: "Please Select payment through.", message: ALERTMESSAGE)
                      }else{
                var components = DateComponents()
                components.day = 1
                let startDateWithTimePlusOne = Calendar.current.date(byAdding: components, to:  Date())
                DatePickerDialog().show(controller: self, "Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: startDateWithTimePlusOne, datePickerMode: .date) {
               (date) -> Void in
               if let dt = date {
                   let formatter = DateFormatter()
                   formatter.dateFormat = self.getDateTimeFormat(param: "date")
                   //sender.setAttributedTitle(NSAttributedString(string: formatter.string(from: dt)), for: .normal)
                 self.txtStartDate.text = formatter.string(from: dt)
                self.startTime = self.txtEndDate.text!
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
        }*/
    }
       
       
       @IBAction func endDateClick(_ sender: UIButton) {
           endDateSelect()
      /*     if !isFixedSelected{
            self.showAlert(title: "Please Select payment.", message: ALERTMESSAGE)
//            self.showAlert(title: "Please Select payment through.", message: ALERTMESSAGE)
           }else{
            if !isStartDate {
                self.showAlert(title: "Please Select start date.", message: ALERTMESSAGE)
            }
            else{
                 let startDate : Date?
                   let formatter = DateFormatter()
                   formatter.dateFormat = self.getDateTimeFormat(param: "server")
                   formatter.locale = Locale(identifier: "en_US_POSIX")
                   startDate = formatter.date(from:self.startDate)
                   
                   var components = DateComponents()
                  // components.day = 1
                   let newDate = Calendar.current.date(byAdding: components, to: startDate!)
                   components = DateComponents()
                   let afteroneYearDate = Calendar.current.date(byAdding: components, to: startDate!)
                  
                   components = DateComponents()
                    if isPaymentType == true {
                        components.day = 60
                    }else{
                        components.day = 13
                    }
                    let maximumDate = Calendar.current.date(byAdding: components, to: startDate!) // 15 day
                    DatePickerDialog().show(controller: self, "End Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate:afteroneYearDate!, minimumDate:newDate,maximumDate:maximumDate, datePickerMode:.date) {
                       (date) -> Void in
                       if let dt = date {
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
            }*/
   
    }
    @IBAction func startTimeClick(_ sender: UIButton) {
        
        startTimeSelect()
    /*  if !isFixedSelected{
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
                        sender.setTitle(formatter.string(from: dt), for: .normal)
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
                            sender.setTitle(formatter.string(from: dt), for: .normal)
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
                            self.tbleView.reloadData()
                        }
                        
                    }
                }
                
            }
        }else{
            
            self.refershCal()
            print("Select satrt and end date first.")
            
        }
        
     }*///#DR remove code
    }
    
    @IBAction func endTimeClick(_ sender: UIButton) {
        
        endTimeSelect()
     /*  if !isFixedSelected{
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
                                if  !self.isPaymentThrough {
                                 self.getMultipleDates()
                                }
                                
                             }
                         }
                     }
                     else
                     {
                         DatePickerDialog().show(controller: self, "End Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel" ,minimumDate: nil, datePickerMode: .time) {
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
                         }
                     }
                 }else{
                     print("Please select start time first.")
                     self.showAlert(title: "Please select start time first.", message: ALERTMESSAGE)
                    self.endTime = ""
                 }
             }else{
                 print("Select satrt and end date first.")
             }
        }*/
    }
    func refershCal() {

        self.txtStartDate.placeholder = "MM/DD/YYYY"
        self.txtEndDate.placeholder = "MM/DD/YYYY"
        self.txtStartTime.placeholder = "HH:MM"
        self.txtEndTime.placeholder = "HH:MM"
    }
    
    
     func getCurrentDate() -> String{
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = self.getDateTimeFormat(param: "date")
          let strDate = dateFormatter.string(from: Date())
          return strDate
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
    
    func getMultipleDates() {
        
        if txtStartDate.text! != "" && txtEndDate.text! != "" && txtStartTime.text! != "" && txtEndTime.text! != ""{
            
            arrayDates = [[String:Any]]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let sdate1 = dateFormatter.date(from: self.startDate)
            let edate2 = dateFormatter.date(from: self.endDate)
            print(self.startDate)
            print(self.endDate)
            var datesBetweenArray = Date.dates(from: sdate1!, to: edate2!)
            if let lastDate = datesBetweenArray.last, lastDate != edate2 {
                    datesBetweenArray.append(edate2!)
                }
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
                dict["price"] = "0"
                arrayDates.append(dict)
                tbleView.reloadData()
                
            }
            self.selectedDaysWeekDays.removeAll()
            for i in 0..<arrayDates.count{
                if let weekdayName = getWeekdayName(from: arrayDates[i]["dates"] as! String, withFormat: "MMM dd, yyyy") {
                    print("The weekday name is: \(weekdayName)")
    //                if !selectedDaysWeekDays.contains(weekdayName){
                        selectedDaysWeekDays.append(weekdayName)
    //                }
                    
                } else {
                    print("Invalid date format")
                }
            }
            print(selectedDaysWeekDays)
            print(selectedShiftDays)
            // Array to store indexes with matching days
            var resultIndexes: [Int] = []

            // Loop through array1 with index
            for (index, day) in selectedDaysWeekDays.enumerated() {
                // Check if there is a matching day in array2
                let hasMatch = selectedShiftDays.contains { $0["day"] == day }
                
                // If there is a match, add the index to the result array
                if hasMatch {
                    resultIndexes.append(index)
                }
            }
            
            print(resultIndexes)
            totalHours = 0
            for i in 0..<arrayDates.count{
                //                            for dayDataString in selectedShiftDays{
//                print(dayString)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                
                if let start = dateFormatter.date(from: "\(arrayDates[i]["startTime"] ?? "")"),
                   let end = dateFormatter.date(from: "\(arrayDates[i]["endTime"] ?? "")") {
                    if let hours = hoursDifference(from: start, to: end) {
                        print("Hours difference: \(hours)")
                        if resultIndexes.contains(i){
                            arrayDates[i]["price"] = "\(hours)"
                            totalHours += hours
                        }
                    }
                }
            }
            print(totalHours)
            print(arrayDates)
        }
    }
}
extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        
        var dates: [Date] = []
        var date = fromDate        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
extension Collection where Iterator.Element == String {
    func joinedWithComma() -> String {
        var string = joined(separator: ", ")

        if let lastCommaRange = string.range(of: ", ", options: .backwards) {
            string.replaceSubrange(lastCommaRange, with: " and ")
        }

        return string
    }
}




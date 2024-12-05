//
//  Extension.swift
//  ShibariStudy
//
//  Created by mac on 12/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit




extension UIViewController{
    func getDateTimeFormatOn12Hours(param:String) -> String{
        if param == "date" {
            return "MMM d, yyyy"
        }else if param == "time"{
            return "h:mm a"//"HH:mm a"
        }else if param == "dateTime12"{
            return "dd-MM-yyyy h:mm a"
        }else if param == "currentDate"{
            return "dd-MM-yyyy"
        }else if param == "server"{
            return  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        }else if param == "server12"{
            return  "yyyy-MM-dd'T'h:mm a .SSS'Z'"
        }
        return "MMM d, yyyy"
    }
}


extension UIView {
    func viewCircle(view:UIView)
    {
        view.layer.borderWidth = 1
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = view.frame.height/2
        view.clipsToBounds = true
    }
    func roundedWhiteCircle(view:UIView)
    {
        view.layer.borderWidth = 2
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = view.frame.height/2
        view.clipsToBounds = true
    }
}
    extension UIButton {
    func roundCorner(button:UIButton)
    {
       // button.backgroundColor = .clear
        //button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
         button.layer.cornerRadius = button.frame.height/2
        button.layer.borderColor = UIColor.black.cgColor
    }
        func buttonBorderColor(button:UIButton)
        {
            // button.backgroundColor = .clear
            //button.layer.cornerRadius = 20
            button.layer.borderWidth = 1.0
            //  button.layer.cornerRadius = button.frame.height/2
            button.layer.borderColor = UIColor.black.cgColor
        }
    }

    extension UIViewController {
        func showErrorPopup(message: String, title: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        func showAlert(title:String , message:String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            if !(self.navigationController?.visibleViewController?.isKind(of: UIAlertController.self))! {
               present(alertController, animated: true, completion: nil)
            }
            }
       func FuncationLogout(title:String , message:String) {
            let alertController = UIAlertController(title: "", message: "Would you like to logout?", preferredStyle: .alert)
            // Create the actions
            let okAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) {
                UIAlertAction in
               // self.clickOnYesAlert()
            }
            let cancelAction = UIAlertAction(title: "YES",style: UIAlertAction.Style.destructive) {
                UIAlertAction in
                // self.clickOnNoAlert()
                self.clickOnYesAlert()
            }
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
        func FuncationDeleteAccount(title:String , message:String) {
             let alertController = UIAlertController(title: "", message: "Would you like to Delete your Account?", preferredStyle: .alert)
             // Create the actions
             let okAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) {
                 UIAlertAction in
                // self.clickOnYesAlert()
             }
             let cancelAction = UIAlertAction(title: "YES",style: UIAlertAction.Style.destructive) {
                 UIAlertAction in
                 // self.clickOnNoAlert()
//                 self.clickOnYesAlert()
             }
             // Add the actions
             alertController.addAction(okAction)
             alertController.addAction(cancelAction)
             // Present the controller
             self.present(alertController, animated: true, completion: nil)
         }
         func autoLogout(title:String , message:String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            // Create the actions
           let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
               // self.clickOnYesAlert()
            }
          //  self.clickOnYesAlert()
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
       
            MyDefaults().UserId = nil
            MyDefaults().StripeCustomerId = nil

            MyDefaults().isLogin = false
        //    let storyboard = storyBoard.init(name: "Main", bundle: nil)
//            let nav = storyBoard.Main.instantiateViewController(withIdentifier: "RootNavigationController")
//            appDelegate().window?.rootViewController = nav
        
        
//       let nextViewController = storyBoard.Main.instantiateViewController(withIdentifier: "RootNavigationController") as! RootNavigationController
//        let navigationController = UINavigationController(rootViewController: nextViewController)
//       appDelegate().window!.rootViewController = navigationController
//       
        
        let loginVC = storyBoard.Main.instantiateViewController(withIdentifier: "MNLoginVC") as! MNLoginVC
                           let navigationVC = UINavigationController(rootViewController: loginVC)
                           appDelegate().window!.rootViewController = navigationVC
        
        
        }
        func alertViewForBacktoController(title:String,message:String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                 })
                 //alert.addAction(ok)
            self.navigationController?.popViewController(animated: true)
//            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
//                 })
//                 alert.addAction(cancel)
            alert.addAction(ok)
                 DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true)
            })
        }
        func clickOnYesAlert() {
          //  UserDefaultsults().isLogin = false
            if  isConnectedToInternet() {
                self.callLogoutAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
}
        func callLogoutAPI() {

      //  ShowHud()
            ShowHud(view: self.view)
         //let otpCode = txt1.text! + txt2.text! + txt3.text! + txt4.text!
            let parameter: [String: Any] =  ["user_id":MyDefaults().UserId ?? "",
                                             "mobile_auth_token":MyDefaults().UDeviceToken ?? ""]
            debugPrint(parameter)
            HTTPService.callForPostApi(url:MNLogoutAPI , parameter: parameter) { (response) in
                debugPrint(response)

      //       HideHud()
                HideHud(view: self.view)
                if response.count != nil{
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    
                
                let loginVC = storyBoard.Main.instantiateViewController(withIdentifier: "MNLoginVC") as! MNLoginVC
                MyDefaults().UserId = nil
                MyDefaults().StripeCustomerId = nil
                MyDefaults().LoginStatus = nil
                MyDefaults().isLogin = false
                    
                UserDefaults.standard.set(false, forKey: "isLogIn")
                UserDefaults.standard.synchronize()
                    
                let navigationVC = UINavigationController(rootViewController: loginVC)
                appDelegate().window!.rootViewController = navigationVC
                self.ShowalertWhenPopUpviewController(title:ALERTMESSAGE , message:message)
                
                }else if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                    
                }
                else
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)

//                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}
                else
                    {
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
            }
        }
        func isValidEmail(email:String?) -> Bool {
            guard email != nil else { return false }
            let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
            return pred.evaluate(with: email)
        }
       
        func isValidPassword(emailStr:String) -> Bool {
           // let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

            let emailPred = NSPredicate(format:"SELF MATCHES %@", regexPassword)
            return emailPred.evaluate(with: emailStr)
           // return true
        }
       func isValidateMobileNumberLength(password:String?)-> Bool
       {
           if (password?.count)! >= 10{
               return true
           }
           else{
               showAlert(title: ALERTMESSAGE, message: "Mobile number should be 8 to 10 digit .")
               return false
           }
       }
        
        func isValidatePasswordLength(password:String?)-> Bool
        {
            if (password?.count)!   >= 8{
                return true
            }
            else{showAlert(title: ALERTMESSAGE, message: "Password must be at least 8 digits long.")
                return false
            }
        }
        func isValidateZipCodeLength(zipCode:String?)-> Bool
        {
            if (zipCode?.count)! >= 5{
                return true
            }
            else{
                showAlert(title: ALERTMESSAGE, message: "Zip code should be 5 to 8 digit .")
                return false
            }
        }
        func isValidateLLcNumberLength(llcNumber:String?)-> Bool
        {
            if (llcNumber?.count)! >= 8{
                return true
            }
            else{
                showAlert(title: ALERTMESSAGE, message: "LLC number should be 8 to 10 digit .")
                return false
            }
        }
        func isValidateSSnNumberLength(ssnNumber:String?)-> Bool
        {
            if (ssnNumber?.count)! >= 8{
                return true
            }
            else{
                showAlert(title: ALERTMESSAGE, message: "SSN number should be 8 to 10 digit .")
                return false
            }
        }
        func isValidatePasswordMatch(confirmPassword:String?,password:String)-> Bool
        {
            if password == confirmPassword{
                return true
            }
            else{
                showAlert(title: ALERTMESSAGE, message: "Password & confirm password doesn't match .")
                return false
            }
        }
        func ShowalertWhenPopUpviewController(title:String , message:String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                self.Popup()
            }
            
            alertController.addAction(okAction)

            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
        func Popup() {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
}

extension UITextField {
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: 0 , width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.darkGray.cgColor//UIColor.hexStringToUIColor(hex: "#7E8290")
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
//    func bottomLine(myTextField:UITextField){
//    var bottomLine = CALayer()
//    bottomLine.frame = CGRectMake(0.0, myTextField.frame.height - 1, myTextField.frame.width, 1.0)
//    bottomLine.backgroundColor = UIColor.whiteColor().CGColor
//    myTextField.borderStyle = UITextBorderStyle.None
//    myTextField.layer.addSublayer(bottomLine)
//    }
    func Selecedunderlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: 0 , width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
extension UINavigationController {
    func NavigationBackButton(){
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back"), for: .normal)
        // button.setTitle("Categories", for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(backButton), for: .touchUpInside)
        // button.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    @objc func backButton()  {
        self.navigationController?.popViewController(animated: true)
    }
}
extension UIDatePicker {
    func set18YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
}
extension String {
    var url:URL?{
        return URL(string: self)
    }
    var thumbnailImage:String {
        return "http://img.youtube.com/vi/\(self)/0.jpg"
    }
    var youtubeVideo: String {
        return "http://www.youtube.com/embed/\(self)"
    }
    func getYoutubeId(youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
    var isValidURL:Bool {
        if let _url = self.url {
            return _url.scheme != ""
        }
        return false
    }
    
    func addBaseURL(_ theURL:String) -> String {
        if self.isValidURL { return self }
        
        // No check for now, just prepending the base url as passed
        return theURL + self
    }
    
    var stringByDecodingURL:String {
        let result = self
            .replacingOccurrences(of: "+", with: " ")
            .removingPercentEncoding
        return result!
    }
}
public extension UIColor {
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
//    func hexaCGcolor(hexString:String) -> CGColor
//    {
//      if let rgbValue = UInt(hexString, radix: 16) {
//        let red   =  CGFloat((rgbValue >> 16) & 0xff) / 255
//        let green =  CGFloat((rgbValue >>  8) & 0xff) / 255
//        let blue  =  CGFloat((rgbValue      ) & 0xff) / 255
//        return UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
//      } else {
//        return UIColor.black.cgColor
//      }
//    }
}

extension UILabel {
    
    // Pass value for any one of both parameters and see result
//    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
//
//        guard let labelText = self.text else { return }
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = lineSpacing
//        paragraphStyle.lineHeightMultiple = lineHeightMultiple
//
//        let attributedString:NSMutableAttributedString
//        if let labelattributedText = self.attributedText {
//            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
//        } else {
//            attributedString = NSMutableAttributedString(string: labelText)
//        }
//
//        // Line spacing attribute
//        attributedString.addAttribute(NSAttrNSAttributedString.KeyraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
//
//        self.attributedText = attributedString
//    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    func isValidPassword() -> Bool {
        let regularExpression = regexPassword
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)

        return passwordValidation.evaluate(with: self)
    }
    
    
    func convertDateFormaterDate(_ strdate: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let day = dateFormatter.string(from: date!)
        
        return day
    }
    func convertDateFormaterDateCalender(_ strdate: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let day = dateFormatter.string(from: date!)
        return day
    }
    
    
    func convertDateFormaterDayDateCalender(_ strdate: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        let day = dateFormatter.string(from: date!)
        return day
    }
    
      func convertDateFormaterFoeOnlyDate1(_ strdate: String) -> String{
              
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              let date = dateFormatter.date(from: strdate)
              dateFormatter.dateFormat = "MMM dd, yyyy"
              return  dateFormatter.string(from: date!)
          }
      func convertDateFormaterForAll1(_ strdate: String) -> [String]
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
       func convertTimeFormater1(_ dateAsString: String) -> String
       {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "HH:mm:ss"
           let date = dateFormatter.date(from: dateAsString)
           dateFormatter.dateFormat = "hh:mm a"
           let Date12 = dateFormatter.string(from: date!)
           return Date12
       }
    
}

extension UINavigationItem {
//    func addSettingButtonOnRight(){
//        let button = UIButton(type: .custom)
//        button.setTitle("setting", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
//        button.layer.cornerRadius = 5
//        button.backgroundColor = UIColor.gray
//        button.frame = CGRect(x: 0, y: 0, width: 100, height: 25)
//        button.addTarget(self, action: #selectUIControl.Eventge);, for: UIConUIControl.EventtUpInside)
//        let barButton = UIBarButtonItem(customView: button)
//
//        self.rightBarButtonItem = barButton
//    }
//
//    @objc func gotSettingPage(){
//
//    }
}



extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
extension String {
    func LocalizableString(localization:String) -> String {
        let path = Bundle.main.path(forResource: localization, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
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
   
//    public func toPhoneNumber() -> String {
//        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "$1-$2-$3", options: .regularExpression, range: nil)
//    }
}
extension UIViewController {
    func presentOnRoot(`with` viewController : UIViewController){
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
    }
    
        func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for (index, title) in actionTitles.enumerated() {
                let action = UIAlertAction(title: title, style: .default, handler: actions[index])
                alert.addAction(action)
            }
            self.present(alert, animated: true, completion: nil)
        }
    func extensionChangeDateFormat(_ dateAsString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
    }
    func convertDateFormater1(_ strdate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
    func convertMMMDDYYYYTOYYYYMMDD(_ strdate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
    }
    func convertMMMDDYYYYTOYYYYMMDDWithTime(_ strdate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        return  dateFormatter.string(from: date!)
    }
//    func ConvertAndAppendDateTime(_ strdate: String) -> Date{
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm"
//        let date = dateFormatter.date(from: strdate)
//       // dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm"
//       // return  dateFormatter.string(from: date!)
//       return dateFormatter.date(from:date)
//
//
//    }
    func convertDateFormater24format(_ strdate: String) -> [String]
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
    func CampareTwoDate(dateStart:Date,dateEnd:Date) {
        switch dateStart.compare(dateEnd) {
        case .orderedAscending     :   print("Date A is earlier than date B")
        case .orderedDescending    :   print("Date A is later than date B")
        case .orderedSame          :   print("The two dates are the same")
        case .orderedAscending:
            print("Date A is earlier than date B")
        case .orderedSame:
             print("The two dates are the same")
        case .orderedDescending:
            print("Date A is later than date B")
        }
    }
    func dateDiff(_ dateStr:String, DateFormat dateFormate: String) -> String {
        let f:DateFormatter = DateFormatter()
            f.timeZone = TimeZone(abbreviation: "UTC")
        //f.timeZone = NSTimeZone.local
        f.dateFormat = dateFormate
        
        let now = f.string(from: NSDate() as Date)
        let startDate = f.date(from: dateStr)
        let endDate = f.date(from: now)
        
        let dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: startDate!, to: endDate!)
        
        let weeks   = dateComponents.weekOfMonth ?? 0
        let days    = dateComponents.day ?? 0
        let hours   = dateComponents.hour ?? 0
        let min     = dateComponents.minute ?? 0
        let sec     = dateComponents.second ?? 0
        
        var timeAgo = ""
        
        if (sec > 0){
            if (sec > 1) {
                timeAgo = "\(sec) Sec Ago"
            } else {
                timeAgo = "\(sec) Sec Ago"
            }
       // timeAgo = stringFromNSDate(startDate!, dateFormate: "MMM dd, yyyy h:mm a")
            }
        if (sec < 0){
             if (sec > 1) {
                 timeAgo = "\(sec) Sec Ago"
             } else {
                // timeAgo = "\(sec) Sec Ago"
                
                timeAgo = self.currentTime(dateStr)
             }
        // timeAgo = stringFromNSDate(startDate!, dateFormate: "MMM dd, yyyy h:mm a")
             }
        if (min > 0){
            if (min > 1) {
                timeAgo = "\(min) Mins Ago"
            } else {
                timeAgo = "\(min) Min Ago"
            }
        }
        
        if(hours > 0){
            if (hours > 1) {
                timeAgo = "\(hours) Hours Ago"
            } else {
                timeAgo = "\(hours) Hour Ago"
            }
        }
        
        if (days > 0) {
            if (days > 1) {
               // timeAgo = "\(days) Days Ago"
                timeAgo = stringFromNSDate(startDate!, dateFormate: "MMM dd, yyyy h:mm a")
            } else {
                timeAgo = "\(days) Day Ago"
            }
        }
        
        if(weeks > 0){
            timeAgo = stringFromNSDate(startDate!, dateFormate: "MMM dd, yyyy h:mm a")
        }
        
        //print("timeAgo is===> \(timeAgo)")
        return timeAgo;
    }
    func currentTime(_ strdate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strdate)
       
        dateFormatter.dateFormat = "hh:mm a"
        let strTime = dateFormatter.string(from: date!)
        return strTime
    }
    
}
extension UIScrollView {

    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }

    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }

}
extension UIView {
    func roundCornersBottomSide(corners:UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      self.layer.mask = mask
    }
}
extension Date {

    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}

extension UIButton{
    func roundedButtonOnlyLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topLeft],
            cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedButtonOnlyRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topRight],
            cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

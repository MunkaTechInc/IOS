//
//  Global.swift
//  My
//  Created by Hitaishin on 13/06/16.
//  Copyright © 2016 Hitaishin. All rights reserved.
//
import UIKit
import SystemConfiguration
import RSLoadingView


var viewControllerInstance : AnyObject!
var badgeCartViewController : AnyObject!
var loadingView : RSLoadingView!
var alertController: UIAlertController!
var blurEffectView: UIVisualEffectView!

class Global: NSObject {
    
    class var sharedInstance: Global {
        struct Static {
            static let instance: Global = Global()
        }
        return Static.instance
    }
        
    // MARK: - Round Methods.

    static func roundRadius(_ imageView: UIImageView)
    {
        imageView.layer.cornerRadius = (imageView.frame.size.height / 2 + imageView.frame.size.width / 2) / 2
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
    }
    
    static func labelRoundRadius(_ labelView: UILabel)
    {
        labelView.layer.cornerRadius = (labelView.frame.size.height / 2 + labelView.frame.size.width / 2) / 2
        labelView.layer.masksToBounds = true
        labelView.clipsToBounds = true
    }
    
    static func buttonCornerRadius(_ sender: AnyObject)
    {
        let btn: UIButton = (sender as! UIButton)
        btn.layer.cornerRadius = 5
        // this value vary as per your desire
        btn.clipsToBounds = true
    }
    
    static func viewCornerRadius(_ view: UIView) {
        view.layer.cornerRadius = 5
        // this value vary as per your desire
        view.clipsToBounds = true
    }
    
    //MARK: - Add Dashed Border Button Methods
    
    class func addDashedBorder(_ dashView: UIView, AndBorderColor borderColor:UIColor, AndRoundRadius radius:Bool) {
        let color = borderColor.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = dashView.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        
        if radius {
            shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
            
        } else {
            shapeLayer.path = UIBezierPath(rect: shapeRect).cgPath
        }
        
        dashView.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - Progress Loader Methods.
    
    class func showGlobalProgressLoader() {
        Global.showWhiteBlankView(UIApplication.shared.keyWindow!)
        RSLoadingView.hideFromKeyWindow()
        loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        loadingView.sizeInContainer = CGSize(width: 120, height: 120)
        loadingView.shouldTapToDismiss = false
        //    loadingView.variantKey = "inAndOut"
        //    loadingView.speedFactor = 2.0
        //     loadingView.lifeSpanFactor = 2.0
        loadingView.dimBackgroundColor = UIColor.black.withAlphaComponent(0.2)
      //  loadingView.mainColor = Global.hexStringToUIColor(AppColor.kkDarkBlue)
        loadingView.showOnKeyWindow()
    }
    
    class func dismissGlobalLoader() {
        Global.removeWhiteBlankView()
        RSLoadingView.hideFromKeyWindow()
    }
    
    class func showWhiteBlankView(_ selectedView:UIView)
    {
        if blurEffectView != nil {
            blurEffectView.removeFromSuperview()
            blurEffectView = nil
        }
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = selectedView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectedView.addSubview(blurEffectView)
    }
    
    class func removeWhiteBlankView()
    {
        if blurEffectView != nil {
            blurEffectView.removeFromSuperview()
            blurEffectView = nil
        }
    }
    // MARK: - Creates a UIColor from a Hex string.
    
    static func hexStringToUIColor (_ hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
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
    
    static func gradientColor(_ colorSet:[CGColor], andView viewFrame:CGRect) -> CAGradientLayer
    {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = viewFrame
        
        gradientLayer.colors = colorSet
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        return gradientLayer
    }
    
    static func createGradientImage(_ layer:CALayer) -> UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(layer.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK: - Global alert Methods
    
    static func showAlertMessage(_ strTitle: String, andMessage strMessage: String, GlobalAlert isGlobal:Bool = false)
    {
        if isGlobal
        {
            if alertController != nil {
                alertController.dismiss(animated: true, completion: nil)
                alertController = nil
            }
            alertController = UIAlertController(title:strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
            
            let ok: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(ok)
            
            alertController.view.layer.shadowColor = UIColor.black.cgColor
            alertController.view.layer.shadowOpacity = 0.8
            alertController.view.layer.shadowRadius = 5
            alertController.view.layer.shadowOffset = CGSize(width: 0, height: 0)
            alertController.view.layer.masksToBounds = false
            
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindow.Level.alert + 1
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController!.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alertC: UIAlertController = UIAlertController(title:strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
            
            let ok: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertC.addAction(ok)
            
            alertC.view.layer.shadowColor = UIColor.black.cgColor
            alertC.view.layer.shadowOpacity = 0.8
            alertC.view.layer.shadowRadius = 5
            alertC.view.layer.shadowOffset = CGSize(width: 0, height: 0)
            alertC.view.layer.masksToBounds = false
            
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindow.Level.alert + 1
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController!.present(alertC, animated: true, completion: nil)
        }
    }
    
    static func setView(_ view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    //MARK: - Date and Time Methods
    
    // Function to get current date time of iphone
    static func getCurrentDateTime() -> String
    {
        let date: Date = Date()
        let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)       
        let unitFlags: NSCalendar.Unit = [.year, .month, .weekday, .day, .hour, .minute, .second]
        let dateComponents: DateComponents = (calendar as NSCalendar).components(unitFlags, from: date)
        let year: Int = dateComponents.year!
        let month: Int = dateComponents.month!
        let day: Int = dateComponents.day!
        let hour: Int = dateComponents.hour!
        let minute: Int = dateComponents.minute!
        let second: Int = dateComponents.second!
        let currentDateTime: String = "\(Int(year))-\(Int(month))-\(Int(day)) \(Int(hour)):\(Int(minute)):\(Int(second))"
        return currentDateTime
    }
    
    static func stringFromNSDate(_ date: Date, dateFormate: String) -> String
    {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = dateFormate
        let formattedDate: String = dateFormatter.string(from: date)
        return formattedDate
        
    }
    
    static func nsdateFromString(_ dateString: String, dateFormate: String) -> Date {
        var date: Date? = nil
        if Global.stringExists(dateString)
        {
            //date formatter for the above string
            let dateFormatterWS: DateFormatter = DateFormatter()
            dateFormatterWS.dateFormat = dateFormate
            date = dateFormatterWS.date(from: dateString)
            //NSLog(@"Date %@",date);
            return date!
        }
        let returnObject: Date?  = nil
        return returnObject!
    }
    
    // converts date format from source to target format
    static func convertDateFormat(_ dateString: String, sourceFormate: String, targetFormate: String) -> String
    {
        if Global.getStringValue(dateString as AnyObject) != ""
        {
            if dateString == "0000-00-00 00:00:00" || dateString == "0000-00-00"
            {
                return ""
            }
            else
            {
                //date formatter for the above string
                let dateFormatterWS: DateFormatter = DateFormatter()
                dateFormatterWS.dateFormat = sourceFormate
                let date: Date = dateFormatterWS.date(from: dateString)!
                //date formatter that you want
                let dateFormatterNew: DateFormatter = DateFormatter()
                dateFormatterNew.dateFormat = targetFormate
                let stringForNewDate: String = dateFormatterNew.string(from: date)
                //NSLog(@"Date %@",stringForNewDate);
                return stringForNewDate
            }
        }
        else
        {
            return ""
        }
    }
    
    
    //Time zone methods
    ////////******** ///////////////////
    
    //   var badgeCartViewController: AnyObject
    //   var viewControllerInstance : AnyObject
    
    static func timezoneStringFromTimezone(_ timeZone: TimeZone) -> String {
        let seconds: Int = timeZone.secondsFromGMT()
        NSLog("TZ : %@ : Seconds %ld", timeZone.abbreviation()!, Int(seconds))
        let h: Int = Int(seconds) / 3600
        let m: Int = Int(seconds) / 60 % 60
        var strGMT: String = ""
        if h >= 0 {
            strGMT = String(format: "+%02d:%02d", h, m)
        }
        else {
            strGMT = String(format: "%03d:%02d", h, m)
        }
        var stringGMT: String = "GMT "
        stringGMT = stringGMT + strGMT
        return stringGMT
    }
    
    //MARK: - Start date and End Date Validation
    
    static func isEndDateIsSmallerThanStartDate(_ checkEndDate: Date, StartDate startDate: Date) -> Bool {
        let enddate: Date = checkEndDate
        let distanceBetweenDates: TimeInterval = enddate.timeIntervalSince(startDate)
        let secondsInMinute: Double = 60
        let secondsBetweenDates: Double = distanceBetweenDates / secondsInMinute
        if secondsBetweenDates == 0 {
            return true
        }
        else if secondsBetweenDates < 0 {
            return true
        }
        else {
            return false
        }
    }
    
    static func isEndDateIsSmallerThanCurrent(_ checkEndDate: String, DateFormat dateFormate: String) -> Bool {
        //  NSString *s=@"2015-08-12";
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = dateFormate
        let enddate: Date = dateFormat.date(from: checkEndDate)!
        let myString: String = dateFormat.string(from: Date())
        let currentdate: Date = dateFormat.date(from: myString)!
        switch currentdate.compare(enddate) {
        case ComparisonResult.orderedAscending:
            return true
        case ComparisonResult.orderedSame:
            return true
        case ComparisonResult.orderedDescending:
            return false
        }
    }
    
    class func dateDiff(_ dateStr:String, DateFormat dateFormate: String) -> String {
        let f:DateFormatter = DateFormatter()
        f.timeZone = NSTimeZone.local
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
                timeAgo = "\(days) Days Ago"
            } else {
                timeAgo = "\(days) Day Ago"
            }
        }
        
        if(weeks > 0){
            timeAgo = Global.stringFromNSDate(startDate!, dateFormate: "MM/dd/yyyy")
        }
        
        //print("timeAgo is===> \(timeAgo)")
        return timeAgo;
    }
    
    
    //MARK: - User Data form NSUserDefaults
    
    //////////******** ///////////////////
    // Get the User Data form NSUserDefaults

    static func getStringValueFromUserDefaults(_ key:String) -> String {
        let str : String = Global.getStringValue(UserDefaults.standard.string(forKey: key) as AnyObject)
        return str
    }
    
    static func getValueFromUserDefaults(_ key:String) -> AnyObject {
        let obj = UserDefaults.standard.string(forKey: key) as AnyObject
        return obj
    }
    
    //MARK: - Common Back Button Methods
    
    //////////******** ///////////////////
    //Common Back Button for all Views
    
    class func backButtonClose(_ sender: UIViewController)
    {
        viewControllerInstance = sender
        let backBtn: UIButton = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let backBtnImage: UIImage = #imageLiteral(resourceName: "ic_exit")
        backBtn.setImage(backBtnImage, for: UIControl.State())
        backBtn.addTarget(self, action: #selector(Global.goback), for: UIControl.Event.touchUpInside)
        
        let backButton: UIBarButtonItem = UIBarButtonItem(customView: backBtn)
        ((viewControllerInstance as! UIViewController)).navigationItem.leftBarButtonItem = backButton
    }
    
    @objc class func goback() {
        ((viewControllerInstance as! UIViewController)).navigationController!.popViewController(animated: true)
    }
        
    //MARK: - Json Conversion Methods

    class func arrayToJsonStr(_ object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return ""
    }
    
    class func jsonStrToObject(_ jsonText: String) -> Any? {
        var dictonary:[String:AnyObject]?
        
        if let data = jsonText.data(using: String.Encoding.utf8) {
            do {
                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                return dictonary
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    class func openUrlInBrowser(_ urlStr : String)
    {
        guard let url = URL(string: urlStr) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    // MARK: - Common Logout Methods.
    
//    class func logout(_ viewC : UIViewController)
//    {
//        UserDefaults.standard.setValue("0", forKey: Constants.kkIsLogin)
//        UserDefaults.standard.synchronize()
//        
//        UINavigationBar.appearance().tintColor = UIColor.white
//        // change navigation item title color
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: FontNames.Avenir.Medium, size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white]
//
//        let loginViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        let selectUserNav: UINavigationController = UINavigationController(nibName: "LoginNavigationController", bundle: nil)
//        selectUserNav.setViewControllers([loginViewController], animated: true)
//        
//        if viewC.view.window != nil
//        {
//            UIView.transition(with: viewC.view.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
//                viewC.view.window?.rootViewController = selectUserNav
//            }, completion: { completed in
//                // maybe do something here
//            })
//        }
//        else
//        {
//            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
//            topWindow.rootViewController = UIViewController()
//            topWindow.windowLevel = UIWindow.Level.alert + 1
//            topWindow.makeKeyAndVisible()
//            UIView.transition(with: topWindow, duration: 0.3, options: .transitionCrossDissolve, animations: {
//                viewC.view.window?.rootViewController = selectUserNav
//            }, completion: { completed in
//                // maybe do something here
//            })
//        }
//    }
    
    //MARK: - Gesture Button Methods
    
    class func endEditingButton(_ sender: UIViewController)
    {
        viewControllerInstance = sender
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(Global.handleSingleTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.cancelsTouchesInView = false
        ((viewControllerInstance as! UIViewController)).view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc class func handleSingleTap() {
        ((viewControllerInstance as! UIViewController)).view.endEditing(true)
    }
    
    //MARK: - Get Url Methods
    
    //Get Url from String type parameter
    
    static func getURLFromString(_ str: String) -> String {
        let urlStr: String = str.replacingOccurrences(of: " ", with: "%20")
        //    let encoded : String = urlStr.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        return urlStr
    }
    
    static func base64Decoded(_ str : String) -> String {
        return String(data:  Data(base64Encoded: str)!, encoding: .utf8)!
    }
    
    static func makePhoneCall(_ phone:String)
    {
        //Your awesome code.
        guard let number = URL(string: "telprompt://" + phone) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            if let url = URL(string: "telprompt://\(phone)") {
                UIApplication.shared.openURL(url)
            }
        }
    }
    //MARK: - Image Scalling Methods
    
    static func imageWithImage(_ image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Creates a circular outline image.
    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        // Inset the rect to account for the fact that strokes are
        // centred on the bounds of the shape.
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK: - String Methods
    
    /// Trim for String
    static func Trim(_ value: String) -> String {
        let value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return value
    }
    
    // checks whether string value exists or it contains null or null in string
    static func stringExists(_ str: String) -> Bool {
        var strString : String? = str
        
        if strString == nil {
            return false
        }
        
        if strString == String(describing: NSNull()) {
            return false
        }
        if (strString == "<null>") {
            return false
        }
        if (strString == "(null)") {
            return false
        }
        strString = Global.Trim(str)
        if (str == "") {
            return false
        }
        if strString?.count == 0 {
            return false
        }
        return true
    }
    
    // returns string value after removing null and unwanted characters
    
    static func getStringValue(_ str: AnyObject) -> String {
        if str is NSNull {
            return ""
        }
        else  if str is String
        {
            return str as! String
        }
        else if str is Double || str is Float || str is NSNumber || str is Int
        {
            return "\(str)"
            // return String(str as! Double)
        }
        else
        {
            var strString : String? = str as? String
            if Global.stringExists(strString!) {
                strString = strString!.replacingOccurrences(of: "\t", with: " ")
                strString = Global.Trim(strString!)
                if (strString == "{}") {
                    strString = ""
                }
                if (strString == "()") {
                    strString = ""
                }
                if (strString == "null") {
                    strString = ""
                }
                return strString!
            }
            return ""
        }
    }
    
    static func getBadgeValue(_ str: AnyObject) -> String {
        if str is NSNull {
            return "0"
        }
        else  if str is String
        {
            return str as! String
        }
        else if str is Double || str is Float || str is NSNumber || str is Int
        {
            return "\(str)"
            // return String(str as! Double)
        }
        else
        {
            var strString : String? = str as? String
            if Global.stringExists(strString!) {
                strString = strString!.replacingOccurrences(of: "\t", with: " ")
                strString = Global.Trim(strString!)
                if (strString == "{}") {
                    strString = "0"
                }
                if (strString == "()") {
                    strString = "0"
                }
                if (strString == "null") {
                    strString = "0"
                }
                return strString!
            }
            return "0"
        }
    }
    
    //Method for checking characters count
    static func checkTextFieldCount(_ textField: UITextField, Range range: NSRange, replacementString string: String, MaxCount count:Int) -> Bool {
        var tempCount : Int = count - 1
        if (textField.text?.count)! > tempCount &&  range.length == 0
        {
            return false
        }
        else
        {
            if tempCount == 0
            {
               tempCount = 1
            }
            if string.count > tempCount
            {
                let index = string.index((string.startIndex), offsetBy: tempCount)
                textField.text = String(string[..<index])
                return false
            }
            else
            {
                if ((textField.text?.count)! + string.count) > tempCount && string != "" {
                    let endIndex : Int = count - (textField.text?.count)!
                    let index = string.index((string.startIndex), offsetBy: endIndex)
                    textField.insertText(String(string[..<index]))
                    return false
                }
            }
        }
        return true
    }
    static func checkTextViewCount(_ textView: UITextView, Range range: NSRange, replacementString text: String, MaxCount count:Int) -> Bool {
        
        let tempCount : Int = count - 1
        
        if textView.text?.count == 0 && text == " "
        {
            return false
        }
        
        if (textView.text?.count)! > tempCount &&  range.length == 0
        {
            return false
        }
        else
        {
            if text.count > tempCount
            {
                let index = text.index((text.startIndex), offsetBy: tempCount)
                textView.insertText(String(text[..<index]))
                return false
            }
            else
            {
                if ((textView.text?.count)! + text.count) > tempCount && text != "" {
                    let endIndex : Int = count - (textView.text?.count)!
                    let index = text.index((text.startIndex), offsetBy: endIndex)
                    textView.insertText(String(text[..<index]))
                    return false
                    
                } else {
                    return true
                }
            }
        }
    }
    
    //MARK: - Image Scalling Methods
    
    class func compressImage(_ image: UIImage) -> UIImage
    {
        let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))
        let imageName = "img_\(currentTimeStamp).jpg"
        
        let documentDirectory : NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!  as NSString
        // getting local path
        let localPath:String = documentDirectory.appendingPathComponent(imageName) as String
        
        let imageData : Data = image.jpegData(compressionQuality: 0.25)!
        
        do {
            try imageData.write(to: URL(fileURLWithPath: localPath as String), options: .atomic)
        } catch {
            print(error)
        }
        
        let imageURL = URL(fileURLWithPath: documentDirectory as String).appendingPathComponent(imageName)
        let compressImage : UIImage = UIImage(contentsOfFile: imageURL.path)!
        
        return compressImage
    }
    
    class func scale(_ image: UIImage, maxWidth: Int, maxHeight: Int) -> UIImage {
        let imgRef: CGImage? = image.cgImage
        let width: CGFloat = CGFloat(imgRef!.width)
        let height: CGFloat = CGFloat(imgRef!.height)
        if Int(width) <= maxWidth && Int(height) <= maxHeight {
            return image
        }
        let transform = CGAffineTransform.identity
        var bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: width, height: height)
        if Int(width) > maxWidth || Int(height) > maxHeight {
            let ratio: CGFloat = width / height
            if ratio > 1 {
                bounds.size.width = CGFloat(maxWidth)
                bounds.size.height = bounds.size.width / ratio
            }
            else {
                bounds.size.height = CGFloat(maxHeight)
                bounds.size.width = bounds.size.height * ratio
            }
        }
        let scaleRatio: CGFloat = bounds.size.width / width
        UIGraphicsBeginImageContext(bounds.size)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: scaleRatio, y: -scaleRatio)
        context?.translateBy(x: 0, y: -height)
        context?.concatenate(transform)
        UIGraphicsGetCurrentContext()?.draw(imgRef!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: width, height: height))
        let imageCopy: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageCopy!
    }
    
    //MARK:- Set Images In Map Marker
//    static func userImageForAnnotation(_ userImageURL: String, pinImage: UIImage, placeholderImage: UIImage) -> UIImage
//    {
//        if userImageURL == ""
//        {
//            let iconView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(45), height: CGFloat(58)))
//            iconView.image = pinImage
//            
//            let subIconView = UIImageView(frame: CGRect(x: CGFloat(2.5), y: CGFloat(2.5), width: CGFloat(40), height: CGFloat(40)))
//            subIconView.image = placeholderImage
//            Global.roundRadius(subIconView)
//            subIconView.clipsToBounds = true
//            subIconView.layer.masksToBounds = true
//            
//            iconView.addSubview(subIconView)
//            UIGraphicsBeginImageContextWithOptions(iconView.bounds.size, false, UIScreen.main.scale)
//            iconView.layer.render(in: UIGraphicsGetCurrentContext()!)
//            let icon: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            
//            return icon!
//        }
//        else
//        {
//            let iconView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(45), height: CGFloat(58)))
//            iconView.image = pinImage
//            
//            let subIconView = UIImageView(frame: CGRect(x: CGFloat(2.5), y: CGFloat(2.5), width: CGFloat(40), height: CGFloat(40)))
//            let image : String = APPURL.BaseURL + userImageURL
//            _ = NSURL(string: Global.getURLFromString(image))
//            _ = placeholderImage
//            //subIconView.af_setImage(withURL: URL as! URL, placeholderImage: placeholderImage)
//            Global.roundRadius(subIconView)
//            subIconView.clipsToBounds = true
//            subIconView.layer.masksToBounds = true
//            
//            iconView.addSubview(subIconView)
//            UIGraphicsBeginImageContextWithOptions(iconView.bounds.size, false, UIScreen.main.scale)
//            iconView.layer.render(in: UIGraphicsGetCurrentContext()!)
//            let icon: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            
//            return icon!
//        }
//    }
    
    //MARK: - Shopping Cart Methods
    class func setAddToCardWithBadge(_ sender: UIViewController)
    {/*
        badgeCartViewController=sender;
        
        //Property
        var cartBarbuttonItem:MIBadgeButton?
        
        cartBarbuttonItem = MIBadgeButton(frame: CGRectMake(0, 0, 32, 32))
        cartBarbuttonItem?.initWithFrame(frame: CGRectMake(0, 0, 32, 32), withBadgeString: "0", withBadgeInsets:  UIEdgeInsetsMake(10, 10, 0, 15))
        cartBarbuttonItem?.setImage(#imageLiteral(resourceName: "ic_notification"), forState: .Normal)
        cartBarbuttonItem!.addTarget(self, action: #selector(Global.shoppingCartClick), forControlEvents: .TouchUpInside)
        if NSUserDefaults.standardUserDefaults().integerForKey("badgeCount") > 0
        {
            cartBarbuttonItem?.badgeString = NSUserDefaults.standardUserDefaults().valueForKey("badgeCount") as? String
        }
        else
        {
            cartBarbuttonItem?.badgeString = "0"
        }
        let barButton : UIBarButtonItem = UIBarButtonItem(customView: cartBarbuttonItem!)
        
        ((badgeCartViewController as! UIViewController)).navigationItem.rightBarButtonItem = barButton
        */
    }
    
    //MARK: - Internet Connection Checking Methods
    
    class func isInternetAvailable() -> Bool {
        
        if alertController != nil {
            alertController.dismiss(animated: true, completion: nil)
            alertController = nil
        }
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    //MARK: - Reload Table View data with animation Methods
    
   /* class func reloadTableViewDataAnimated(_ tableView: UITableView){
        UIView.transition(with: tableView, duration: 0.55, options: .transitionCrossDissolve, animations:
            { () -> Void in
                tableView.reloadData()
        }, completion: nil);
    }*/
    
    // Collection View Reload data
    class func reloadCollectionViewDataAnimated(_ collectionView: UICollectionView){
        UIView.transition(with: collectionView, duration: 0.55, options: .transitionCrossDissolve, animations:
            { () -> Void in
                collectionView.reloadData()
        }, completion: nil);
    }
    
    //MARK: - Get text height
    
    class func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height + 40
    }
    
    class func heightForLabel(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height + 10
    }
    
    class func widthForLabel(_ text:String, font:UIFont, height:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.width + 10
    }
    
    class func makeBlurImage(_ targetView:UIView?)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetView!.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        targetView?.addSubview(blurEffectView)
    }
    
    //MARK: - Valid Email address Methods
    
    class func validateEmail(_ enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    //MARK: - Validation for Password
    
    // *** Validation for Password ***
    
    // "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$" --> (Minimum 8 characters at least 1 Alphabet and 1 Number)
    // "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,16}$" --> (Minimum 8 and Maximum 16 characters at least 1 Alphabet, 1 Number and 1 Special Character)
    // "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$" --> (Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number)
    // "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}" --> (Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)
    // "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,10}" --> (Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)
    
    //
    
    class func isValidPassword(_ candidate: String) -> Bool {
        let ValidationExpression = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,30}$"
        return NSPredicate(format: "SELF MATCHES %@", ValidationExpression).evaluate(with: candidate)
    }
    
    class func containsOnlyLetters(_ candidate: String) -> Bool {
        let ValidationExpression = "^[A-Za-z]+$"
        return NSPredicate(format: "SELF MATCHES %@", ValidationExpression).evaluate(with: candidate)
    }
    
    class func containsOnlyNumbers(_ candidate: String) -> Bool {
        let ValidationExpression = "-?\\d+(.\\d+)?"
        return NSPredicate(format: "SELF MATCHES %@", ValidationExpression).evaluate(with: candidate)
    }
    
    class func containsLettersAndNumber(_ Input:String) -> Bool {
        let myCharSet=CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let output: String = Input.trimmingCharacters(in: myCharSet.inverted)
        let isValid: Bool = (Input == output)
        print("\(isValid)")
        
        return isValid
    }
    
    class func isValidUsername(_ username : String) -> Bool{
        if username.count > 7 && username.count < 31{
            let regex =  "^[a-z]([a-z0-9]*[-_][a-z0-9][a-z0-9]*)$"
            
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", regex)
            return passwordTest.evaluate(with: username)
        }else{
            return false
            
        }
    }
    
    class func firstLetter(_ str:String) -> String? {
        guard let firstChar = str.first else {
            return nil
        }
        return String(firstChar)
    }
    
    class SegueFromLeft: UIStoryboardSegue {
        override func perform() {
            let src = self.source
            let dst = self.destination
            
            src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
            dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
            
            UIView.animate(withDuration: 0.25,
                           delay: 0.0,
                           options: .curveEaseInOut,
                           animations: {
                            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
            },
                           completion: { finished in
                            src.present(dst, animated: false, completion: nil)
            }
            )
        }
    }

}


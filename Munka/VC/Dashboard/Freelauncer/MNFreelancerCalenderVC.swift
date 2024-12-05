//
//  MNFreelancerCalenderVC.swift
//  Munka
//
//  Created by Amit on 20/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNFreelancerCalenderVC: UIViewController,JTCalendarDelegate {
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
    //  @IBOutlet var calendarManager : JTCalendarManager!
    var calendarManager : JTCalendarManager!
    var todayDate = NSDate()
    var minDate = NSDate()
    var maxDate = NSDate()
    var dateSelected = NSDate()
    var strTodayDate = ""
    var calenderData = [ModelCalenderJobList]()
    var arrayAvailabilityDates = [String]()
    var monthYear = ""
    var strSelectedDateTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Calendar"
        calendarManager = JTCalendarManager.init()
        createMinAndMaxDate()
        calendarManager.menuView = calendarMenuView
        calendarManager.contentView = calendarContentView
        let currentDate = Date()
        calendarManager.setDate(currentDate)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        monthYear = formatter.string(from: date)
        
    }
        func calendarBuildMenuItemView(calendar: JTCalendarManager!) -> UIView! {
            let label = UILabel.init(frame: .zero)
            label.textAlignment = .center
            //label.font = <your font here>
            return label
        }
    
//        public func calendar(_ calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: Date!) {
//            guard let view = menuItemView as? UILabel else {
//                return;
//            }
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMM,yyyy"
//            let date = dateFormatter.date(from: getMonthYearFromDate)
//
//            //view.text = "22 Des"
//            let df = DateFormatter()
//            df.dateFormat = "MMM,yyyy"
//            let now = df.string(from: date!)
//            view.text = now
//
//        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        if  isConnectedToInternet() {
            // viewInternetConnection.isHidden = false
            self.callServiceGetCalenderDataAPI()
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    
    var getMonthYearFromDate: String!
    {
        let mydate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        let strMonth = dateFormatter.string(from: mydate)
        return strMonth
    }
    func createMinAndMaxDate(){
        todayDate = NSDate()
        minDate = calendarManager.dateHelper.add(to: todayDate as Date?, months: -6) as NSDate
        maxDate = calendarManager.dateHelper.add(to: todayDate as Date?, months: 6) as NSDate
    }
    func getTodaysDate()->String{
        let mydate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strMonth = dateFormatter.string(from: mydate)
        return strMonth
    }
//    public func calendar(_ calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: Date!)
//        {
//            for view in menuItemView.subviews {
//                view.removeFromSuperview()
//            }
//           // let label1 = UILabel(frame: CGRect(x: 80, y: 60, width:400, height: 21))
//            let label1 = UILabel(frame: CGRect(x: 80, y: 60, width:400, height: 21))
//            label1.center = CGPoint(x: 130, y: 20)
//            label1.textColor = UIColor.black
//            label1.textAlignment = NSTextAlignment.center
//            let dateFormatter1 = DateFormatter()
//            dateFormatter1.dateFormat = "MMMM yyyy";
//            let mydt = dateFormatter1.string(from: date)
//            label1.text = mydt
//            menuItemView.addSubview(label1)
//        }
//
    public func calendar(_ calendar: JTCalendarManager!, canDisplayPageWith date: Date!) -> Bool
    {
        return calendarManager.dateHelper.date(date, isEqualOrAfter: minDate as Date?, andEqualOrBefore: maxDate as Date?)
    }
    // prepareDayView
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: (UIView & JTCalendarDay)!) {
        
        // Today
        // Today
        let mydayview = dayView as! JTCalendarDayView
        
        // let converetedDate = self.convertDateToCompeareWithCalenderdate(toFormatedDate: mydayview.date)
        if(calendarManager.dateHelper.date(NSDate() as Date?, isTheSameDayThan: mydayview.date)) {
            mydayview.circleView.isHidden = false;
            mydayview.textLabel.textColor = UIColor.white
        }
            // Selected date
        else if(String(describing: dateSelected) != "" && calendarManager.dateHelper.date(dateSelected as Date?, isTheSameDayThan: mydayview.date))
        {
            mydayview.circleView.isHidden = false;
            mydayview.circleView.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            mydayview.textLabel.textColor = UIColor.white
        }
            // Other month
        else if(calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: mydayview.date))
        {
            mydayview.textLabel.textColor = UIColor.black
        }
        // Another day of the current month
        mydayview.circleView.isHidden = true
        mydayview.textLabel.textColor = UIColor.lightGray
        mydayview.dotView.isHidden = true
        let strDate = "\(mydayview.date!)"
        let calenderDate = strDate.convertDateFormaterDateCalender(strDate)
       // print(calenderDate)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let calenderDates = dateFormatter1.date(from: calenderDate)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let todaysDate = dateFormatter1.date(from: self.strTodayDate)
        let date_is_old = calenderDates?.isSmallerThan(todaysDate!)
        if date_is_old == true{
        mydayview.textLabel.textColor = UIColor.lightGray
        }else{
         mydayview.textLabel.textColor = UIColor.black
        }
        
        if self.arrayAvailabilityDates.contains(calenderDate) {
          //  print(calenderDate)
            let boolComopareDate  = calenderDates?.isGreaterThan(todaysDate!)
            let boolComopareDate1 = calenderDates?.isEqualTo(todaysDate!)
        
            if (boolComopareDate == true) || (boolComopareDate1 == true){
                mydayview.circleView.isHidden = false
                mydayview.textLabel.textColor = UIColor.white
            }
        }
    }
    
    @IBAction func actionOnNotification(_ sender: UIButton) {
       let vc = storyBoard.Main.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
              vc.hidesBottomBarWhenPushed = true
              self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func convertDateToCompeareWithCalenderdate(toFormatedDate date: Date) -> String {
       // print(date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let myStringafd = dateFormatter.string(from: date)
      //  print(myStringafd)
        return dateFormatter.string(from: date)
    }
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: (UIView & JTCalendarDay)!) {
        
        let mydayview = dayView as! JTCalendarDayView
        let strDate = "\(mydayview.date!)"
        let calenderDate = strDate.convertDateFormaterDateCalender(strDate)
       // print(calenderDate)
        
        strSelectedDateTitle = strDate.convertDateFormaterDayDateCalender(strDate)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let calenderDates = dateFormatter1.date(from: calenderDate)
        let todaysDate = dateFormatter1.date(from: self.strTodayDate)
        
        
        if(!calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: mydayview.date)){
            if(calendarContentView.date.compare(mydayview.date) == ComparisonResult.orderedAscending)
            {
                //calendarContentView.loadNextPageWithAnimation()
            } else {
                //calendarContentView.loadPreviousPageWithAnimation()
            }
            
        } else {
            
                
            }
        let date_is_old = calenderDates?.isSmallerThan(todaysDate!)
        if date_is_old == true{
                   
        }else{
            dateSelected = mydayview.date as NSDate
            
            print("dateSelected: \(dateSelected)")
            self.didSelcteOndate(strId: calenderDate)
        }
    }
    
    func didSelcteOndate(strId:String)  {
        let details = storyBoard.Main.instantiateViewController(withIdentifier: "MNBookingsateSelectedVC") as! MNBookingsateSelectedVC
        // details.isFreelauncer = true
        print("strId: \(strSelectedDateTitle)")
        details.selectedDate = strId
        details.strSelectedDateTitle = strSelectedDateTitle
        self.navigationController?.pushViewController(details, animated: true)
    }
    
   
    @IBAction func Proivious(_ sender: Any) {
        calendarContentView.loadPreviousPageWithAnimation()
    }
    @IBAction func onNext(_ sender: Any) {
        calendarContentView.loadNextPageWithAnimation()
    }
    //Mark:- Show Animetion When PopUp Is show
    func showAnimateOnPopUp() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    func callServiceGetCalenderDataAPI() {

       // ShowHud()
        ShowHud(view: self.view)
        print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                        "month_year":monthYear,
                                        "user_type":MyDefaults().swiftUserData["user_type"] ?? "",
                                        "page":"1"]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNGetCalenderAPI , parameter: parameter) { (response) in
            debugPrint(response)

           // HideHud()
        HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                let response = ModelCalender.init(fromDictionary: response as! [String : Any])
                self.calenderData = response.jobList
                self.strTodayDate = self.getTodaysDate()
                for items in response.jobList {
                    let arrayDate = items.jobStartDate!
                   // print(arrayDate)
                    let date = arrayDate.convertDateFormaterDate(arrayDate)
                  //  print(date)
                    self.arrayAvailabilityDates.append(date)
                    self.calendarManager.delegate = self
                    self.calendarManager.reload()
                }
            } else if status == "4"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)
            }
            else
            {
//                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }} else
                       {
//                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                       }
            
        }
    }
}




func describeComparison(date1: Date, date2: Date) -> String {
    
    var descriptionArray: [String] = []
    
    if date1 < date2 {
        descriptionArray.append("date1 < date2")
    }
    
    if date1 <= date2 {
        descriptionArray.append("date1 <= date2")
    }
    
    if date1 > date2 {
        descriptionArray.append("date1 > date2")
    }
    
    if date1 >= date2 {
        descriptionArray.append("date1 >= date2")
    }
    
    if date1 == date2 {
        descriptionArray.append("date1 == date2")
    }
    
    if date1 != date2 {
        descriptionArray.append("date1 != date2")
    }
    
    return descriptionArray.joined(separator: ",  ")
}


extension Date {
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
}

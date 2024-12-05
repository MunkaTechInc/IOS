//
//  MNGraphVC.swift
//  Munka
//
//  Created by Amit on 23/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import Charts

class MNGraphVC: UIViewController,getGraphType {
   
    func delegateGraphType(strJob: String) {
        arrayrupee = [Double]()
         arraymonth = [String]()
        if strJob == "Monthly Analytics Report" {
            self.callServiceForGraphAPI(year: "this_month")
        } else if strJob == "Weekly Analytics Report" {
            self.callServiceForGraphAPI(year: "this_week")
        }else if strJob == "Yearly Analytics Report" {
            self.callServiceForGraphAPI(year: "this_year")
        }
        
    }
     
    @IBOutlet weak var viewNoInternetConnection:UIView!
    @IBOutlet weak var viewNoDateFound:UIView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var lblAmmount: UILabel!
    @IBOutlet weak var lblNextPayment: UILabel!
   //var arraymonth = [String]()
    var arrayrupee = [Double]()
    var arraymonth = [String]()
   weak var axisFormatDelegate: AxisValueFormatter?

    var details = [ModelGrpahDetail]()
    

        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            axisFormatDelegate = self
        viewNoDateFound.isHidden = true
        if  isConnectedToInternet() {
            self.callServiceForGraphAPI(year: "this_month")
        } else {
            viewNoInternetConnection.isHidden = false
           // viewAl.isHidden = true
            self.showErrorPopup(message: internetConnetionError, title: alert)
    }
    }
      override func viewDidAppear(_ animated: Bool) {
      
        barChartView.animate(yAxisDuration: 2.0)
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.drawBordersEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.drawGridBackgroundEnabled = true
          barChartView.chartDescription.text = "Bar Chart View"
    }
    

    func setChart(dataEntryX forX:[String],dataEntryY forY: [Double], strBottom:String) {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries:[BarChartDataEntry] = []
        for i in 0..<forX.count{
           // print(forX[i])
           // let dataEntry = BarChartDataEntry(x: (forX[i] as NSString).doubleValue, y: Double(unitsSold[i]))
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(forY[i]) , data: self.arraymonth as AnyObject?)
            print(dataEntry)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: strBottom)
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        let xAxisValue = barChartView.xAxis
        xAxisValue.valueFormatter = axisFormatDelegate

    }
@IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
     }
    @IBAction func actionOnRightBarButton(_ sender: UIButton) {
       //self.navigationController?.popViewController(animated: true)
    let popup : MNGraphListPopUPVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNGraphListPopUPVC") as! MNGraphListPopUPVC
        popup.delagate = self
        self.presentOnRoot(with: popup)
    }
    func callServiceForGraphAPI(year:String) {
       var titleBottom = ""

       // ShowHud()
        ShowHud(view: self.view)
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "type":year]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNGetGraphAPI , parameter: parameter) { (response) in
             debugPrint(response)

          //HideHud()
            HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
              {
                 let response = ModelGraph.init(fromDictionary: response as! [String : Any])
                self.details = response.details
                self.barChartView.isHidden = false
                    //setChart(dataPoints: self.details.mo, values: goals.map { Double($0) })
                self.lblAmmount.text =  "$" + response.totalAmount
                self.lblNextPayment.text =  "$" + response.nextAmmount
                
                for items in self.details {
                    let month = items.date!
                   let rupee = items.amount!
                    let myDouble = rupee.toDouble()
                    print(month)
                    var date = ""
                    if year == "this_month" {
                         date = self.convertDateOnlyMonth(month)
                        titleBottom = "MUNKA monthly report"
                        self.title = "Monthly Analytics Report"
                    } else if year == "this_week" {
                         date = self.convertDateOnlyMonth(month)
                        titleBottom = "MUNKA weekly report"
                        self.title = "Weekly Analytics Report"
                    } else if year == "this_year" {
                         date = self.convertDateOnlyYear(month)
                        titleBottom = "MUNKA yearly report"
                        self.title = "Yearly Analytics Report"
                    }
                    self.arraymonth.append(date)
                    self.arrayrupee.append(myDouble ?? 0.0)
}
                self.setChart(dataEntryX: self.arraymonth, dataEntryY: self.arrayrupee, strBottom: titleBottom)
             
             }
              else
              {
                self.viewNoDateFound.isHidden = false
                 self.showErrorPopup(message: message, title: alert)
              }
                
            }else{
                self.showErrorPopup(message: "Server cound not connect.", title: ALERTMESSAGE)
            }
                
            }
    }
    func convertDateOnlyMonth(_ strdate: String) -> String{
        print(strdate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd"
        return  dateFormatter.string(from: date!)
    }
    func convertDateOnlyYear(_ strdate: String) -> String{
        print(strdate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM yyyy"
        return  dateFormatter.string(from: date!)
    }
}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

extension MNGraphVC: AxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return self.arraymonth[Int(value)]
    }
}

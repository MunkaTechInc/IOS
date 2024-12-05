//
//  SelectCategoryPopupVC.swift
//  Munka
//
//  Created by Amit on 14/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import Toaster
protocol GetSelectCategory {
    func delegateCategoryType(array:[[String:String]])
    func delegateSelectedWorkingDay(array:[String])
    func delegateSelectedShifts(array:[DayShiftDetail])
    func delegatePostJobcategory(array:[[String:Any]])
}

class DayShiftModelData{
    
    var strDay = String()
    var arrDayShift = [DayShiftDetail]()
    
    init(strDay: String = String(), arrDayShift: [DayShiftDetail] = [DayShiftDetail]()) {
        self.strDay = strDay
        self.arrDayShift = arrDayShift
    }
}

class SelectCategoryPopupVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tfSearch: UITextField!
    
    var AllCategorydetails = [CategoryDetail]()
    var Categorydetails = [CategoryDetail]()
    var arrDayShiftDetail = [DayShiftDetail]()
    var arrDayShift = [DayShiftModelData]()
//    var arrSelectedDayShift = [DayShiftModelData]()
    
    var isClickOnSignUp = true
    var arrayItems = [String]()
    var arraySelectItems = [[String:String]]()
    var arrayForPostJob = [[String:Any]]()
    var delagate: GetSelectCategory!
    
    
    var isCategorySelected = Bool()
    var isDaySelected = Bool()
    var isShiftSelected = Bool()
    
    
    var arrSelectedDay = [String]()
    var arrSelectedShift = [DayShiftDetail]()
    
    var arrDay = ["Monday", "Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
//    var arrShift = ["Morning", "Evening","Night","Overnight"]
    
    @IBOutlet weak var tfSearchTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var tfSearchHeightCons: NSLayoutConstraint!
    @IBOutlet weak var tblViewCategory:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfSearch.delegate = self

        tblViewCategory.register(UINib(nibName: "DayHeadeView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DayHeadeView")
        
        if isCategorySelected{
            tfSearchTopCons.constant = 10
            tfSearchHeightCons.constant = 34
            lblTitle.text! = "Select Category"
//            heightConstTblCategoryView.constant = 294
            if  isConnectedToInternet() {
                CallServiceForCategoryAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: ALERTMESSAGE)
            }
        }else{
            tfSearchTopCons.constant = 0
            tfSearchHeightCons.constant = 0
        }
        
        if isShiftSelected {
            tfSearchTopCons.constant = 0
            tfSearchHeightCons.constant = 0
            lblTitle.text! = "Select Day and Shift"
//            heightConstTblCategoryView.constant = ScreenSize.SCREEN_HEIGHT - 250

            if  isConnectedToInternet() {
                CallServiceForJobShiftAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: ALERTMESSAGE)
            }
        }
        
        if isDaySelected {
            tfSearchTopCons.constant = 0
            tfSearchHeightCons.constant = 0
            lblTitle.text! = "Select Working Day"
        }
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tfSearch.text = ""
        self.view.endEditing(true)
        self.tfSearch.resignFirstResponder()
    }
    

    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        filterContentForSearchText(searchText)
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        filterContentForSearchText("") // Clear the search text to show all items
        return true
    }
    
    // MARK: - Helper methods

    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            // If search text is empty, show all items
            Categorydetails = AllCategorydetails
        } else {
            // Filter items based on search text
            Categorydetails = AllCategorydetails.filter { categoryDetail in
                return categoryDetail.name.lowercased().contains(searchText.lowercased())
            }
        }
        tblViewCategory.reloadData()
    }
    
    func CallServiceForCategoryAPI() {
        
        //  ShowHud()
        ShowHud(view: self.view)
        
        let parameter: [String: Any] = ["":""]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNServiceCategoryAPI , parameter: parameter) { (response) in
            debugPrint(response)
            
            // HideHud()
            HideHud(view: self.view)
            
            if response.count != nil{
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    let response = ModelCategoryList.init(fromDictionary: response as! [String : Any])
                    self.Categorydetails = response.details
                    self.AllCategorydetails = response.details
                    
//                    Toast(text: message).show()
                    self.tblViewCategory?.reloadData()
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
    
    func CallServiceForJobShiftAPI() {
        //  ShowHud()
        ShowHud(view: self.view)
        let parameter: [String: Any] = ["":""]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNServiceJobShiftAPI, parameter: parameter) { [self] (response) in
            debugPrint(response)
            
            // HideHud()
            HideHud(view: self.view)
            
            if response.count != nil{
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    let response = DayShiftModel.init(fromDictionary: response as! [String : Any])
                    self.arrDayShiftDetail = response.details
                    print("array Data: \(self.arrDayShiftDetail.count)")
                    
                    for day in self.arrDay{
                        
                        arrDayShift.append(DayShiftModelData(strDay: day, arrDayShift: arrDayShiftDetail))
                    }
                    print("arr: \(arrDayShift)")
                    
                    Toast(text: message).show()
                    self.tblViewCategory?.reloadData()
                } else if status == "4"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }
                
            }else{
                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
    
    @IBAction func actionOnCross(_ sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionOnRight(_ sender: AnyObject){
        
        if isCategorySelected == true {
            if isClickOnSignUp == true {
                for items in self.Categorydetails {
                    if items.isSelected == true {
                        var dictionary =  [String:String]()
                        dictionary.updateValue(items.name, forKey: "name")
                        dictionary.updateValue(items.id, forKey: "id")
                        arraySelectItems.append(dictionary)
                    }
                }
                print(arraySelectItems.count)
                if self.delagate != nil {
                    self.dismiss(animated: true, completion: nil)
                    self.delagate.delegateCategoryType(array: arraySelectItems)
                }
            }
        } else  if isDaySelected {
            if self.delagate != nil {
                self.dismiss(animated: true, completion: nil)
                self.delagate.delegateSelectedWorkingDay(array: arrSelectedDay)
                
            }
        } else  if isShiftSelected {
            if self.delagate != nil {
                self.dismiss(animated: true, completion: nil)
                self.delagate.delegateSelectedShifts(array: arrSelectedShift)
                
            }
        } else{
            if self.delagate != nil {
                self.dismiss(animated: true, completion: nil)
                self.delagate.delegatePostJobcategory(array: arrayForPostJob)
            }
            
        }
    }
}
extension SelectCategoryPopupVC: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isShiftSelected == true{
            return arrDayShift.count
        }
        return 1
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDaySelected == true{
            return self.arrDay.count

        }else if isShiftSelected == true{
            
            let objArr = arrDayShift[section]
            
            return objArr.arrDayShift.count
        }else{
            return self.Categorydetails.count

        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryTableViewCell") as! SelectCategoryTableViewCell
        if isDaySelected == true{
            cell.lblCategoryName.text! = self.arrDay[indexPath.row]
            
            if arrSelectedDay.contains(arrDay[indexPath.row]) {
                cell.btnCategory.isSelected = true
            }else{
                cell.btnCategory.isSelected = false
            }
        }else if isShiftSelected == true{
            
//            let objDayShift = arrDayShiftDetail[indexPath.row]
        
            let objDict = arrDayShift[indexPath.section]
            let objDayShift =  objDict.arrDayShift[indexPath.row]
            
            if let shift = objDayShift.shift, let startTime = objDayShift.StartTime, let endTime = objDayShift.EndTime{
                
                cell.lblCategoryName.text! = "\(shift) - \(startTime) to \(endTime)"
            }
            
           /* if objDayShift.isSelected{
                cell.btnCategory.isSelected = true

            }else{
                cell.btnCategory.isSelected = false
            }*/

           if arrSelectedShift.contains(where: {$0.shift == objDayShift.shift && $0.headerTitle == objDict.strDay}){
            
                print("shift :\( objDict.strDay)")
                cell.btnCategory.isSelected = true
            }else{
                cell.btnCategory.isSelected = false
            }
        }else{
            cell.lblCategoryName.text! = self.Categorydetails[indexPath.row].name
            
            if isClickOnSignUp ==  true{
                
                if self.Categorydetails[indexPath.row].isSelected == true {
                    cell.btnCategory.isSelected = true
                }else{
                    cell.btnCategory.isSelected = false
                }
            }else{
                if self.Categorydetails[indexPath.row].isSelected == true {
                    cell.btnCategory.isSelected = true
                    self.Categorydetails[indexPath.row].isSelected = false
                }else{
                    cell.btnCategory.isSelected = false
                    self.Categorydetails[indexPath.row].isSelected = false
                }
            }
            
        }
       
        return cell
        
    }
    /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     arrayForPostJob = [[String:String]]()
     if isClickOnSignUp ==  true{
     if self.Categorydetails[indexPath.row].isSelected == false {
     if arrayItems.count  < Categorydetails {
     self.Categorydetails[indexPath.row].isSelected = true
     arrayItems.append(self.Categorydetails[indexPath.row].name)
     }else{
     self.showErrorPopup(message: "Please select three category at a time.", title: alert)
     }
     
     }else{
     print("array: \(arrayItems), indexPath: \(indexPath.row)")
     
     
     if arrayItems.count  > 0 {
     arrayItems.removeAll { $0 == Categorydetails[indexPath.row].name }
     //                     arrayItems.remove(at: indexPath.row)
     self.Categorydetails[indexPath.row].isSelected = false
     }
     }
     }else{
     if self.Categorydetails[indexPath.row].isSelected == false {
     let array = self.Categorydetails[indexPath.row]
     var dictinory =  [String:Any]()
     dictinory["name"] = array.name
     dictinory["id"] = array.id
     self.Categorydetails[indexPath.row].isSelected = true
     arrayForPostJob.append(dictinory)
     }else {
     self.Categorydetails[indexPath.row].isSelected = false
     }
     }
     self.tblViewCategory.reloadData()
     }*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isDaySelected == true{
            
            if 
                arrSelectedDay.contains(arrDay[indexPath.row]){
                print("day :\(arrDay[indexPath.row])")
                if let index = arrSelectedDay.firstIndex(of: arrDay[indexPath.row]) {
                    
                    arrSelectedDay.remove(at: index)
                }
            }else{
                arrSelectedDay.append(arrDay[indexPath.row])
            }
            tblViewCategory.reloadData()
        }else if isShiftSelected == true{
            
            let objArr = arrDayShift[indexPath.section]
            let objData = arrDayShift[indexPath.section].arrDayShift[indexPath.row]

         /*  if let index = objArr.arrDayShift.firstIndex(where: {$0.isSelected == true}) {
                objArr.arrDayShift[index].isSelected = false
            }else{
                if let index = objArr.arrDayShift.firstIndex(where: {$0.isSelected == false}) {
                    objArr.arrDayShift[index].isSelected = true

                }
            }*/


     /*    if arrSelectedShift.contains(where: {$0.headerTitle == arrDayShift[indexPath.section].strDay && $0.shift == objData.shift && $0.isSelected == objData.isSelected}){
                
                if let index = arrSelectedShift.firstIndex(where: {$0.headerTitle == objArr.strDay && $0.shift == objData.shift && $0.isSelected == objData.isSelected }) {
                  
                    arrSelectedShift.remove(at: index)
                }
            }else{
              
            }*/
            
            var  objSelected = DayShiftDetail(fromDictionary: [String: Any]())
            
            if let index = arrSelectedShift.firstIndex(where: {$0.headerTitle == objArr.strDay && $0.shift == objData.shift && $0.isSelected == true}) {
              
                arrSelectedShift.remove(at: index)
            }else{
                objSelected.shift = objData.shift
                objSelected.StartTime = objData.StartTime
                objSelected.EndTime = objData.EndTime
                objSelected.isSelected = true
                objSelected.headerTitle = arrDayShift[indexPath.section].strDay
                
                print("title : \(arrDayShift[indexPath.section].strDay), stri Shift:\(objData.shift) ")
                
               
                arrSelectedShift.append(objSelected)
            }
            
      
            tblViewCategory.reloadData()

        
        }else{
            arrayForPostJob = [[String:String]]()
            var selectedArr = [CategoryDetail]()
            
            for item in Categorydetails {
                if  item.isSelected {
                    selectedArr.append(item)
                }
            }
            if self.Categorydetails[indexPath.row].isSelected {
                self.Categorydetails[indexPath.row].isSelected = false
                if arrayItems.count  > 0 {
                    arrayItems.removeAll { $0 == Categorydetails[indexPath.row].name }
                    self.Categorydetails[indexPath.row].isSelected = false
                }
                print(arrayItems)
                
            }else{
                if selectedArr.count < Categorydetails.count {
                    self.Categorydetails[indexPath.row].isSelected = true
                    arrayItems.append(self.Categorydetails[indexPath.row].name)
                    print(arrayItems)
                }else{
                    //                     self.showErrorPopup(message: "Please select three category at a time.", title: ALERTMESSAGE)
                }
            }
            self.tblViewCategory.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isShiftSelected == true{
            
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DayHeadeView") as! DayHeadeView
            
            headerView.lblDay.text! =  arrDayShift[section].strDay
            
            if headerView.btnSelect.isSelected == false{
                headerView.btnSelect.isSelected = true
            }else{
                headerView.btnSelect.isSelected = false
            }
            headerView.btnSelect.isHidden = true
            
            
            return headerView
        }else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isShiftSelected == true{
            return 50
        }else{
            return 0
        }
    }
}
    

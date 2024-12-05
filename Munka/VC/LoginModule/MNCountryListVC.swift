//
//  MNCountryListVC.swift
//  Munka
//
//  Created by Amit on 08/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import Toaster
protocol GetCountrylist {
    func DelegateCountryList(CountryName:String,CountryId:String,isCountry:Bool,isTown:Bool)
}
class MNCountryListVC: UIViewController {
    var delagate: GetCountrylist!
    var searchCountry : Bool = false
    var isCountryList = false
    var isTown = false
    var CountryId = ""
    var stateId = ""
  //  var indexTitles = ["A", "B", "C", "D", "E", "F", "G", "H","I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    @IBOutlet weak var tblViewCountry:UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    //var indexTitles: [String] = [String]()
    var details = [ModelDetail]()
    var filterDetails = [ModelDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
       UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        // Do any additional setup after loading the view.
       // searchBar.searchTextField.textColor = .black
        if isTown == true{
            searchBar.placeholder = "Town"
            self.title = "Town"
        }else{
            if isCountryList == true{
                searchBar.placeholder = "Country"
                self.title = "Country"
            }else{
                searchBar.placeholder = "State"
                self.title = "State"
            }
        }
        if  isConnectedToInternet() {
            if isTown == true {
                CallServiceForTownAPI()
            }else{
                if isCountryList == true{
                CallServiceForCountryListAPI()
                }else{
                    CallServiceForStateListAPI()
                }
            }
           
            
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func CallServiceForCountryListAPI() {

      //  ShowHud()
ShowHud(view: self.view)
        let parameter: [String: Any] = [:]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNCountryAPI , parameter: parameter) { (response) in
            debugPrint(response)
            if response.count != nil{

           // HideHud()
HideHud(view: self.view)
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                 let response = ModelCountryList.init(fromDictionary: response as! [String : Any])
                 self.details = response.details
               // Toast(text: message).show()
                self.tblViewCountry?.reloadData()
            }else if status == "4"
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
    func CallServiceForStateListAPI() {

      //  ShowHud()
ShowHud(view: self.view)
        let parameter: [String: Any] = ["country_id":CountryId]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNStateAPI , parameter: parameter) { (response) in
            debugPrint(response)

          //  HideHud()
HideHud(view: self.view)
            if response.count != nil{
                
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                 let response = ModelCountryList.init(fromDictionary: response as! [String : Any])
                 self.details = response.details
              //  Toast(text: message).show()
                self.tblViewCountry?.reloadData()
            }else if status == "4"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)
            }else
            {
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }}else
            {
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
    func CallServiceForTownAPI() {

      // ShowHud()
ShowHud(view: self.view)
        let parameter: [String: Any] = ["state_id":stateId]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNCitiesAPI , parameter: parameter) { (response) in

          //  HideHud()
HideHud(view: self.view)
            if response.count != nil{
            let status = response["status"] as! String
            let message = response["msg"] as! String
            if status == "1"
            {
                 let response = ModelCountryList.init(fromDictionary: response as! [String : Any])
                 self.details = response.details
              //  Toast(text: message).show()
                self.tblViewCountry?.reloadData()
            }else if status == "4"{
                self.autoLogout(title: ALERTMESSAGE, message: message)
            }
                else
            {
                self.showErrorPopup(message: message, title: alert)
            }}else
            {
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
        }
    }
    }

extension MNCountryListVC: UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchCountry {
           return filterDetails.count
        }else{
            return self.details.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListTableViewCell") as! CountryListTableViewCell
        //let obj = ProductCars[indexPath.row]
       
        if searchCountry {
          cell.lblCountryName.text! = self.filterDetails[indexPath.row].name
        }else{
            cell.lblCountryName.text! = self.details[indexPath.row].name
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delagate != nil {
            if isTown == true {
                if searchCountry {
                    self.delagate.DelegateCountryList(CountryName: self.filterDetails[indexPath.row].name, CountryId: self.filterDetails[indexPath.row].id, isCountry: false, isTown: true)
                }else{
                    self.delagate.DelegateCountryList(CountryName: self.details[indexPath.row].name, CountryId: self.details[indexPath.row].id, isCountry: false, isTown: true)
                }
                 
            }else{
                if isCountryList == true{
                    if searchCountry {
                     self.delagate.DelegateCountryList(CountryName: self.filterDetails[indexPath.row].name, CountryId: self.filterDetails[indexPath.row].id, isCountry: true, isTown: false)
                    }else{
                       self.delagate.DelegateCountryList(CountryName: self.details[indexPath.row].name, CountryId: self.details[indexPath.row].id, isCountry: true, isTown: false)
                    }
                   // self.navigationController?.popViewController(animated: true)
                }else{
                    if searchCountry {
                        self.delagate.DelegateCountryList(CountryName: self.filterDetails[indexPath.row].name, CountryId: self.filterDetails[indexPath.row].id, isCountry: false, isTown: false)
                    }else{
                       self.delagate.DelegateCountryList(CountryName: self.details[indexPath.row].name, CountryId: self.details[indexPath.row].id, isCountry: false, isTown: false)
                    }
                    
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return indexTitles
//    }
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//            if self.details.count > 0 {
//                return self.details.contains(<#T##element: ModelDetail##ModelDetail#>)
//            } else{
//                return index}
//    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterDetails = self.details.filter { ($0.name?.localizedCaseInsensitiveContains(searchText))!}
        if searchText.count > 0 {
            searchCountry = true
        } else {
            searchCountry = false
        }
        self.tblViewCountry.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        tblViewCountry.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // called when cancel button pressed
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        self.tblViewCountry?.isHidden = false
        
        self.view.endEditing(true)
        self.tblViewCountry?.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchCountry = false
        searchBar.resignFirstResponder()
    }
    
}

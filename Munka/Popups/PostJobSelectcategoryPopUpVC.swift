
import UIKit
import Toaster
protocol GetSelectCategoryOnPostJob {
   // func delegateCategoryType(array:[[String:String]])
    func delegateselectPostJobcategory(array:[[String:Any]])
}
class PostJobSelectcategoryPopUpVC: UIViewController {
     var Categorydetails = [CategoryDetail]()
     var isClickOnSignUp = true
     var arrayItems = [String]()
    var arraySelectItems = [[String:String]]()
     var arrayForPostJob = [[String:Any]]()
     var delagate: GetSelectCategoryOnPostJob!
     @IBOutlet weak var tblViewCategory:UITableView!
    
    var isSelectedCategory : Bool = false
    
    //var arrayForPostJob = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  isConnectedToInternet() {
            CallServiceForCategoryAPI()
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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

                if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                     let response = ModelCategoryList.init(fromDictionary: response as! [String : Any])
                     self.Categorydetails = response.details
                    Toast(text: message).show()
                    self.tblViewCategory?.reloadData()
                } else if status == "1"
                {
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }   else
                {
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}else
                {
                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
            }
        }
    @IBAction func touchOnView(_ sender: UIButton) {
               self.dismiss(animated: true, completion: nil)
           }
    }
extension PostJobSelectcategoryPopUpVC: UITableViewDataSource,UITableViewDelegate{
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.Categorydetails.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostJobSelectcategoryTableViewCell") as! PostJobSelectcategoryTableViewCell
            cell.lblCategory.text! = self.Categorydetails[indexPath.row].name.capitalizingFirstLetter()
            

           if self.Categorydetails[indexPath.row].isSelected == true {
                cell.btnCataegory.isSelected = true
           // self.Categorydetails[indexPath.row].isSelected = true
            
           }else{
                cell.btnCataegory.isSelected = false
               //  self.Categorydetails[indexPath.row].isSelected = false
                }
            
            return cell
    
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        self.arrayForPostJob = [[String:Any]]()
//
//        if self.Categorydetails[indexPath.row].isSelected == false {
//
//            for items in self.Categorydetails {
//                if items.isSelected == true {
//                    items.isSelected = false
//                }else{
//                    self.Categorydetails[indexPath.row].isSelected = true
//                }
//            }
//            //isSelectedCategory = true
//        }else if self.Categorydetails[indexPath.row].isSelected == true {
//            self.Categorydetails[indexPath.row].isSelected = false
//        }
        for items in self.Categorydetails {
            if items.isSelected == true {
                items.isSelected = false
            }else{
                self.Categorydetails[indexPath.row].isSelected = true
            }
        }
        self.tblViewCategory.reloadData()
    }
    
    @IBAction func actionOnCross(_ sender: AnyObject){
            self.dismiss(animated: true, completion: nil)
        }
        @IBAction func actionOnRight(_ sender: AnyObject){
            self.arraySelectItems = [[String:String]]()
            for items in self.Categorydetails {
                if items.isSelected == true {
                    var dictionary =  [String:String]()
                    dictionary.updateValue(items.name, forKey: "name")
                    dictionary.updateValue(items.id, forKey: "id")
                    arraySelectItems.append(dictionary)
                }
            }
            if self.delagate != nil {
                self.dismiss(animated: true, completion: nil)
                self.delagate.delegateselectPostJobcategory(array: arraySelectItems)
            }
    }
    
}

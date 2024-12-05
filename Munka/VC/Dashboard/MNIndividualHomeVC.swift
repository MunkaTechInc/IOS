//
//  MNIndividualHomeVC.swift
//  Munka
//
//  Created by Amit on 26/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import GLWalkthrough

class MNIndividualHomeVC: UIViewController {
    

    @IBOutlet weak var tblReviews:UITableView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var viewEmployee:UIView!
    @IBOutlet weak var viewNoInternetconnection:UIView!
    @IBOutlet weak var viewBackgroundeliteEmployee:UIView!
    @IBOutlet weak var viewNoDataFound:UIView!
    var EliteEmployee = [ModelEliteDetail]()
    var objIndividual = [ModelIndividualDetail]()
   

    var coachMarker:GLWalkThrough!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.clickOnHomeNotification),
        name: NSNotification.Name(rawValue: "HomeNotification"),
        object: nil)
    }
  
    func managePreview(){
        coachMarker = GLWalkThrough()
        coachMarker.dataSource = self
        coachMarker.delegate = self
        coachMarker.show()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        self.collectionView!.contentInset = UIEdgeInsets(top: -10, left: 0, bottom:0, right: 0)

        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: self.view.frame.size.width-40, height: self.collectionView.frame.size.height-10)
            layout.invalidateLayout()
        }

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "isDisplayIntroPage") {
            managePreview()
            UserDefaults.standard.set(false, forKey: "isDisplayIntroPage")
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tblReviews.isHidden = true
         viewEmployee.isHidden = true
        viewNoDataFound.isHidden = true
         viewNoInternetconnection.isHidden = true
         
         // Do any additional setup after loading the view.
     if  isConnectedToInternet() {
            viewNoInternetconnection.isHidden = true
            viewBackgroundeliteEmployee.isHidden = false
        self.callServiceforhomeApi()
            } else {
          viewNoInternetconnection.isHidden = false
         viewBackgroundeliteEmployee.isHidden = true
         self.showErrorPopup(message: internetConnetionError, title: alert)
        }

    }
    @objc private func clickOnHomeNotification(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        let vc = storyBoard.Main.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func callServiceforhomeApi() {
       

      //  ShowHud()
        ShowHud(view: self.view)

       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "list_type": "All",//"New",//"Upcoming",
                                      "user_type":MyDefaults().swiftUserData["user_type"] as! String,
                                      "page":"1",
                                      "Keyword":""]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNPIndividualHomeAPI , parameter: parameter) { (response) in
            debugPrint(response)
            
            //HideHud()
            HideHud(view: self.view)
            
            if response.count != nil{
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    let response = ModelIndividualHome.init(fromDictionary: response as! [String : Any])
                    self.objIndividual = response.details
                    self.tblReviews.isHidden = false
                    self.viewEmployee.isHidden = false
                    self.viewNoDataFound.isHidden = true
                    self.tblReviews.reloadData()
                    self.callServiceforEliteEmployeeApi()
                } else if status == "4"{
                    //self.showErrorPopup(message: message, title: alert)
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                } else if status == "2"{
                    //self.showErrorPopup(message: message, title: alert)
                    
                }
                else if status == "0"{
                    //self.showErrorPopup(message: message, title: alert)
                    //   HideHud()
                    HideHud(view: self.view)
                }
                else
                {
                    self.tblReviews.isHidden = true
                    self.viewEmployee.isHidden = false
                    self.viewNoDataFound.isHidden = false
                    // self.showErrorPopup(message: message, title: alert)
                    self.callServiceforEliteEmployeeApi()
                }}else{
                    self.showErrorPopup(message: serverNotFound, title: alert)
                }
        }
        
    }
    func callServiceforEliteEmployeeApi() {
       
       // ShowHud()
       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "page":"1"
                                      ]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNPEliteEmployeeAPI , parameter: parameter) { (response) in
             debugPrint(response)

         // HideHud()

            if response.count != nil
            {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let response = ModelEliteEmployee.init(fromDictionary: response as! [String : Any])
                self.EliteEmployee = response.details
                self.viewNoInternetconnection.isHidden = true
                self.viewEmployee.isHidden = false
               print(self.EliteEmployee.count)
               //  self.viewEmployee.isHidden = false
                if self.objIndividual.count > 0 {
                    self.tblReviews.isHidden = false
                     self.viewNoDataFound.isHidden = true
                }else{
                    self.tblReviews.isHidden = true
                     self.viewNoDataFound.isHidden = false
                }
                self.collectionView.reloadData()
            } else  if status == "4"
             {
                self.autoLogout(title: ALERTMESSAGE, message: message)
             }else if status == "2"{
                         //self.showErrorPopup(message: message, title: alert)
                         
             }
             else if status == "0"{
                         //self.showErrorPopup(message: message, title: alert)
                         
             }
             else
             {
                self.viewEmployee.isHidden = true
                self.viewNoDataFound.isHidden = false
                self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }} else{
                //HideHud()
                HideHud(view: self.view)
                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
            }
            
         }
    }
    @IBAction func actionOnPostJob(_ sender: UIButton) {
       let details = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNPostJobVC") as! MNPostJobVC
                //details.jobid = self.details.jobId
        self.navigationController?.pushViewController(details, animated: true)
    }
     @IBAction func actionOnViewAllEliteEmployee(_ sender: UIButton) {
        let details = storyBoard.tabbar.instantiateViewController(withIdentifier: "MNAllEliteEmployeeVC") as! MNAllEliteEmployeeVC
            details.EliteEmployee = self.EliteEmployee
        self.navigationController?.pushViewController(details, animated: true)
    }
}

extension MNIndividualHomeVC: GLWalkThroughDelegate {
    func didSelectNextAtIndex(index: Int) {
        if index == 5 {
            coachMarker.dismiss()
        }
    }
    
    func didSelectSkip(index: Int) {    
        coachMarker.dismiss()
    }
}

extension MNIndividualHomeVC : GLWalkThroughDataSource{

    func getTabbarFrame(index:Int) -> CGRect? {
        if let bar = self.tabBarController?.tabBar.subviews {
            var idx = 0
            var frame:CGRect!
            for view in bar {
                if view.isKind(of: NSClassFromString("UITabBarButton")!) {
                    print(view.description)
                    if idx == index {
                        frame =  view.frame
                    }
                    idx += 1
                }
            }
            return frame
        }
        return nil
    }
    
    func numberOfItems() -> Int {
        return 5
    }
    
    func configForItemAtIndex(index: Int) -> GLWalkThroughConfig {
        let tabbarPadding:CGFloat = Helper.shared.hasTopNotch ? 88 : 50
        let overlaySize:CGFloat = Helper.shared.hasTopNotch ? 60 : 50
        let leftPadding:CGFloat = Helper.shared.hasTopNotch ? 8 : 5
        let screenHeight = UIScreen.main.bounds.height
        switch index {
        case 0:
            guard let frame = getTabbarFrame(index: 0) else {
                return GLWalkThroughConfig()
            }
            var config = GLWalkThroughConfig()
            config.title = "Inbox"
            config.subtitle = "Here you can explore chat list"
            config.frameOverWindow = CGRect(x: frame.origin.x + leftPadding, y: screenHeight - tabbarPadding, width: overlaySize, height: overlaySize)
            
            return config
        case 1:
            guard let frame = getTabbarFrame(index: 1) else {
                return GLWalkThroughConfig()
            }
            var config = GLWalkThroughConfig()
            config.title = "Calendar"
            config.subtitle = "Here you can explore Job list from the calendar"
            config.frameOverWindow = CGRect(x: frame.origin.x + leftPadding, y: screenHeight - tabbarPadding, width: overlaySize, height: overlaySize)
            config.position = .bottomLeft
            return config
        case 2:
            guard let frame = getTabbarFrame(index: 2) else {
                return GLWalkThroughConfig()
            }
            var config = GLWalkThroughConfig()
            config.title = "Munka"
            config.subtitle = "From this page you can post your jobs"
            config.frameOverWindow = CGRect(x: frame.origin.x + leftPadding, y: screenHeight - tabbarPadding, width: overlaySize, height: overlaySize)
            config.position = .bottomCenter
            return config
        case 3:
            guard let frame = getTabbarFrame(index: 3) else {
                return GLWalkThroughConfig()
            }
            var config = GLWalkThroughConfig()
            config.title = "Progress"
            config.subtitle = "Here you can see all running job progress"
            config.frameOverWindow = CGRect(x: frame.origin.x + leftPadding, y: screenHeight - tabbarPadding, width: overlaySize, height: overlaySize)
            config.position = .bottomRight
            return config
        case 4:
            guard let frame = getTabbarFrame(index: 4) else {
                return GLWalkThroughConfig()
            }
            var config = GLWalkThroughConfig()
            config.title = "My Profile"
            config.subtitle = "Your Account details, Wallets, Settings"
            config.nextBtnTitle = "Finish"
            
            config.frameOverWindow = CGRect(x: frame.origin.x + leftPadding, y: screenHeight - tabbarPadding, width: overlaySize, height: overlaySize)
            config.position = .bottomRight
            return config
        default:
            return GLWalkThroughConfig()
        }
    }
}

struct Helper {
    static var shared = Helper()
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}


// MARK: - extension
extension MNIndividualHomeVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objIndividual.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : HomeTableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell
        cell?.lblEmployeeName.text = self.objIndividual[indexPath.row].jobWorkedBy
        cell?.lblJobsType.text = self.objIndividual[indexPath.row].jobTitle
        cell?.imgIndividual.sd_setImage(with: URL(string:img_BASE_URL + self.objIndividual[indexPath.row].freelancerProfilePic), placeholderImage:#imageLiteral(resourceName: "ic_individual"))
        if  self.objIndividual[indexPath.row].jobType == "Fixed" {

        cell?.lblHoursPerDoller.text = "Fixed - " + "$" + self.objIndividual[indexPath.row].budgetAmount
        cell?.lblHours.text = self.objIndividual[indexPath.row].timeDuration + " " + "Days"
        }else if  self.objIndividual[indexPath.row].jobType == "Hourly"{
            cell?.lblHoursPerDoller.text = "Fixed - " + "$" + self.objIndividual[indexPath.row].budgetAmount
            cell?.lblHours.text = self.objIndividual[indexPath.row].timeDuration + " " + "hr."
        }else{
            cell?.lblHoursPerDoller.text = "$" + self.objIndividual[indexPath.row].budgetAmount
//            cell?.lblHours.text = self.objIndividual[indexPath.row].timeDuration + " " + "hr."
        }
        cell?.getDataFromHome(workerCategory: self.objIndividual[indexPath.row].workerCategory)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.objIndividual[indexPath.row].isApplied == "0" {
            let details = storyBoard.tabbar.instantiateViewController(withIdentifier: "EditJobVC") as! EditJobVC
            details.jobId = self.objIndividual[indexPath.row].id
            self.navigationController?.pushViewController(details, animated: true)
        }else{
            let details = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNPostDetailFreelauncerVC") as! MNPostDetailFreelauncerVC
            details.strJobId = self.objIndividual[indexPath.row].id
            self.navigationController?.pushViewController(details, animated: true)
        }
    }
}
extension MNIndividualHomeVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.EliteEmployee.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EliteCollectionViewCell", for: indexPath as IndexPath) as! EliteCollectionViewCell
        
        print("url:\(URL(string:img_BASE_URL + self.EliteEmployee[indexPath.row].profilePic))")
        
        cell.imgCategory.sd_setImage(with: URL(string:img_BASE_URL + self.EliteEmployee[indexPath.row].profilePic), placeholderImage:#imageLiteral(resourceName: "phl_square_profile"))
        cell.lblName.text = self.EliteEmployee[indexPath.row].fullName
        
        if let complete = self.EliteEmployee[indexPath.row].rating {
            print(complete)
            print(complete.toLengthOf(strRating: complete))
            cell.lblRating.text =  complete.toLengthOf(strRating: complete)
        }
        return cell
        }
        // MARK: - UICollectionViewDelegate protocol
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
            let viewProfile = storyBoard.freelauncer.instantiateViewController(withIdentifier: "MNFreelancerViewProfileVC") as! MNFreelancerViewProfileVC
            viewProfile.isFreelauncer = true
            viewProfile.userIdFreelauncer = self.EliteEmployee[indexPath.item].userId
            Constant.isFreelancer = "individual"
            self.navigationController?.pushViewController(viewProfile, animated: true)
    
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let padding: CGFloat =  10
//        let collectionViewSize = collectionView.frame.size.width - padding
//        let height = collectionView.frame.size.height
//        return CGSize(width: collectionViewSize/4 , height: height)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//       return CGSize(width: 96, height: 120)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//            // In this function is the code you must implement to your code project if you want to change size of Collection view
//            let width  = (view.frame.width-20)/3
//            return CGSize(width: width, height: width)
//    }
    
//func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let label = UILabel(frame: CGRect.zero)
//    label.text = workerCategory[indexPath.row].serviceCategory
//    label.sizeToFit()
//    return CGSize(width: label.frame.width, height: 32)
//}
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let yourWidth = collectionView.bounds.width/3.0
//        let yourHeight = 120
//        return CGSize(width: collectionView.bounds.width/3.0, height: 120.5)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  20
        //let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: (collectionView.bounds.width - 4)/3.0 - padding, height: 120.5)
    }
    
}

//MARK:- Deveide String to first 3 charcaters

extension String {

    func toLengthOf(strRating:String) -> String {
        var str: String = ""
        if strRating.count <= 3 {
            str = strRating
                return str
            } else {
            for charatcer in strRating {
                if str.count == 3{
                    return str
                }else{
                    str = str + "\(charatcer)"
                }
            }
           str = ""
        }
        return str
    }
}

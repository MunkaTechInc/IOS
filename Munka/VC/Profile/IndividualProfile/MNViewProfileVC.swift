//
//  MNViewProfileVC.swift
//  Munka
//
//  Created by Amit on 22/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNViewProfileVC: UIViewController {
    var viewDetails : ViewProfileModelDetail!
    //var reviewList = [ModelReviewList]()
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var lblJobPost: UILabel!
    @IBOutlet weak var lblCompleted: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblJoinDate: UILabel!
    @IBOutlet weak var btnPersonalInfo: UIButton!
    @IBOutlet weak var btnReviews: UIButton!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    weak var currentViewController: UIViewController?
    @IBOutlet weak var lblSlider: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var constraintLeadingSlideLable : NSLayoutConstraint!
    var isPersonalInfo: Bool = true
    var isFreelauncer = true
    var userIdFreelauncer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        floatRatingView.rating = 4.0
        // Do any additional setup after loading the view.
        //  MyDefaults().swiftDefaultViewProfile : ViewProfileModelDetail!
        if  isConnectedToInternet() {
            self.callServiceForViewProfileAPI()
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    func callServiceForViewProfileAPI() {
        let intCompletJob:Int = 0
        var userId = ""
        //        if isFreelauncer == true {
        //             userId = userIdFreelauncer
        //        }else{
        //            userId  = MyDefaults().UserId!
        //            userIdFreelauncer = userId
        //        }
        
        //ShowHud()
        ShowHud(view: self.view)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                        "other_user_id":userIdFreelauncer]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNGetProfileAPI , parameter: parameter) { (response) in
            debugPrint(response)
            
            // HideHud()
            HideHud(view: self.view)
            if response.count != nil{
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    let response = ModelViewProfile.init(fromDictionary: response as! [String : Any])
                    self.viewDetails = response.details
                    self.setUI()
                }else if status == "4"
                {
                    
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}else{   
                    print(serverNotFound)
//                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
        }
    }
     func setUI() {
        
        self.lblJoinDate.text = "Joined in " + self.convertDateFormater(self.viewDetails.created)
        if let jobs = self.viewDetails.totalJob {
             self.lblJobPost.text! = String(jobs)
         }
         if let complete = self.viewDetails.completeJob {
             print(complete)
            self.lblCompleted.text! = String(complete)
            print(self.lblCompleted.text!)
         }
        if let commnets = self.viewDetails.totalReview {
             print(commnets)
            self.lblComments.text! = String(commnets)
             print(self.lblCompleted.text!)
        }
         if let rating = self.viewDetails.rating {
            let strRating = rating.toLengthOf(strRating: rating)
            self.floatRatingView.rating = Double(strRating)!
         }
         
        let ratingPoint = self.viewDetails.rating!
        self.lblRating.text = (ratingPoint.toLengthOf(strRating: ratingPoint)) + "/" + "5"
            
        self.lblName.text = self.viewDetails.firstName + " " + viewDetails.lastName
        MyDefaults().swiftDefaultViewProfile = self.viewDetails
        self.callServiceForReviewListAPI()
         
         self.imgProfile.sd_setImage(with: URL(string:img_BASE_URL + self.viewDetails.profilePic), placeholderImage:#imageLiteral(resourceName: "phl_square_profile"))
         self.isPersonalInfo = true
         self.setLayoutAccordingToTapSelcetion(isSelectMap: self.isPersonalInfo)
    }
    func callServiceForReviewListAPI() {
        // let intCompletJob:Int = 0
        
        //        var userId = ""
        //               if isFreelauncer == true {
        //                    userId = userIdFreelauncer
        //               }else{
        //                   userId  = MyDefaults().UserId!
        //                   userIdFreelauncer = userId
        //               }
        
        //  ShowHud()
        ShowHud(view: self.view)
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                        "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                        "page":"1",
                                        "other_user_id":userIdFreelauncer]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNReviewListAPI , parameter: parameter) { (response) in
            
            //debugPrint(response)
            ///  HideHud()
       
            HideHud(view: self.view)
            if response.count != nil{
                
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    let response = ModelReviews.init(fromDictionary: response as! [String : Any])
                    //self.reviewList = response.reviewList
                    if response.reviewList.count > 0 {
                        MyDefaults().swiftReviewList = response.reviewList
                    }
                    
                } else if status == "4"{
                    
                    self.autoLogout(title: ALERTMESSAGE, message: message)
                }
                else
                {
                    print(serverNotFound)

//                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                }}else {
                    
                    print(serverNotFound)

//                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
        }
    }
    @IBAction func actionOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOnPersonalInfo(_ sender: Any) {
        self.isPersonalInfo = true
        setLayoutAccordingToTapSelcetion(isSelectMap: self.isPersonalInfo)
    }
    @IBAction func actionOnReview(_ sender: Any) {
        self.isPersonalInfo = false
        setLayoutAccordingToTapSelcetion(isSelectMap: self.isPersonalInfo)
    }
    func setLayoutAccordingToTapSelcetion(isSelectMap: Bool) {
        if isPersonalInfo {
            UIView.animate(withDuration: 0.3) {
                self.constraintLeadingSlideLable.constant = self.btnPersonalInfo.frame.origin.x
                self.view.layoutIfNeeded()
            }
            self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "MNPersonalInfoIndividualVC")
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChild(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        } else {
            
            UIView.animate(withDuration: 0.3) {
                self.constraintLeadingSlideLable.constant = self.btnReviews.frame.origin.x
                self.view.layoutIfNeeded()
            }
            self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "MNReviewsVC")
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChild(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        }
    }
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
    }
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)

    }
}

extension MNViewProfileVC: FloatRatingViewDelegate {

    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        //liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        //updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
}



////
////  UtilityClass.swift
////  ShibariStudy
////
////  Created by mac on 11/04/19.
////  Copyright © 2019 mac. All rights reserved.
////
//
import Foundation
//import SKActivityIndicatorView
import Alamofire
import RSLoadingView
let internetConnetionError = "Please check your connection and try again."
let internetConnetionTitle = "Connection Issue"
let titleSuccsefull = "Alert"
let alert = ALERTMESSAGE
let logoutTitle = "Log out"

struct AppSecureKey{
    static let APIKey       = "PifK6C4nX2RT6NLTcpdEdgbbFq8uOIct"
}
struct storyBoard {
    static let PopUp = UIStoryboard.init(name: "PopUp", bundle: nil)
    static let Main = UIStoryboard.init(name: "Main", bundle: nil)
    static let tabbar = UIStoryboard.init(name: "Tab", bundle: nil)
    static let freelauncer = UIStoryboard.init(name: "Freelauncer", bundle: nil)
    static let Individual = UIStoryboard.init(name: "Individual", bundle: nil)
}
struct Constant {
   
    static var isIndividual = ""
    static var isFreelancer = ""
    //static let Main = UIStoryboard.init(name: "Main", bundle: nil)
}


func ShowHud(view:UIView)  {
   // SKActivityIndicator.spinnerStyle(.defaultSpinner)
   // SKActivityIndicator.show("Loading...", userInteractionStatus: false)
    let loadingView = RSLoadingView()
    loadingView.show(on: UIApplication.shared.keyWindow!)
}
////---------encoded--------

func HideHud(view:UIView)  {
  RSLoadingView.hide(from: UIApplication.shared.keyWindow!)
    
}

//func ShowHud()  {
////    SKActivityIndicator.spinnerStyle(.spinningHalfCircles)
////    SKActivityIndicator.show("Loading....", userInteractionStatus: true)
//    ACProgressHUD.shared.showHUD(withStatus: "Loading...")
//   // ACProgressHUD.showHUD()
//}
/////---------encoded--------
//
//func HideHud()  {
// // SKActivityIndicator.dismiss()
//    ACProgressHUD.shared.hideHUD()
//}



func isConnectedToInternet() ->Bool {
    return NetworkReachabilityManager()!.isReachable
}
func addRightTransitionCollection(containerView:UIView){
    let transition = CATransition()
    transition.duration = 0.3
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromRight
    containerView.layer.add(transition, forKey: kCATransition)
}
func addLeftTransitionCollection(containerView:UIView){
    let transition = CATransition()
    transition.duration = 0.3
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromLeft
    containerView.layer.add(transition, forKey: kCATransition)
}
//func addBarButtonLeftSideOnNavigationBar()
//{
//    let button = UIButton(type: .system)
//    button.setImage(UIImage(named: "Arrow_icon"), for: .normal)
//    // button.setTitle("Categories", for: .normal)
//    button.addTarget(self, action: #selector(showCategories), for: .touchUpInside)
//    button.sizeToFit()
//    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
//}

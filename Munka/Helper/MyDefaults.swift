//
//  MyDefaults.swift
//  SwiftDefaults
//
//  Created by 杉本裕樹 on 2016/01/12.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import SwiftDefaults
class MyDefaults: SwiftDefaults {
    @objc dynamic var value: String? = "10"
    @objc dynamic var isLogin:Bool=false
    @objc dynamic var isDisplayIntroPage:Bool=false
    @objc dynamic var UserId: String!
    @objc dynamic var StripeCustomerId: String!
    @objc dynamic var LoginStatus: String!
    @objc dynamic var UserEmail: String!
    @objc dynamic var UserPassword: String!
    @objc dynamic var SwiftCarId: String!
    @objc dynamic var UDeviceToken: String!
    @objc dynamic var UDeviceId: String? = "8A2496F0-EFD0-4723-8C6D-8E18431A49D2"
    @objc dynamic var swiftUserType: String!
    @objc dynamic var swifLoginType: String?
    @objc dynamic var swifLoginMPIN: String?
    // @objc dynamic var swifUserName: String?
    @objc dynamic var swifProfileType: String!
    @objc dynamic var swifSavePassword: String!
    @objc dynamic var swiftDefaultViewProfile : ViewProfileModelDetail!
    @objc dynamic var swiftDefaultFreelancerProfile : ModelFreelancerProfileDetail!
    @objc dynamic var swiftReviewList = [ModelReviewList]()
    @objc dynamic var maplist = [ModelListViewDetail]()
    
   // @objc dynamic var swifGoogleId: String?
   // @objc dynamic var swifFacebookId: String?
 //   var viewDetails : ModelFreelancerProfileDetail!
    @objc dynamic var swifSignUpMobileNumber: String?
    @objc dynamic var swifCountryCode: String?
    @objc dynamic var swiftRememberMe: Bool = false
    
    @objc dynamic var  swifarrayImages: [UIImage] = []
    
   // @objc dynamic var D_ForgotPassword: String!
//    @objc dynamic var isSignUp : Bool = true
//    @objc dynamic var isEditScreen:Bool=false
//    @objc dynamic var password : String?
//    @objc dynamic var swiftEmail : String?
//    @objc dynamic var isSwiftNotification : Bool = true
//    @objc dynamic var DefaultSetLanguage : String?
    @objc dynamic var swiftUserData : NSDictionary!
    @objc dynamic var swiftFacebookData : NSDictionary!
    @objc dynamic var swiftGoolelData : NSDictionary!
    @objc dynamic var swiftAppleData : NSDictionary!
    //@objc dynamic var swiftFacebookData : NSDictionary!
//  //  @objc dynamic var DefaultsMyPracticeCourse  :MycarRegistrationData!
//  //  @objc dynamic var SwiftAddCart  = [MycarAllCarProduct]()
//
//    @objc dynamic var DefaultSubtotalprice : String!
//    @objc dynamic var DefaultShippingPrice : String? = ""
//    @objc dynamic var DefaultShipMethodName : String!
//    @objc dynamic var DefaultTotalOrderPrice : String!
//    @objc dynamic var DefaultShippingmethodId : String!
//    @objc dynamic var DefaultBadge :Int = 0
//    @objc dynamic var DefaultGetCart  = [MycarGetCart]()
    @objc dynamic var isBeiometicsAuthOn: Bool = false

    
}

class Utility: NSObject {
    
    // MARK: - keyConstent
    struct keyConstent {
        static let saveLanguage = "saveLanguage"
        
    }
    
    // MARK: - Get language Array
    class func getlanguageArray() -> [[String: Any]]{
        return UserDefaults.standard.object(forKey: keyConstent.saveLanguage) as? [[String: Any]] ?? [[String: Any]]()
    }
    
    // MARK: - Set language Array
    class func setlanguageArray(data:[[String: Any]]){
        UserDefaults.standard.set(data, forKey: keyConstent.saveLanguage)
        UserDefaults.standard.synchronize()
    }
}

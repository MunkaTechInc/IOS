//
//  Constant.swift
//  ShibariStudy
//
//  Created by mac on 15/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit


struct ScreenSize{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;
    static let SCREEN_MAX_LENGTH  = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT);
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT);
}
struct DeviceType{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0



}




//let MOBILENUMBEREGEX = "^\+?(972|0)(\-)?0?(([23489]{1}\d{7})|[5]{1}\d{8})$"



let LOGINDATA = "logindata"
let REGISTRAIONDATA = "registrationdata"
let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
let kMapsAPIKey = "AIzaSyB73f501aoG6qyn-9oGyIgb9eVp3lQ_7u0"//"AIzaSyB73f501aoG6qyn-9oGyIgb9eVp3lQ_7u0"
let DUMMY_TEXT = ""

let serverNotFound =  "critical error could not connect to server"
let _0000000 = "000000"
let _151515 = "151515"
let _383838 = "383838"

let C_device_type = "iOS"
let loginTypeGoogle = "2"
let loginTypeFacebook = "1"
let C_FileType = "docs"
//AIzaSyCTVS4kiWGPNemeg1ijLC_Kn206GPNIN1c
//let GOOGLE_APIKEY       = "AIzaSyCTVS4kiWGPNemeg1ijLC_Kn206GPNIN1c"
let GOOGLE_APIKEY       = "AIzaSyAh8PwHA79Eg8bYm-KJH4OKhAJdJ39QmN4"
//let STRIPE_APIKEY       = "pk_test_uy9gGoLmm5AYrT094QjHB9vb00xGoZvoKa"
let STRIPE_APIKEY       = "pk_live_51HCXi0AWuQkXhibTQhefTyBzY6b8rlDvgAZ2cShJxNnLBGuyjJbaFXEb3uNvdRR3AoUCvN7c3IiSwFWeMjRDzmE200gPxrzuvf"
let GOOGLE_CLIENT_KEY = "268740249920-h4101hgs3ttq7ontes19r0e5o5kjecgi.apps.googleusercontent.com"
//let GOOGLE_PLACEPICKER_KEY = "891096346218-udqm5b7o89a7espjq04b0fui15028dit.apps.googleusercontent.com"
let MAPKEY = "AIzaSyAh8PwHA79Eg8bYm-KJH4OKhAJdJ39QmN4"

let Scheme       = "fb312897276347502"
//let Scheme       = "fb497514437679877"
let regexPassword = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{6,12}$"
//https://docs.google.com/spreadsheets/d/1EUPa2COK7PjrXCMjb6EXvDt9dxCFUtrxuCPO6YZzctA/edit#gid=0

let ALERTMESSAGE = "Munka"
var OtheerUserId = ""
//Validation Message

let PasswordMessage = "Use at least one numeric, alphabetic character and one symbol." 
struct FontNames {
    
    struct Lato {
        static let Bold     = "Lato-Bold"
        static let Semibold = "Lato-Semibold"
    }
    
    struct OpenSans {
        static let Bold     = "OpenSans-Bold"
        static let Semibold = "OpenSans-Semibold"
    }
    
    struct Avenir {
        static let Medium       = "Avenir-Medium"
        static let Heavy        = "Avenir-Heavy"
        static let Black        = "Avenir-Black"
        static let Light        = "Avenir-Light"
        static let Book         = "Avenir-Book"
    }
}
 
//KeyConstants.swift

struct PaymentKey {
    
    static let DeviceType = "iOS"
    
    struct PayPal{
        static let production   = "access_token$production$5qzr78fvrr74mw99$a208e5c5ea1afd5496d46a0750837adf"
        static let sandbox = "sandbox_ktqwwb7q_pdggq283vjcygrz5"
        //sandbox_ktqwwb7q_pdggq283vjcygrz5
    }
}

//struct Key {
//    // old credential
//    static let DeviceType = "iOS"
//
//    struct PayPal{
//        static let production   = "Ab9lizOQXTVCbcJhwhSEw7QBga-HgItDHn5a9ThFm8m6i1zIsNuWlNYrODSKmfjHwx5VCYSHMCk-s8Za"
//        static let sandbox      = "AamHWQMjIpGcn2UwIP4AeotML-lfCX2BnVvUtU_4VyGOCIzXrT-VzdrIOZe7EUObNcfRjiEQBcse48gK"
//       // static let sandbox      =  "Ab9lizOQXTVCbcJhwhSEw7QBga-HgItDHn5a9ThFm8m6i1zIsNuWlNYrODSKmfjHwx5VCYSHMCk-s8Za"
//
//       // Ab9lizOQXTVCbcJhwhSEw7QBga-HgItDHn5a9ThFm8m6i1zIsNuWlNYrODSKmfjHwx5VCYSHMCk-s8Za
//
//        //Ab9lizOQXTVCbcJhwhSEw7QBga-HgItDHn5a9ThFm8m6i1zIsNuWlNYrODSKmfjHwx5VCYSHMCk-s8Za
//        //----------- new credential
//        //ravindra Andre persaud
//        //Braintree SDK Credentials
//        //The SDK credentials will be needed when you’re ready to push Express Checkout live to your site.
//        //Hideaccess_token$production$5qzr78fvrr74mw99$a208e5c5ea1afd5496d46a0750837adf
//
//    }
//}

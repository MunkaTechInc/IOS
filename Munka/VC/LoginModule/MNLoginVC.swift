//
//  MNLoginVC.swift
//  Munka
//
//  Created by Amit on 08/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import Toaster
import GoogleSignIn
import AuthenticationServices
import Security

import FBSDKLoginKit
class MNLoginVC: UIViewController, GIDSignInDelegate,GetUserType, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRememberMe: UIButton!
    @IBOutlet weak var btnApple: IBButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            btnApple.isHidden = false
        }else{
            btnApple.isHidden = true
        }
        
        let systemVersion = UIDevice.current.systemVersion
        print("--",systemVersion)
        //        txtEmail.text = "ricky@mailinator.com"
        //        txtPassword.text = "qwerty@1"
        
        //        txtEmail.text = "pooja@getnada.com"
        //        txtPassword.text = "test@123"
        
        //        Individual user
//                txtEmail.text = "iosindividual@mailinator.com"
//                txtPassword.text = "qwert@1"
        
        // freelancer user
//                txtEmail.text = "iosindividual@mailinator.com"
//                txtPassword.text = "qwert@1"
        
//                txtEmail.text = "pooja@getnada.com"
//                txtPassword.text = "test@123"
        
        //        txtEmail.text = "amit@mailinator.com"
        //        txtPassword.text = "R@vindra123"
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        if MyDefaults().swiftRememberMe == true {
            txtEmail.text! = MyDefaults().UserEmail
            txtPassword.text! = MyDefaults().UserPassword
            btnRememberMe.isSelected = true
        }else{
            btnRememberMe.isSelected = false
        }
        
        // Retrieve credentials
        if let savedCredentials = getSavedCredentials() {
            let savedUsername = savedCredentials.username
            let savedPassword = savedCredentials.password
            // Use the retrieved credentials for login
            txtEmail.text! = savedUsername
            txtPassword.text! = savedPassword
        } else {
            print("No saved credentials found")
            // No saved credentials found
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        
    }
    func saveCredentials(username: String, password: String) {
        let credentials = "\(username):\(password)"
        if let data = credentials.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "Munka", // Identifier for the credentials
                kSecValueData as String: data
            ]
            
            SecItemDelete(query as CFDictionary) // Delete existing credentials
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else {
                print("Error saving credentials")
                return
            }
            print("Credentials saved successfully")
        }
    }
    func getSavedCredentials() -> (username: String, password: String)? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "Munka", // Identifier for the credentials
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == errSecSuccess, let retrievedData = dataTypeRef as? Data else {
            print("Error retrieving credentials")
            return nil
        }
        
        if let credentials = String(data: retrievedData, encoding: .utf8)?.components(separatedBy: ":"),
            credentials.count == 2 {
            return (username: credentials[0], password: credentials[1])
        } else {
            print("Invalid credentials format")
            return nil
        }
    }

    // MARK : IBAction Methods
    
    @IBAction func actionOnRememberMe(_ sender: UIButton) {
        //  sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.isSelected = false
            MyDefaults().swiftRememberMe = false
        }else {
            sender.isSelected = true
            MyDefaults().swiftRememberMe = true
            MyDefaults().UserEmail = txtEmail.text!
            MyDefaults().UserPassword = txtPassword.text!
        }
    }
    @IBAction func actionOnForgotPassword(_ sender: UIButton) {
        // let vc = MNForgotPasswordVC() //change this to your class name
        // self.present(vc, animated: true, completion: nil)
        let forgot = self.storyboard?.instantiateViewController(withIdentifier: "MNForgotPasswordVC") as! MNForgotPasswordVC
        self.navigationController?.pushViewController(forgot, animated: true)
    }
    @IBAction func actionOnGoogleSignUp(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().delegate = self
        // GIDSignIn.sharedInstance()?.presentingViewController
        
    }
    
    @IBAction func actionApple(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
                      request.requestedScopes = [.fullName, .email]
                          
                      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                      authorizationController.delegate = self
                      authorizationController.presentationContextProvider = self
                      authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
          
    }
    
    @IBAction func actionOnSIgnIn(_ sender: UIButton) {
        if !isLoginValidation() {
            if  isConnectedToInternet() {
                for textField in self.view.subviews where textField is UITextField {
                    textField.resignFirstResponder()
                }
                MyDefaults().UserEmail = txtEmail.text!
                MyDefaults().UserPassword = txtPassword.text!
                MyDefaults().swifLoginType = "email"
                self.saveCredentials(username: txtEmail.text!, password: txtPassword.text!)
                self.callServiceLoginAPI(email: "", password: "", appleId: "", facebookId: "", googleId: "")
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    @IBAction func actionOnSIgnUP(_ sender: UIButton) {
        let popup : WelcomePopupVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "WelcomePopupVC") as! WelcomePopupVC
        popup.delagate = self
        self.presentOnRoot(with: popup)
    }
    @IBAction func actionOnfacebook(_ sender: UIButton) {
        
        if AccessToken.current != nil {
            self.getFBUserData()
            return
        }
        
        let fbLoginManager : LoginManager = LoginManager()
        LoginManager().logOut()
        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                }
            }
        }
    }
    func socilLoginPopUp()  {
        let popup : WelcomePopupVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "WelcomePopupVC") as! WelcomePopupVC
        popup.delagate = self
        self.presentOnRoot(with: popup)
    }
    func isLoginValidation() -> Bool {
        guard let email = txtEmail.text , email != ""
            else {showAlert(title: ALERTMESSAGE, message: "Please enter email address.")
                return true}
        guard let password = txtPassword.text , password != ""
            else {showAlert(title: ALERTMESSAGE, message: "Please enter password.")
                return true}
        return false
    }
    func callServiceLoginAPI(email:String,password:String,appleId:String,facebookId:String,googleId:String) {
        ShowHud(view: self.view)
        
        
        let parameter: [String: Any] = ["login_type":MyDefaults().swifLoginType!,
                                        "device_id":MyDefaults().UDeviceId ?? "343434343",
                                        "device_type":C_device_type,
                                        "fb_id":facebookId,
                                        "apple_id":appleId,
                                         "google_id":googleId,
                                        "password":txtPassword.text!,
                                        "email":txtEmail.text!]
        debugPrint(parameter)
        HTTPService.callForPostApi(url:MNLoginAPI , parameter: parameter) { (response) in
            debugPrint(response)
            HideHud(view: self.view)
            if response.count != nil {
                let status = response["status"] as! String
                let message = response["msg"] as! String
                if status == "1"
                {
                    let responseData = response["details"] as! [String: Any]
                    MyDefaults().swifCountryCode = responseData["country_code"] as? String
                    MyDefaults().swifSignUpMobileNumber = responseData["mobile"] as? String
                    MyDefaults().UserId = responseData["user_id"] as? String
                    MyDefaults().UDeviceToken = responseData["mobile_auth_token"] as? String
                    MyDefaults().StripeCustomerId = responseData["stripeCustomerId"] as? String

                    if status == "1" && message == "Login Successfully"
                    {
                        MyDefaults().swifSavePassword = self.txtPassword.text
                        MyDefaults().swiftUserData = responseData as NSDictionary
                        MyDefaults().LoginStatus = "1"
                        UserDefaults.standard.set(true, forKey: "isLogIn")
                        UserDefaults.standard.synchronize()
                        
                       if let tabbar = (storyBoard.tabbar.instantiateViewController(withIdentifier: "tabbar") as? MainTabbarVC) {
                            self.navigationController?.isNavigationBarHidden = true
                            
                            MyDefaults().isLogin = true
                           
                            UserDefaults.standard.set(false, forKey: "isDisplayIntroPage")
                            UserDefaults.standard.synchronize()
                            
                            
                            tabbar.selectedIndex = 2
                            self.navigationController?.pushViewController(tabbar, animated: true)
                            
                 
                            // self.navigationController?.navigationBar.isHidden = true
                            
                            
                            //  self.present(tabbar, animated: true, completion: nil)
                            //  Toast(text: message).show()
                        }
                    }else if responseData["mobile_verified"] as? String == "2" && message == "Your account is not verified yet, one-time verification code sent on your registered email address and mobile number."
                    {
                        self.pushVerificationScreen(verifyScreen: "Mobile")
                    }
                    else if responseData["email_verified"] as? String == "2" && message == "Your account is not verified yet, one-time verification code sent on your registered email address."
                    {
                        self.pushVerificationScreen(verifyScreen: "")
                    }
                }
                else
                {
                    self.showErrorPopup(message: message, title: alert)
                }}else{
                self.showErrorPopup(message: serverNotFound, title: alert)
            }
            
        }
    }
    func pushVerificationScreen(verifyScreen:String) {
        if verifyScreen == "Mobile"{
            let mobile = self.storyboard?.instantiateViewController(withIdentifier: "MNMobileVarificationVC") as! MNMobileVarificationVC
            self.navigationController?.pushViewController(mobile, animated: true)
        }else{
            let mobile = self.storyboard?.instantiateViewController(withIdentifier: "MNEmailVerificationVC") as! MNEmailVerificationVC
            self.navigationController?.pushViewController(mobile, animated: true)
        }
    }
    func getFBUserData(){
        //  ShowHud()
        if(AccessToken.current != nil){
            
            let request = GraphRequest(graphPath: "me", parameters: ["fields": "id,name , first_name, last_name , email,picture.type(large)"])
            request.start() { connection, result, error in
                if let result = result, error == nil {
                    print("fetched user: \(result)")
                    guard let Info = result as? [String: Any] else { return }
                    
                    if let imageURL = ((Info["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        //Download image from imageURL
                        // print(imageURL)
                    }
                    let strName = Info["name"] as! String
                    let strFirstName = Info["first_name"] as! String
                    let last_name = Info["last_name"] as! String
                    let userId = Info["id"] as! String
                    let email = Info["email"] as! String
                    MyDefaults().swiftGoolelData = nil
                    MyDefaults().swiftFacebookData = Info as NSDictionary
                    // self.callServiceLoginLoginAPI(email: email, password: "", facebookId: userId, googleId: "")
                    
                    // print(imageURL)
                    MyDefaults().swifLoginType = "facebook"
                    
                    // HideHud()
                    self.socilLoginPopUp()
                    if(error == nil){
                        // print("result")
                    }

                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //  ShowHud(view: self.view)
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        //        let userId = user.userID!                  // For client-side use only!
        //        let idToken = user.authentication.idToken // Safe to send to the server
        //        let fullName = user.profile.name
        //        let givenName = user.profile.givenName
        //        let familyName = user.profile.familyName
        //         let email = user.profile.email
        
        
        
        MyDefaults().swiftFacebookData = nil
        
        //HideHud()
        HideHud(view: self.view)
        
        let fullNameArr = user.profile.name.components(separatedBy: " ")
        let firstName: String = fullNameArr[0]
        // var lastName: String = fullNameArr[1]
        let last_Name: String? = fullNameArr.count > 1 ? fullNameArr[1] : nil
        MyDefaults().swifLoginType = "google"
        var dictionary =  [String:String]()
        
        if firstName.isEmpty {
            dictionary.updateValue("", forKey: "first_name")
        }else{
            dictionary.updateValue(firstName, forKey: "first_name")
        }
        if let  last_Name = last_Name,last_Name.isEmpty  {
            dictionary.updateValue("", forKey: "last_name")
        }else{
            dictionary.updateValue(last_Name ?? "", forKey: "last_name")
        }
        if user.profile.email.isEmpty {
            dictionary.updateValue("", forKey: "email")
        }else{
            dictionary.updateValue(user.profile.email, forKey: "email")
        }
        if user.userID! .isEmpty {
            dictionary.updateValue(user.userID , forKey: "id")
        }else{
            dictionary.updateValue(user.userID, forKey: "id")
        }
        MyDefaults().swiftGoolelData = dictionary as NSDictionary
        
        self.socilLoginPopUp()
        
    }
    func sign(_ signIn: GIDSignIn!,dismiss viewController: UIViewController!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    // MARK: -  Custom Delegate Methods
    func DelegateUserType(UserType:Int){
        switch UserType {
        case 101:
            let vc = storyBoard.Main.instantiateViewController(withIdentifier: "MNIndividualSignupVC") as! MNIndividualSignupVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 102:
            let vc = storyBoard.Main.instantiateViewController(withIdentifier: "MNProfessionalSignupVC") as! MNProfessionalSignupVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            // executable code
            break
        }
    }
    
    //MARK:- APPLE INTEGRATON
    //TODO:- ASAuthorizationControllerDelegate
    // ASAuthorizationControllerDelegate function for successful authorization
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email
            print("userIdentifier:",userIdentifier,"userFirstName:",userFirstName,"userLastName:",userLastName,"userEmail:",userEmail)
             
            //MyDefaults().swiftAppleData = Info as NSDictionary
            
            var dictionary =  [String:String]()
            dictionary.updateValue(userFirstName ?? "", forKey: "first_name")
            dictionary.updateValue(userLastName ?? "", forKey: "last_name")
            dictionary.updateValue(userEmail ?? "", forKey: "email")
            dictionary.updateValue(userIdentifier, forKey: "id")
            MyDefaults().swifLoginType = "apple"
            MyDefaults().swiftFacebookData = nil
            MyDefaults().swiftGoolelData = nil
            MyDefaults().swiftGoolelData = dictionary as NSDictionary
            self.socilLoginPopUp()
            
            //Navigate to other view controller
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            txtEmail.text = username
            txtPassword.text = password
            
            //Navigate to other view controller
        }
    }
    
    //TODO:- authorizationController
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorizationController didCompleteWithError :",error.localizedDescription)
        //Handle error here
    }
    
    //TODO:- presentationAnchor
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}


//MARK:- text Filed Delegate
extension MNLoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtEmail:
            txtPassword.becomeFirstResponder()
        case txtPassword:
            txtPassword.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

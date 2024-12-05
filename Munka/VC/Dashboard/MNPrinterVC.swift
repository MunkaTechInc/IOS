//
//  MNPrinterVC.swift
//  Munka
//
//  Created by Amit on 30/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import WebKit
class MNPrinterVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
     var webview2: WKWebView!
     var contractId = ""
    var isProfile = ""
    var profileUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    if  isConnectedToInternet() {
        self.callServiceForPrinterAPI()
        } else {
    self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        if isProfile == "profile" {
        let myURL = URL(string: profileUrl)
        let myRequest = URLRequest(url: myURL!)
        webview2.load(myRequest)
        }
    }
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webview2 = WKWebView(frame: .zero, configuration: webConfiguration)
        webview2.uiDelegate = self
        webview2.navigationDelegate = self
        view = webview2
    }

    @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
            }
        }
    
   
   func callServiceForPrinterAPI() {
//        ShowHud()
    ShowHud(view: self.view)

       print(MyDefaults().UserId ?? "")
        let parameter: [String: Any] = ["user_id":MyDefaults().UserId ?? "",
                                      "mobile_auth_token":MyDefaults().UDeviceToken ?? "",
                                      "contract_id":contractId]
         debugPrint(parameter)
         HTTPService.callForPostApi(url:MNGetPrinterAPI , parameter: parameter) { (response) in
             debugPrint(response)
        //  HideHud()
HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                let responseDict = response["details"] as! [String : Any]
                print(response)
                let urls = responseDict["contract_pdf"] as! String
                self.loadUrl(urlString:img_BASE_URL + urls)
            } else if status == "4"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)

            }}
             else
             {
                 self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
             }
            
         }
    }
    func loadUrl(urlString:String) {
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        webview2.load(myRequest)
    }
    
}


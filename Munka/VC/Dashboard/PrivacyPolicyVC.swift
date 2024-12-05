//
//  PrivacyPolicyVC.swift
//  Munka
//
//  Created by Amit on 19/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController,WKNavigationDelegate,WKUIDelegate {
    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var lblData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let request = URLRequest(url: URL(string: MNPrivacyPolicyAPI)!)
//        webView?.load(request)
        // Do any additional setup after loading the view.
        getPrivacyPolicy()
    }
    
    func getPrivacyPolicy() {
        ShowHud(view: self.view)

        let parameter: [String: Any] = [:]
         debugPrint(parameter)
         HTTPService.callForGetApi(url: MNPrivacyPolicyAPI) { (response) in
             debugPrint(response)

          //HideHud()
            HideHud(view: self.view)
            if response.count != nil {
            let status = response["status"] as! String
             let message = response["msg"] as! String
             if status == "1"
             {
                 print(response)
                let response = StaticModelDetail.init(fromDictionary: response as! [String : Any])
                 print(response.result.content.htmlToString)
                 self.lblData.attributedText = response.result.content.htmlToAttributedString
//                self.setUI()
            } else if status == "4"
            {
                self.autoLogout(title: ALERTMESSAGE, message: message)
             }
             else
             {
                 self.showErrorPopup(message: message, title: ALERTMESSAGE)
            }}
        else
        {
            self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
        }
            
         }
    }
    
    @IBAction func actionOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//
//  TermsAndConditionViewController.swift
//  Squable
//
//  Created by Harish Patidar on 19/01/19.
//  Copyright © 2019 Harish Patidar. All rights reserved.
//

import UIKit
import Alamofire
import WebKit
class TermsAndConditionViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {
    
    //MARK:- Outlets
  
   
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var lblData: UILabel!
    
    //MARK:-  Properties
    var htmlString : String = ""
    var isFromHsitory : Bool = false

    //MARK:- View Controller Life Cycle Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

//        let request = URLRequest(url: URL(string: MNIndividualOfferTermsCondtinsAPI)!)
//        webView?.load(request)
        getTermsData()
    }

        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func getTermsData() {
        ShowHud(view: self.view)

        let parameter: [String: Any] = [:]
         debugPrint(parameter)
         HTTPService.callForGetApi(url: MNIndividualOfferTermsCondtinsAPI) { (response) in
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
     
    
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//    title = webView.title
//    }
      
//    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
//        print(error.localizedDescription)
//    }
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print("Strat to load")
//    }
////    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
////        print("finish to load")
////    }
//    }
}

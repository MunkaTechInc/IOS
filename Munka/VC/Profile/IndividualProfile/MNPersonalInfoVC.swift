//
//  MNPersonalInfoVC.swift
//  Munka
//
//  Created by Amit on 25/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNPersonalInfoVC: UIViewController {
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
   // @IBOutlet weak var txtViewAboutus: UITextView!
    @IBOutlet weak var lblViewAboutus: UILabel!
    @IBOutlet weak var imgGovId: UIImageView!
    @IBOutlet weak var imgResume: UIImageView!
    
    @IBOutlet weak var viewResume: UIView!
    @IBOutlet weak var viewResumeHight: NSLayoutConstraint!
    
    @IBOutlet weak var viewGovtId: UIView!
    @IBOutlet weak var viewGovtIdHight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var btnGovId: UIButton!
    @IBOutlet weak var btnResume: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewResume.isHidden = true
        viewResumeHight.constant = 0
        // Do any additional setup after loading the view.
       
            //MyDefaults().swiftDefaultFreelancerProfil
        lblEmailAddress.text = MyDefaults().swiftDefaultFreelancerProfile.email!
            lblCountryCode.text =  MyDefaults().swiftDefaultFreelancerProfile.countryCode!
            lblContactNumber.text = self.formatPhone(MyDefaults().swiftDefaultFreelancerProfile.mobile!)
        lblAddress.text = MyDefaults().swiftDefaultFreelancerProfile.address!
        lblViewAboutus.text = MyDefaults().swiftDefaultFreelancerProfile.aboutUs!
          
            
            
            if MyDefaults().swiftDefaultFreelancerProfile.resume.isEmpty {
               // print("false")
                viewResume.isHidden = true
                viewResumeHight.constant = 0
            }else{
                print("true")
                viewResume.isHidden = false
                viewResumeHight.constant = 66
            }
            
            self.imgResume.sd_setImage(with: URL(string:img_BASE_URL + MyDefaults().swiftDefaultFreelancerProfile.resume!), placeholderImage:#imageLiteral(resourceName: "ic_category_doc"))
        
        if Constant.isFreelancer == "individual" {
            viewGovtId.isHidden = true
            viewGovtIdHight.constant = 0
        }else{
            self.imgGovId.sd_setImage(with: URL(string:img_BASE_URL + MyDefaults().swiftDefaultFreelancerProfile.document!), placeholderImage:#imageLiteral(resourceName: "ic_category_doc"))
        }
    
    
    
    }
    private func formatPhone(_ number: String) -> String {
        let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
       
        var format: [Character]!
        if number.count == 10
        {
            format = [ "X", "X", "X", "-", "X", "X", "X", "-", "X", "X", "X", "X"]
        }
        else
        {
            format = ["X", "-", "X", "X", "X", "-", "X", "X", "X", "-", "X", "X", "X", "X"]
        }
        var result = ""
        var index = cleanNumber.startIndex
        for ch in format {
            if index == cleanNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    @IBAction func actionOnGovtId(_ sender: Any) {
    let details = storyBoard.Main.instantiateViewController(withIdentifier: "MNPrinterVC") as! MNPrinterVC
           //details.contractId = contractId
          
        details.isProfile = "profile"
        details.profileUrl = "http://192.168.2.193/munka/" + MyDefaults().swiftDefaultFreelancerProfile.document!
        self.navigationController?.pushViewController(details, animated: true)
    }
    @IBAction func actionOnResume(_ sender: Any) {
    let details = storyBoard.Main.instantiateViewController(withIdentifier: "MNPrinterVC") as! MNPrinterVC
           details.isProfile = "profile"
                 details.profileUrl = "http://192.168.2.193/munka/" + MyDefaults().swiftDefaultFreelancerProfile.resume!
           self.navigationController?.pushViewController(details, animated: true)
    }
}

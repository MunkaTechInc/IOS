//
//  MNPersonalInfoIndividualVC.swift
//  Munka
//
//  Created by Amit on 10/01/20.
//  Copyright © 2020 Amit. All rights reserved.
//

import UIKit
class MNPersonalInfoIndividualVC: UIViewController {
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
   // @IBOutlet weak var txtViewAboutus: UITextView!
    @IBOutlet weak var lblViewAboutus: UILabel!
    @IBOutlet weak var imgGovId: UIImageView!
//    @IBOutlet weak var imgResume: UIImageView!
//
//    @IBOutlet weak var viewResume: UIView!
    @IBOutlet weak var viewGovtIdHight: NSLayoutConstraint!
    @IBOutlet weak var viewGovtId: UIView!
    
    @IBOutlet weak var btnGovId: UIButton!
    @IBOutlet weak var btnResume: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewResume.isHidden = true
//        viewResumeHight.constant = 0
        // Do any additional setup after loading the view.
       
        lblEmailAddress.text = MyDefaults().swiftDefaultViewProfile.email!
                   lblCountryCode.text =  MyDefaults().swiftDefaultViewProfile.countryCode!
                   lblContactNumber.text = self.formatPhone(MyDefaults().swiftDefaultViewProfile.mobile!)
                   lblAddress.text = MyDefaults().swiftDefaultViewProfile.address!
                   lblViewAboutus.text = MyDefaults().swiftDefaultViewProfile.aboutUs!
                   
        if Constant.isIndividual == "freelancer" {
                self.viewGovtIdHight.constant = 0
                self.viewGovtId.isHidden = true
        }else{
                    self.imgGovId.sd_setImage(with: URL(string:img_BASE_URL + MyDefaults().swiftDefaultViewProfile.document!), placeholderImage:#imageLiteral(resourceName: "ic_category_doc"))
                    self.imgGovId.sd_setImage(with: URL(string:img_BASE_URL + MyDefaults().swiftDefaultViewProfile.document!), placeholderImage:#imageLiteral(resourceName: "ic_category_doc"))
           
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
    let popup : FullImagePopVC = storyBoard.PopUp.instantiateViewController(withIdentifier: "FullImagePopVC") as! FullImagePopVC
   // popup.delagate = self
        popup.imge = img_BASE_URL + MyDefaults().swiftDefaultViewProfile.document!
    print(popup.imge)
        self.presentOnRoot(with: popup)
    }
}

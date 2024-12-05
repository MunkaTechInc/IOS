//
//  MNLeaveAFeedbackPopUpVC.swift
//  Munka
//
//  Created by Amit on 12/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNLeaveAFeedbackPopUpVC: UIViewController {
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
        var strfeedback = ""
        var profileImage = ""
        var name = ""
        var employefeedback = ""
        var isFeedback : Bool = false
        var jobId = ""
        var postedBy = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = name
        // Do any additional setup after loading the view.
        self.imgView.sd_setImage(with: URL(string:img_BASE_URL + profileImage), placeholderImage:#imageLiteral(resourceName: "phl_square_profile"))
    }
    @IBAction func actionOnCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOnGood(_ sender: UIButton) {
        strfeedback = "Good"
        self.PresentWillWorkpopUp()
    }
    @IBAction func actionOnAverage(_ sender: UIButton) {
        strfeedback = "Average"
        self.PresentWillWorkpopUp()
    }
    @IBAction func actionOnBad(_ sender: UIButton) {
        strfeedback = "Bad"
        self.PresentWillWorkpopUp()
    }
    func PresentWillWorkpopUp() {
        let details = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNLeaveReviewFreelancerPopUpVC") as! MNLeaveReviewFreelancerPopUpVC
            // details.isFreelauncer = true
        details.profileImage = profileImage
        details.name = name
        details.employefeedback = strfeedback
        details.jobId = jobId
        details.postedBy = postedBy
        self.navigationController?.pushViewController(details, animated: true)
    }
}


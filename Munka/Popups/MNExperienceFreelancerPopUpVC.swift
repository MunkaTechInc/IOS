//
//  MNExperienceFreelancerPopUpVC.swift
//  Munka
//
//  Created by Amit on 12/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNExperienceFreelancerPopUpVC: UIViewController {
    @IBOutlet weak var imgView : UIImageView!
       @IBOutlet weak var lblName : UILabel!
           var strfeedback = ""
           var profileImage = ""
           var name = ""
            var employefeedback = ""
            var workAgain = ""
            var jobId = ""
            var postedBy = ""
            var experience = ""
        var isFeedback : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = name
        // Do any additional setup after loading the view.
        self.imgView.sd_setImage(with: URL(string:img_BASE_URL + profileImage), placeholderImage:#imageLiteral(resourceName: "phl_square_profile"))
        // Do any additional setup after loading the view.
    }
    @IBAction func actionOnCross(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
       @IBAction func actionOnGood(_ sender: UIButton) {
           strfeedback = "Good"
          self.PresentWillExperiencepopUp()
        }
       @IBAction func actionOnAverage(_ sender: UIButton) {
           strfeedback = "Average"
           self.PresentWillExperiencepopUp()
       }
       @IBAction func actionOnBad(_ sender: UIButton) {
           strfeedback = "Bad"
           self.PresentWillExperiencepopUp()
       }

    func PresentWillExperiencepopUp() {
        let details = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNFeedbackFreelancerPopVC") as! MNFeedbackFreelancerPopVC
        // details.isFreelauncer = true
        details.profileImage = profileImage
        details.name = name
        details.workAgain = workAgain
        details.employefeedback = employefeedback
        details.experience = strfeedback
        details.jobId = jobId
        details.postedBy = postedBy
        
    self.navigationController?.pushViewController(details, animated: true)
    }

}

//
//  MNLeaveReviewFreelancerPopUpVC.swift
//  Munka
//
//  Created by Amit on 12/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

protocol WillYouworkAgain {
    func delegatewillyouworkAgain(string:String,isWillWork:Bool)
}
class MNLeaveReviewFreelancerPopUpVC: UIViewController {
   @IBOutlet weak var imgView : UIImageView!
      @IBOutlet weak var lblName : UILabel!
    var delagate: WillYouworkAgain!
        var workAgain = ""
        var profileImage = ""
        var name = ""
        var employefeedback = ""
        var jobId = ""
        var postedBy = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = name
                  // Do any additional setup after loading the view.
        self.imgView.sd_setImage(with: URL(string:img_BASE_URL + profileImage), placeholderImage:#imageLiteral(resourceName: "phl_square_profile"))
        // Do any additional setup after loading the view.
    }
    @IBAction func actionOnCross(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    
    }
    @IBAction func actionOnYes(_ sender: UIButton) {
        workAgain = "Yes"
        self.PresentWillExperiencepopUp()
    }
    @IBAction func actionOnNo(_ sender: UIButton) {
        workAgain = "No"
        self.PresentWillExperiencepopUp()
    }
    func PresentWillExperiencepopUp() {

    
    let details = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNExperienceFreelancerPopUpVC") as! MNExperienceFreelancerPopUpVC
        // details.isFreelauncer = true
        details.profileImage = profileImage
        details.name = name
        details.workAgain = workAgain
        details.employefeedback = employefeedback
        details.jobId = jobId
         details.postedBy = postedBy
    self.navigationController?.pushViewController(details, animated: true)
    }
   
}

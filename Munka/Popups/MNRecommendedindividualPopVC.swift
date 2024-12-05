//
//  MNRecommendedindividualPopVC.swift
//  Munka
//
//  Created by Amit on 16/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNRecommendedindividualPopVC: UIViewController {
    @IBOutlet weak var imgView : UIImageView!
      @IBOutlet weak var lblName : UILabel!
        var profileImage = ""
        var name = ""
       
        var jobId = ""
        var postedBy = ""
        var arraiveOnTime = ""
        var recommend = ""
        var contractId = ""
      // var name = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imgView.sd_setImage(with: URL(string:img_BASE_URL + profileImage), placeholderImage:#imageLiteral(resourceName: "phl_circle_profile.png"))
        lblName.text! = name
    }
    
    @IBAction func actionOnYes(_ sender: UIButton) {
     let details = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNHierAgainIndividualPopVC") as! MNHierAgainIndividualPopVC
            details.jobId = jobId
            details.contractId   =  contractId
            details.postedBy   =  postedBy
            details.profileImage   =  profileImage
            details.arraiveOnTime   =  arraiveOnTime
            details.recommend   =  "Yes"
            details.name   =  name
           // print(details)
        self.navigationController?.pushViewController(details, animated: false)
     }
     @IBAction func actionOnNo(_ sender: UIButton) {
     let details = storyBoard.PopUp.instantiateViewController(withIdentifier: "MNHierAgainIndividualPopVC") as! MNHierAgainIndividualPopVC
            details.jobId = jobId
            details.contractId   =  contractId
            details.postedBy   =  postedBy
            details.profileImage   =  profileImage
            details.arraiveOnTime   =  arraiveOnTime
            details.recommend   =  "No"
           // details.name   =  name
         print(details)
        self.navigationController?.pushViewController(details, animated: false)
     }
    @IBAction func actionOnBack(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: false)
           }
}

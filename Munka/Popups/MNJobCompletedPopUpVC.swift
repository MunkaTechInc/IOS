//
//  MNJobCompletedPopUpVC.swift
//  Munka
//
//  Created by Amit on 14/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
protocol GetJobCompleted {
    
    func delegetJobCompleted(JobId:String,JobStatus:String,wantToPay:String,ContractID:String)
}
class MNJobCompletedPopUpVC: UIViewController {
    var delagate: GetJobCompleted!
    var JobId = ""
    var jobStatus = ""
    var wantToPay  = ""
    var ContractId = ""
    @IBOutlet weak var viewPopUp:UIView!
    @IBOutlet weak var lblNote:UILabel!
    
    var isCompletedJob : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.viewPopUp.roundCornersBottomSide(corners: ([.topLeft, .topRight]), radius: 10)
        // Do any additional setup after loading the view.
    }
    @IBAction func actionOnYes(_ sender: UIButton) {
    if self.delagate != nil {
        self.dismiss(animated: true, completion: nil)
        self.delagate.delegetJobCompleted(JobId: JobId, JobStatus: jobStatus, wantToPay: wantToPay, ContractID: ContractId)
     }
      }
    @IBAction func actionOnNotNow(_ sender: UIButton) {
       self.dismiss(animated: true, completion: nil)
//        if self.delagate != nil {
//        self.delagate.delegetJobCompleted(JobId: JobId, JobStatus: jobStatus, wantToPay: wantToPay, ContractID: ContractId)
//       }
         }
    @IBAction func actionOnBackGround(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
      }
}

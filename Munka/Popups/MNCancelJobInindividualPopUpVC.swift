//
//  MNCancelJobInindividualPopUpVC.swift
//  Munka
//
//  Created by Amit on 17/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
protocol getCancelJobFromIndividual {
    
    func delegateCancelJobForindividual(jobStatus:String,jobId:String,ContractId:String,wantToPay:String)
}

class MNCancelJobInindividualPopUpVC: UIViewController {
    var jobStatus = ""
    var jobId = ""
    var ContractId = ""
    var wantToPay = ""
    var delagate: getCancelJobFromIndividual!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func actionOnTouchUp(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionOnYes(_ sender: UIButton) {
       
    self.dismiss(animated: true, completion: nil)
           if self.delagate != nil {
            self.delagate.delegateCancelJobForindividual(jobStatus: jobStatus, jobId: jobId, ContractId: ContractId, wantToPay: "Yes")
          }
          
    }
    @IBAction func actionOnNo(_ sender: UIButton) {
       
     if self.delagate != nil {
       self.delagate.delegateCancelJobForindividual(jobStatus: jobStatus, jobId: jobId, ContractId: ContractId, wantToPay: "No")
     }
             
    }
}

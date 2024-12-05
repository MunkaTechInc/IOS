//
//  HierPopUpVC.swift
//  Munka
//
//  Created by Amit on 03/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
protocol GetUserHier {
    func delegateForUserHier()
    func delegateForRefreshAPI()
}
class HierPopUpVC: UIViewController {
    var applyedBy = ""
     var jobId = ""
    var delagate: GetUserHier!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func actionMoveToChat(_ sender: UIButton) {
        //self.callServiceForSaveJobAPI()
    }
    @IBAction func actionOnackground(_ sender: UIButton) {
        if self.delagate != nil {
    //self.dismiss(animated: true, completion: nil)
    self.delagate.delegateForRefreshAPI()
    self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func actionOnMoveToContract(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
    if self.delagate != nil {
        //self.dismiss(animated: true, completion: nil)
        self.delagate.delegateForUserHier()
        self.dismiss(animated: true, completion: nil)
    }
    
    }
}

    
    
    


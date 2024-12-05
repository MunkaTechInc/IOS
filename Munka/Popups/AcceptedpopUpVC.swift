//
//  AcceptedpopUpVC.swift
//  Munka
//
//  Created by Amit on 03/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
protocol GetUseContractInfo {
    func delegateForContarctInfo()
    func delegateForMovetochat(intTag:Int)
}
class AcceptedpopUpVC: UIViewController {
var delagate: GetUseContractInfo!
    var indexValue : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionMoveToChat(_ sender: UIButton) {
       
        if self.delagate != nil {
        self.dismiss(animated: true, completion: nil)
            self.delagate.delegateForMovetochat(intTag: indexValue)
    }
    }
    @IBAction func actionOnackground(_ sender: UIButton) {
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionOnMoveToContract(_ sender: UIButton) {
         if self.delagate != nil {
               //self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
            self.delagate.delegateForContarctInfo()
        }
    }
}

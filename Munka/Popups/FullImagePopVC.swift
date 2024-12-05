//
//  FullImagePopVC.swift
//  Munka
//
//  Created by Amit on 10/01/20.
//  Copyright © 2020 Amit. All rights reserved.
//

import UIKit

class FullImagePopVC: UIViewController {
@IBOutlet weak var profileImage: UIImageView!
    var imge = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.sd_setImage(with: URL(string:imge), placeholderImage:#imageLiteral(resourceName: "ic_category_doc"))
        // Do any additional setup after loading the view.
    }
    
@IBAction func actionOnBackgorund(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    }
   
}

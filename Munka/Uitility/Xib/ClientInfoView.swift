//
//  ClientInfoView.swift
//  PainChek
//
//  Created by Sushobhit on 29/08/18.
//  Copyright © 2018 Amit Dwivedi. All rights reserved.
//

import UIKit

class ClientInfoView: UIView,FloatRatingViewDelegate {

    @IBOutlet weak var imgMunka:UIImageView!
    @IBOutlet weak var btnWindow:UIButton!
//    @IBOutlet weak var lblAddress:UILabel!
//    @IBOutlet weak var imRetruent:UIImageView!
//   @IBOutlet weak var lblRating:UILabel!
//   // @IBOutlet weak var HightConstrainsofview:NSLayoutConstraint!
//    @IBOutlet var floatRatingView: FloatRatingView!
    
    
    override func awakeFromNib()  {
       // floatRatingView.delegate = self
        //floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        //floatRatingView.type = .halfRatings
        //floatRatingView.maxRating = 5
       
   // viewTringle = self.viewTringle
    
    
    }
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ClientInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}

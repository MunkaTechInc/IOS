//
//  ListviewTableViewCell.swift
//  Munka
//
//  Created by Amit on 30/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class ListviewTableViewCell: UITableViewCell {
 
        @IBOutlet weak var milesDecimal:UILabel!
        @IBOutlet weak var lblStartDate:UILabel!
       @IBOutlet weak var lblJobDescription:UILabel!
        @IBOutlet weak var lblEndDate:UILabel!
      
       @IBOutlet weak var lblAddress:UILabel!
       @IBOutlet weak var lblPostedDate:UILabel!
       @IBOutlet weak var lblMiles:UILabel!
    @IBOutlet weak var lblHour:UILabel!
    @IBOutlet weak var lblFix:UILabel!
         @IBOutlet weak var lblTitle:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

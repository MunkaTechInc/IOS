//
//  SavejobsTableViewCell.swift
//  Munka
//
//  Created by Amit on 28/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class SavejobsTableViewCell: UITableViewCell {
       @IBOutlet weak var btnDelete:UIButton!
        @IBOutlet weak var lblName:UILabel!
        @IBOutlet weak var lblStartDate:UILabel!
        @IBOutlet weak var lblEndDate:UILabel!
        @IBOutlet weak var lblDays:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

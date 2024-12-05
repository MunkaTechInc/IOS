//
//  MyjobsTableViewCell.swift
//  Munka
//
//  Created by Amit on 27/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MyjobsTableViewCell: UITableViewCell {
    @IBOutlet weak var imgMyjobs:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblAssign:UILabel!
    @IBOutlet weak var lblStartDate:UILabel!
    @IBOutlet weak var lblEndDate:UILabel!
    @IBOutlet weak var lblHour:UILabel!
    @IBOutlet weak var lblStatus:UILabel!
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

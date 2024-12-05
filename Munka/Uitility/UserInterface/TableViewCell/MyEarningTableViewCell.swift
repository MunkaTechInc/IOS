//
//  MyEarningTableViewCell.swift
//  Munka
//
//  Created by Amit on 21/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MyEarningTableViewCell: UITableViewCell {
    @IBOutlet weak var lblStartdate:UILabel!
    @IBOutlet weak var lblEnddate:UILabel!
    @IBOutlet weak var lblJobtitle:UILabel!
    @IBOutlet weak var lblScienceMember:UILabel!
    @IBOutlet weak var lblNameStatus:UILabel!
    @IBOutlet weak var lblDays:UILabel!
    @IBOutlet weak var lblAmount:UILabel!
    @IBOutlet weak var imgView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  FreelancerProgressdetailTableViewCell.swift
//  Munka
//
//  Created by Amit on 28/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class FreelancerProgressdetailTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblFix: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

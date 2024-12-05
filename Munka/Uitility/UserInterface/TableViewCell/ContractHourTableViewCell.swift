//
//  ContractHourTableViewCell.swift
//  Munka
//
//  Created by Amit on 03/01/20.
//  Copyright © 2020 Amit. All rights reserved.
//

import UIKit

class ContractHourTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblStartTime:UILabel!
    @IBOutlet weak var lblEndTime:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

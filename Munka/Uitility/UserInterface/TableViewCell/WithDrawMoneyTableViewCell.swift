//
//  WithDrawMoneyTableViewCell.swift
//  Munka
//
//  Created by Amit on 17/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class WithDrawMoneyTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCreatedDate:UILabel!
    @IBOutlet weak var lblCreatedTime:UILabel!
    @IBOutlet weak var lblDescriptions:UILabel!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var lblAmmount:UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

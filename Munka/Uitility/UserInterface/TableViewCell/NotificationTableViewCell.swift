//
//  NotificationTableViewCell.swift
//  Munka
//
//  Created by Amit on 19/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDate:UILabel!
     @IBOutlet weak var lblJobtitle:UILabel!
    @IBOutlet weak var lblJobStatus:UILabel!
     
    @IBOutlet weak var lblDescriptions:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

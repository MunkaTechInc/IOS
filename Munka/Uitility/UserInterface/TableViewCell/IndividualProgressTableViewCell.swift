//
//  IndividualProgressTableViewCell.swift
//  Munka
//
//  Created by Amit on 11/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class IndividualProgressTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblJobTitle:UILabel!
    @IBOutlet weak var lblDescriptions:UILabel!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var btnCancel:UIButton!
    @IBOutlet weak var btnStart:UIButton!
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

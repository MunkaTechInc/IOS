//
//  CountryListTableViewCell.swift
//  Munka
//
//  Created by Amit on 08/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCountryName:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

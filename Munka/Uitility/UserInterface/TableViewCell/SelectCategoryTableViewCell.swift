//
//  SelectCategoryTableViewCell.swift
//  Munka
//
//  Created by Amit on 15/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class SelectCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCategoryName:UILabel!
    @IBOutlet weak var btnCategory:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

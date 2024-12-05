//
//  FreelancerServiceVC TableViewCell.swift
//  Munka
//
//  Created by Amit on 30/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class FreelancerServiceVC_TableViewCell: UITableViewCell {
    @IBOutlet weak var lblCountryName:UILabel!
    @IBOutlet weak var btnDelete:UIButton!
    @IBOutlet weak var btnEdit:UIButton!
    @IBOutlet weak var lblStatus:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

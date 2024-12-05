//
//  FreelauncerProgressTVC.swift
//  Munka
//
//  Created by Amit on 05/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class FreelauncerProgressTVC: UITableViewCell {
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lblStartDate:UILabel!
    @IBOutlet weak var btnCancel:UIButton!
    @IBOutlet weak var lblEndDate:UILabel!
      
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblJobTitle:UILabel!
    @IBOutlet weak var lblPostedDate:UILabel!
    @IBOutlet weak var lblstatus:UILabel!
    @IBOutlet weak var lblHour:UILabel!
  //  @IBOutlet weak var lblFix:UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

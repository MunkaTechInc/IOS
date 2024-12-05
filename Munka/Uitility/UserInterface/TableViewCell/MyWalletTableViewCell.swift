//
//  MyWalletTableViewCell.swift
//  Munka
//
//  Created by Amit on 29/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MyWalletTableViewCell: UITableViewCell {
    @IBOutlet weak var imgMyWallet:UIImageView!
        //   @IBOutlet weak var lblAmoutAdded:UILabel!
           @IBOutlet weak var lblDate:UILabel!
           @IBOutlet weak var lblBudget:UILabel!
           @IBOutlet weak var lblMessage:UILabel!
           @IBOutlet weak var lblTime:UILabel!
             @IBOutlet weak var lblTitle:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

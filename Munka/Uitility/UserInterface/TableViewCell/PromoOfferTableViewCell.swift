//
//  PromoOfferTableViewCell.swift
//  Munka
//
//  Created by Amit on 18/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class PromoOfferTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDec:UILabel!
    @IBOutlet weak var lblPromocode:UILabel!
    @IBOutlet weak var btnPromo:UIButton!
    @IBOutlet weak var btnTermsconditions:UIButton!
    @IBOutlet weak var lblOffers:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

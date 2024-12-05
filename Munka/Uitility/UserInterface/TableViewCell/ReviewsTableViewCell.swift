//
//  ReviewsTableViewCell.swift
//  Munka
//
//  Created by Amit on 25/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var lblRating:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var btnMsg:UIButton!
    @IBOutlet weak var imgReview:UIImageView!
    @IBOutlet weak var lblJobTitle:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

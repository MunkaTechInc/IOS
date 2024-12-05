//
//  SenderImageChatCellClass.swift
//  Munka
//
//  Created by Puneet Sharma on 16/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class SenderImageChatCellClass: UITableViewCell {
    
     //MARK:- Outlets
   @IBOutlet var imgViewSenderChatImage: UIImageView!
   @IBOutlet var lblSenderTime: UILabel!
    
    //MARK:- INIT
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

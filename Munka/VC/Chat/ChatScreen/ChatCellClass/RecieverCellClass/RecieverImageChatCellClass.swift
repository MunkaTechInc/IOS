//
//  RecieverImageChatCellClass.swift
//  Munka
//
//  Created by Puneet Sharma on 16/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class RecieverImageChatCellClass: UITableViewCell {

     //MARK:- Outlets
    @IBOutlet var imgViewReciverChatImage: UIImageView!
    @IBOutlet var lblrecieverTime: UILabel!
    
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

//
//  SenderChatCellClass.swift
//  SocketChatDemo
//
//  Created by Puneet Sharma on 10/12/19.
//  Copyright © 2019 Hitaishin. All rights reserved.
//

import UIKit

class SenderChatCellClass: UITableViewCell {
     //MARK:- Outlet
    @IBOutlet var lblSenderTxt: UILabel!
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

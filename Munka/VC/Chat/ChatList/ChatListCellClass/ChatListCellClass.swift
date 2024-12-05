//
//  ChatListCellClass.swift
//  Munka
//
//  Created by Puneet Sharma on 12/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class ChatListCellClass: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet var imgViewUserImage: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblJobTitle: UILabel!
    @IBOutlet var lblTimeAgo: UILabel!
    @IBOutlet var viewContentUnraedCount: IBView!
    @IBOutlet var lblUnreadCount: UILabel!
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

//
//  ProfileTableViewCell.swift
//  Munka
//
//  Created by Amit on 13/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
protocol getStatusOfSwitch : class {
    func didChangeSwitchState(sender: ProfileTableViewCell, isOn: Bool)
}
class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var switchNotification : UISwitch!
    weak var delegate: getStatusOfSwitch?
    var switchTag: Int = 0 // Add a property to store the tag value

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchNotification.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
     //   switchNotification.addTarget(self, action: "stateChanged:", for: UIControl.Event.valueChanged)

    }
    @IBAction func handledSwitchChange(sender: UISwitch) {
        if self.delegate != nil {
            //self.dismiss(animated: true, completion: nil)
            if switchTag == 1{
                self.delegate?.didChangeSwitchState(sender: self, isOn:switchNotification.isOn)
            }else{
                if MyDefaults().isBeiometicsAuthOn == true {
                    MyDefaults().isBeiometicsAuthOn = false
                }else{
                    MyDefaults().isBeiometicsAuthOn = true
                }
                print("on and off biometics authentication")
            }
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  PostJobHourlyTableViewCell.swift
//  Munka
//
//  Created by Namit Agrawal on 24/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
protocol GetCallDelegateOfTextField {
    func delegateDidBeginEditing(strData:String,index:Int)
    
}
class PostJobHourlyTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDates:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var btnStartTime:UIButton!
    @IBOutlet weak var btnEndTime:UIButton!
    var delagate: GetCallDelegateOfTextField!
    @IBOutlet weak var txtStartTime:UITextField!
    @IBOutlet weak var txtEndTime:UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        txtStartTime.inputView = DatePickerDialog()
//        txtEndTime.inputView = DatePickerDialog(
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnTimeTap(_ sender: UIButton) {
        
        if sender == btnStartTime{
            self.delagate.delegateDidBeginEditing(strData: "Start", index: btnStartTime.tag)
        }else if sender == btnEndTime{
            self.delagate.delegateDidBeginEditing(strData: "End", index: btnEndTime.tag)
        }
    }
}
/*
extension PostJobHourlyTableViewCell:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtStartTime {
            /*if self.delagate != nil {
             self.delagate.delegateDidBeginEditing(txtFiled: "Start", TagTextFiled: txtStartTime.tag)
             }*/
            txtStartTime.resignFirstResponder()

  
            
        }
        else if textField == txtEndTime {
            txtEndTime.resignFirstResponder()

         
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
}
*/

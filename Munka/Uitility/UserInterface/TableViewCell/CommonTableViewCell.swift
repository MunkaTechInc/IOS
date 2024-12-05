//
//  CommonTableViewCell.swift
//  FoodCart
//
//  Created by Namit Agrawal on 23/03/18.
//  Copyright © 2018 Hitaishin. All rights reserved.
//

import UIKit
//import AlamofireImage

class CommonTableViewCell: UITableViewCell {

    //COUNTRY
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    /// More Table Cell
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!

    /// Offer Cell
    @IBOutlet weak var lblOfferTitle: UILabel!
    @IBOutlet weak var lblOfferDescription: UILabel!
    @IBOutlet weak var lblOfferCode: UILabel!
    @IBOutlet weak var lblOfferPercentage: UILabel!
    @IBOutlet weak var btnCoppy: UIButton!

    /// Booking Cell
    @IBOutlet weak var lblPerson: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtProducts: UITextField!
    @IBOutlet weak var btnProducts: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var tableView: UITableView!

    //Booking Days Cell
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var txtDropOffDate: UITextField!
    @IBOutlet weak var txtPickupDate: UITextField!
    @IBOutlet weak var txtDropOffLocation: UITextField!
    @IBOutlet weak var txtPickupLocation: UITextField!
    @IBOutlet weak var txtDropOffTime: UITextField!
    @IBOutlet weak var txtPickupTime: UITextField!

    @IBOutlet weak var btnDropOffDate: UIButton!
    @IBOutlet weak var btnDropOffLocation: UIButton!
    @IBOutlet weak var btnPickupLocation: UIButton!
    @IBOutlet weak var btnDropOffTime: UIButton!
    @IBOutlet weak var btnPickupTime: UIButton!
    @IBOutlet weak var btnCrewMemberDetails: UIButton!
    @IBOutlet weak var btnDropOffScan: UIButton!
    @IBOutlet weak var btnPickupScan: UIButton!


    // My Booking Cell
    @IBOutlet weak var lblBookingDate: UILabel!
    @IBOutlet weak var lblBookingNumber: UILabel!
    @IBOutlet weak var lblSkiCount: UILabel!
    @IBOutlet weak var lblBookingStatus: UILabel!
    @IBOutlet weak var lblBookingStatusDot: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblProducts: UILabel!
    @IBOutlet weak var lblBookingType: UILabel!



    @IBOutlet weak var lblDropOffDate: UILabel!
    @IBOutlet weak var lblDropOffLocation: UILabel!
    @IBOutlet weak var lblPickupDate: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblSlotNumber: UILabel!
    
    @IBOutlet weak var personNameHeightConstrint: NSLayoutConstraint!

    /// FAQ
    @IBOutlet weak var tagTitle: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var firstIconPrice: UILabel!
    @IBOutlet weak var secondIconPrice: UILabel!
    
    // Payment
    @IBOutlet weak var lblSki: UILabel!
    @IBOutlet weak var lblSkiPrice: UILabel!
    
    @IBOutlet weak var checkBoxImage: UIImageView!

    //MARK:- Property
    var arrayDaysList : [AnyObject] = [AnyObject]()
    var selectedMainIndex : Int!
   // var selectedViewController : NewBookingViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Custom Action Methods

    func loadDaysData(_ daysList : [AnyObject], MainIndex index:Int)
    {
        self.selectedMainIndex = index
        self.arrayDaysList = daysList
        self.tableView.reloadData()
    }
    
    @IBAction func dropOffDateButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DropOffDate"), object: nil, userInfo: ["tag" : sender.tag])
    }
    
    @IBAction func dropOffLocationButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DropOffLocation"), object: nil, userInfo: ["tag" : sender.tag])
    }
    
    @IBAction func pickupLocationButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PickupLocation"), object: nil, userInfo: ["tag" : sender.tag])
    }
    
    @IBAction func dropOffTimeButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DropOffTime"), object: nil, userInfo: ["tag" : sender.tag])
    }
    
    @IBAction func pickupTimeButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PickupTime"), object: nil, userInfo: ["tag" : sender.tag])
    }
}

// MARK: - UITableView Delegate and DataSource

extension CommonTableViewCell : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrayDaysList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CommonTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! CommonTableViewCell
        
        let daysDict : [String : AnyObject] = self.arrayDaysList[indexPath.row] as! [String : AnyObject]
        cell.selectionStyle = .none

        cell.lblDay.text = "Day " + Global.getStringValue(daysDict["day"] as AnyObject)
        cell.txtDropOffDate.text = Global.getStringValue(daysDict["drop_off_date"] as AnyObject)
        cell.txtPickupDate.text = Global.getStringValue(daysDict["pick_up_date"] as AnyObject)
        cell.txtDropOffLocation.text = Global.getStringValue(daysDict["drop_off_location_name"] as AnyObject)
        cell.txtPickupLocation.text = Global.getStringValue(daysDict["pick_up_location_name"] as AnyObject)
        cell.txtDropOffTime.text = Global.getStringValue(daysDict["drop_off_time"] as AnyObject)
        cell.txtPickupTime.text = Global.getStringValue(daysDict["pick_up_time"] as AnyObject)
        
        cell.btnDropOffDate.tag = (self.selectedMainIndex * 1000) + indexPath.row
        cell.btnDropOffLocation.tag = (self.selectedMainIndex * 1000) + indexPath.row
        cell.btnPickupLocation.tag = (self.selectedMainIndex * 1000) + indexPath.row
        cell.btnDropOffTime.tag = (self.selectedMainIndex * 1000) + indexPath.row
        cell.btnPickupTime.tag = (self.selectedMainIndex * 1000) + indexPath.row

        if indexPath.row == 0
        {
            cell.btnDropOffDate.addTarget(self, action: #selector(self.dropOffDateButtonTapped(_:)), for: .touchUpInside)
        }
        
        cell.btnDropOffLocation.addTarget(self, action: #selector(self.dropOffLocationButtonTapped(_:)), for: .touchUpInside)
        cell.btnPickupLocation.addTarget(self, action: #selector(self.pickupLocationButtonTapped(_:)), for: .touchUpInside)
        cell.btnDropOffTime.addTarget(self, action: #selector(self.dropOffTimeButtonTapped(_:)), for: .touchUpInside)
        cell.btnPickupTime.addTarget(self, action: #selector(self.pickupTimeButtonTapped(_:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

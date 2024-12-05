//
//  ReceivedJobRequestTableViewCell.swift
//  Munka
//
//  Created by Amit on 02/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
protocol GetUserAction {
    func delegateForActionOnReceiveJob(tag:Int,isHire:Bool)
    func delegateForOnProfile(tag:Int)
}
class ReceivedJobRequestTableViewCell: UITableViewCell {
        @IBOutlet weak var lblJobType:UILabel!
        @IBOutlet weak var lblJobTitle:UILabel!
        @IBOutlet weak var lblPostedDate:UILabel!
        @IBOutlet weak var lblHours:UILabel!
        @IBOutlet weak var lblName:UILabel!
        @IBOutlet weak var collection:UICollectionView!
        @IBOutlet weak var btnJobDetails:UIButton!
        var delagate: GetUserAction!
        var ObjAppliedBy = [ModelAppliedBy]()
        var intTblIndexNumber = 0
        var intDenyNumber = 0
        var intGetProfile = 0

  //  var ObjrequestList = [ModelRequestList]()
    
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func reloadDataCollectionView(applyJob : [ModelAppliedBy]!)  {
        self.ObjAppliedBy = applyJob
        self.collection.delegate = self
        self.collection.dataSource = self
        print(applyJob.count)
        self.collection.reloadData()
}
}
    extension ReceivedJobRequestTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return ObjAppliedBy.count
        }
        // make a cell for each cell index path
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceivedJobCollectionCell", for: indexPath as IndexPath) as! ReceivedJobCollectionCell
           // cell.lblCategory.text = self.workerCategory[indexPath.row].serviceCategory
            cell.imgProfile.sd_setImage(with: URL(string:img_BASE_URL + self.ObjAppliedBy[indexPath.row].profilePic), placeholderImage:#imageLiteral(resourceName: "phl_employee_square.png"))
            
            if ObjAppliedBy[indexPath.row].status == "Rejected" {
//                cell.lblHightConstraints.constant = 0
//                cell.lblTopConstraints.constant = 108
                cell.btnRejected.setTitle("  Rejected  ", for: .normal)
                cell.btnRejected.setTitleColor(UIColor.hexStringToUIColor(hex: "#C7481A"), for: .normal)
                
                cell.btnRejected.isHidden = false
                cell.btnHier.isHidden = true
                cell.btnDeny.isHidden = true
             
                cell.btnRejected.layer.borderColor = UIColor.hexStringToUIColor(hex: "#C7481A").cgColor
                cell.btnRejected.backgroundColor = UIColor.white
                
            }
            else if ObjAppliedBy[indexPath.row].status == "Accepted" {
//                cell.lblHightConstraints.constant = 25
//                cell.lblTopConstraints.constant = 92
                cell.btnHier.setTitle("  Action  ", for: .normal)
                cell.btnHier.setTitleColor(UIColor.white, for: .normal)
                cell.btnHier.layer.borderColor = UIColor.hexStringToUIColor(hex: "#30A057").cgColor
                cell.btnRejected.isHidden = true
                cell.btnHier.isHidden = false
                cell.btnDeny.isHidden = false
                cell.btnHier.backgroundColor = UIColor.hexStringToUIColor(hex: "#30A057")
                
            }
            else if ObjAppliedBy[indexPath.row].status == "Pending" {
//                cell.lblHightConstraints.constant = 25
//                cell.lblTopConstraints.constant = 92
                cell.btnHier.setTitle(" Hier ", for: .normal)
                cell.btnHier.setTitleColor(UIColor.white, for: .normal)
                cell.btnHier.layer.borderColor = UIColor.hexStringToUIColor(hex: "#30A057").cgColor
                cell.btnRejected.isHidden = true
                cell.btnHier.isHidden = false
                cell.btnDeny.isHidden = false
                cell.btnHier.backgroundColor = UIColor.hexStringToUIColor(hex: "#30A057")
                
            }
           cell.btnHier.tag = intTblIndexNumber + indexPath.row + 1001
            //cell.btnHier.tag = indexPath.row + 10000
            cell.btnHier.addTarget(self, action: #selector(clickOnHier(sender:)), for: .touchUpInside)
            cell.btnDeny.tag = intDenyNumber + indexPath.row + 1001
            cell.btnDeny.addTarget(self, action: #selector(clickOnDeny(sender:)), for: .touchUpInside)
           cell.btnOnprofile.tag = intGetProfile + indexPath.row + 10001
           cell.btnOnprofile.addTarget(self, action: #selector(clickOnProfile(sender:)), for: .touchUpInside)
            if let rating = ObjAppliedBy[indexPath.row].rating {
                print(rating)
                print(rating.toLengthOf(strRating: rating))
                cell.lblRating.text =  rating.toLengthOf(strRating: rating)
                
            }
            
            return cell
            }
        @objc func clickOnHier(sender : UIButton){
            print(sender.tag - intTblIndexNumber)
            if self.delagate != nil {
                self.delagate.delegateForActionOnReceiveJob(tag: intTblIndexNumber, isHire: true)
                }
        }
        @objc func clickOnDeny(sender : UIButton){
            print(sender.tag - 1001)
            print(intDenyNumber - 1000)
            if self.delagate != nil {
                self.delagate.delegateForActionOnReceiveJob(tag: intDenyNumber - 1000, isHire: false)
        }
    }
        @objc func clickOnProfile(sender : UIButton){
            print(sender.tag - intTblIndexNumber)
            if self.delagate != nil {
                self.delagate.delegateForOnProfile(tag: intTblIndexNumber)
                }
        }
        // MARK: - UICollectionViewDelegate protocol
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
    }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let padding: CGFloat =  4.0
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/4, height: 164)
        }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let label = UILabel(frame: CGRect.zero)
//        label.text = workerCategory[indexPath.row].serviceCategory
//        label.sizeToFit()
//        return CGSize(width: label.frame.width, height: 32)
//    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
}
class ReceivedJobCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var btnDeny:UIButton!
    @IBOutlet weak var btnOnprofile:UIButton!
    @IBOutlet weak var btnRejected:UIButton!
    @IBOutlet weak var btnHier:UIButton!
    @IBOutlet weak var lblRating:UILabel!
//    @IBOutlet weak var lblHightConstraints: NSLayoutConstraint!
//    @IBOutlet weak var lblTopConstraints: NSLayoutConstraint!
}

//
//  MNViewAllVC.swift
//  Munka
//
//  Created by Amit on 25/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNViewAllVC: UIViewController {
@IBOutlet weak var tblAllReviews:UITableView!
    @IBOutlet weak var viewNointernetConnaction:UIView!
       @IBOutlet weak var viewNoDataFound:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if MyDefaults().swiftReviewList.count > 0 {
            self.tblAllReviews.delegate = self
            self.tblAllReviews.dataSource = self
        }else{
            self.tblAllReviews.isHidden = true
            self.viewNointernetConnaction.isHidden = false
            
        }
    
    }
    @IBAction func actionOnBack(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
       }
}
// MARK: - extension
extension MNViewAllVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 110
        }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyDefaults().swiftReviewList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ReviewsTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as? ReviewsTableViewCell
        
        cell?.lblName.text = MyDefaults().swiftReviewList[indexPath.row].senderName
        cell?.lblJobTitle.text = MyDefaults().swiftReviewList[indexPath.row].review
        let createDate = MyDefaults().swiftReviewList[indexPath.row].created!
        cell?.lblDate.text = self.convertDateFormater(createDate)
        cell?.lblName.text = MyDefaults().swiftReviewList[indexPath.row].senderName
        cell?.imgReview.sd_setImage(with: URL(string:img_BASE_URL + MyDefaults().swiftReviewList[indexPath.row].profilePic), placeholderImage:#imageLiteral(resourceName: "ic_individual"))
       
        cell?.btnMsg.setTitle(MyDefaults().swiftReviewList[indexPath.row].jobTitle, for: .normal)
        if let rating = MyDefaults().swiftReviewList[indexPath.row].rating {
                   cell?.floatRatingView.rating = Double(rating)!
               }
        let ratingPoint = MyDefaults().swiftReviewList[indexPath.row].rating
        cell?.lblRating.text = (ratingPoint ?? "") + "/" + "5"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.gettableViewindex(Tag: indexPath.row)
    
    }
    func convertDateFormater(_ strdate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
}

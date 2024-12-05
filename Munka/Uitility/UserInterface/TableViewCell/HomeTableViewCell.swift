//
//  HomeTableViewCell.swift
//  Munka
//
//  Created by Amit on 25/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var imgIndividual:UIImageView!
    @IBOutlet weak var lblEmployeeName:UILabel!
    @IBOutlet weak var lblJobsType:UILabel!
    @IBOutlet weak var lblHours:UILabel!
    @IBOutlet weak var lblHoursPerDoller:UILabel!
    var workerCategory = [ModelWorkerCategory]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getDataFromHome(workerCategory : [ModelWorkerCategory])  {
        self.workerCategory = workerCategory
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()

    }
}
extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.workerCategory.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobCollectionViewCell", for: indexPath as IndexPath) as! JobCollectionViewCell
        cell.lblCategory.text = self.workerCategory[indexPath.row].serviceCategory
        return cell
        }
        
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let padding: CGFloat =  10
//        let collectionViewSize = collectionView.frame.size.width - padding
//        return CGSize(width: 40.0, height: 268)
//    }

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let label = UILabel(frame: CGRect.zero)
    label.text = workerCategory[indexPath.row].serviceCategory
    label.sizeToFit()
    return CGSize(width: label.frame.width, height: 32)
}
}
class JobCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblCategory:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}

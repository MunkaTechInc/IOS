//
//  EliteEmployeeTableViewCell.swift
//  Munka
//
//  Created by Amit on 02/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class EliteEmployeeTableViewCell: UITableViewCell {
    @IBOutlet weak var imgElite:UIImageView!
    @IBOutlet weak var lblEliteName:UILabel!
    @IBOutlet weak var lblRating:UILabel!
    @IBOutlet weak var collectionView:UICollectionView!
    var EliteEmployee = [ModelWorkCategory]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
//    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
//        collectionView.delegate = dataSourceDelegate
//        collectionView.dataSource = dataSourceDelegate
//        collectionView.tag = row
//        collectionView.reloadData()
//    }
//    var collectionViewOffset: CGFloat {
//        set { collectionView.contentOffset.x = newValue }
//        get { return collectionView.contentOffset.x }
//    }
//    func configureCell() {
//        collectionView.reloadData()
//    }
    func reloadCollectionView(objElite:[ModelWorkCategory] ) -> Void {
        EliteEmployee = objElite
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setContentOffset(collectionView.contentOffset, animated:false)
        self.collectionView.reloadData()
    }
    func configureCell() {
        collectionView.reloadData()
    }
}
extension EliteEmployeeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.EliteEmployee.count
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EliteEmployeeCollectionViewCell", for: indexPath as IndexPath) as! EliteEmployeeCollectionViewCell
            cell.lblCategory.text = self.EliteEmployee[indexPath.row].serviceCategory
            return cell
        }
        // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let yourWidth = collectionView.bounds.width/3.0
//        let yourHeight = 120
//        let title = self.EliteEmployee[indexPath.item].serviceCategory
//        let text = NSAttributedString(string: title!)
//        return text.size()
//      //  return CGSize(width: text.size(), height: 30)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = self.EliteEmployee[indexPath.item].serviceCategory
        label.sizeToFit()
        return CGSize(width: label.frame.width + 4, height: 30)
    }
}
class EliteEmployeeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblCategory:UILabel!
}

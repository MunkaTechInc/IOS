//
//  MNAllEliteEmployeeVC.swift
//  Munka
//
//  Created by Amit on 02/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class MNAllEliteEmployeeVC: UIViewController {
    @IBOutlet weak var tblElite:UITableView!
    var EliteEmployee = [ModelEliteDetail]()
    var storedOffsets = [Int: CGFloat]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func actionOnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - extension
extension MNAllEliteEmployeeVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
//
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EliteEmployee.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : EliteEmployeeTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "EliteEmployeeTableViewCell", for: indexPath) as? EliteEmployeeTableViewCell
        cell?.lblEliteName.text = self.EliteEmployee[indexPath.row].fullName
         cell?.imgElite.sd_setImage(with: URL(string:img_BASE_URL + self.EliteEmployee[indexPath.row].profilePic), placeholderImage:#imageLiteral(resourceName: "phl_square_profile"))
        if let complete = self.EliteEmployee[indexPath.row].rating {
            print(complete)
            print(complete.toLengthOf(strRating: complete))
            cell?.lblRating.text =  complete.toLengthOf(strRating: complete)
            
        }
       // cell?.reloadCollectionView(objElite: [self.EliteEmployee[indexPath.row].workCategory])
        cell?.reloadCollectionView(objElite: self.EliteEmployee[indexPath.row].workCategory)
        cell?.configureCell()
        return cell!
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 110.0
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.gettableViewindex(Tag: indexPath.row)
    
    }
}

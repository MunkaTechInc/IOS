//
//  MNGraphListPopUPVC.swift
//  Munka
//
//  Created by Amit on 23/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
protocol getGraphType {
func delegateGraphType(strJob:String)

}
class MNGraphListPopUPVC: UIViewController {
var jobType:[String] = ["Monthly Analytics Report","Weekly Analytics Report","Yearly Analytics Report"]
  @IBOutlet weak var tblTyoe:UITableView!
     var delagate: getGraphType!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func touchOnView(_ sender: UIButton) {
               self.dismiss(animated: true, completion: nil)
           }
    }


// MARK: - extension
extension MNGraphListPopUPVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - Delegate method for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobType.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ViewAllTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "ViewAllTableViewCell", for: indexPath) as? ViewAllTableViewCell
        cell?.lblJobType.text = self.jobType[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = self.jobType[indexPath.row]
        if self.delagate != nil {
        self.dismiss(animated: true, completion: nil)
        self.delagate.delegateGraphType(strJob: job)
        }
    
    }
    
}
